package com.CatsArchive.controller;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.CatsArchive.handler.MyPasswordEncoder;
import com.CatsArchive.service.MemberService;
import com.CatsArchive.service.RedisService;
import com.CatsArchive.service.SendMailService;

@Controller
public class MemberController {

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	private MemberService service;
	@Autowired
	private RedisService redis;
	
	@ResponseBody
	@GetMapping("AuthMailSend")
	public String authMailSend(
			@RequestParam(defaultValue = "") String email) {
		
		SendMailService mailService = new SendMailService();
		String authCode = mailService.sendAuthMail(email);
		
		if (authCode.equals("")) {
			return "false";
		} else {
			redis.saveEmailVerificationCode(email, authCode);
			return "true";
		}
	}
	
	@ResponseBody
	@GetMapping("AuthMailCheck")
	public String authMailCheck(
			@RequestParam String email
			, @RequestParam String authCode) {
		
		String storedVerificationCode = redis.getEmailVerificationCode(email);
		if (storedVerificationCode != null && !storedVerificationCode.equals("null")) {
//		    logger.info("인증 코드: " + storedVerificationCode);
		    if(storedVerificationCode.equals(authCode)) {
		    	return "true";
		    } else {
//		    	logger.info("인증 코드 불일치");
		    	return "false";
		    }
		} else {
//		    logger.info("인증 코드를 찾을 수 없음");
		    return "false";
		}
	}
	
	@ResponseBody
	@GetMapping("idDuplicateCheck")
	public String idDuplicateCheck(
			@RequestParam String email) {
		
		return service.idDuplicateCheck(email);
	}
	
	@ResponseBody
	@PostMapping("JoinMemberShip")
	public String joinMemberShip(
			@RequestParam Map<String, Object> map) {
		
		logger.info(map.toString());
		
		MyPasswordEncoder encoder = new MyPasswordEncoder();
		
		String securePasswd = encoder.getCryptoPassword(String.valueOf(map.get("passwd")));
		map.put("securePasswd", securePasswd);
		
		logger.info(map.toString());
		
		int insertCount = service.joinMember(map);
		
		if(insertCount > 0) {
			logger.info("회원가입완료");
			return "true";
		} else {
			logger.info("회원가입실패");
			return "false";
		}
	}
	
	@ResponseBody
	@GetMapping("LoginMember")
	public String loginMember(
			@RequestParam Map<String, Object> map
			, HttpSession session
			, HttpServletResponse response) {
		
		logger.info(map.toString());
		
		MyPasswordEncoder encoder = new MyPasswordEncoder();
		
		String securePasswd = service.getPasswd(map);
		
		if(!encoder.isSameCryptoPassword(String.valueOf(map.get("passwd")), securePasswd)) {
			logger.info("로그인 실패");
			return "false";
		} else {
			logger.info("로그인 성공");
			session.setAttribute("sId", map.get("email"));
			Cookie cookie = new Cookie("REMEMBER_ID", String.valueOf(map.get("email")));
			if (map.get("rememberId").equals("true")) {
				cookie.setMaxAge(60 * 60 * 24 * 30);
			} else {
				cookie.setMaxAge(0);
			}
			response.addCookie(cookie);
			return "true";
		}
	}
	
	@GetMapping("MemberLogout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
}
