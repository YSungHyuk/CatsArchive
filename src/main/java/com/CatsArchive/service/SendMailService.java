package com.CatsArchive.service;

import org.springframework.stereotype.Service;

import com.CatsArchive.handler.GenerateRandomCode;
import com.CatsArchive.handler.SendMailClient;

@Service
public class SendMailService {
	
//	@Autowired
//	private
	
	public String sendAuthMail(String email) {
		boolean isSendSuccess = false;
		String authCode = GenerateRandomCode.getRandomCode(50);
		
		String subject = "[CatsArchive] 이메일 인증 번호입니다.";
		String content = "[ "+authCode+" ]" 
				+ "인증번호를 입력해주세요.";
		
		SendMailClient sendMailClient = new SendMailClient();
		isSendSuccess = sendMailClient.sendMail(email, subject, content);
		
		if (isSendSuccess) {
			return authCode;
		} else {
			return "";
		}
	}
}
