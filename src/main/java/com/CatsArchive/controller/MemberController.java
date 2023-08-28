package com.CatsArchive.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
}
