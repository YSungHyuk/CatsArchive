package com.CatsArchive.handler;

import java.util.Date;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendMailClient {
	public boolean sendMail(String email, String subject, String content) {
		boolean isSendSuccess = false;
		try {
			// 메일 전송 정보 설정
			Properties properties = System.getProperties();
			properties.put("mail.smtp.host", "smtp.gmail.com"); // 구글 SMTP 서버 주소
			properties.put("mail.smtp.auth", "true"); // SMTP 서버 접근시 인증 여부 설정
			properties.put("mail.smtp.port", "587"); // Gamil 서버의 서비스 포트 설정(TLS)
			// 메일 서버 인증 관련 추가 정보 설정
			properties.put("mail.smtp.starttls.enable", "true"); // TLS 인증 프로토콜 사용 여부 설정 
			properties.put("mail.smtp.ssl.protocols", "TLSv1.2"); // TLS 인증 프로토콜 버전 설정 
			// 메일 발송 과정에서 TLS 오류 발생시 사용
//		properties.put("mail.smtp.ssl.trust", "smtp.gmail.com"); // SSL 인증 신뢰 서버 주소 
			//
			
			// 3. 메일 서버 인증 정보 관리용 사용자 정의 클래스 인스턴스 생성 
			Authenticator authenticator = new GoogleMailAuthenticator();
			
			// 4. 자바 메일 전송 수행 session 객체 리턴
			Session mailSession = Session.getDefaultInstance(properties, authenticator);
			
			// 5. 서버 정보와 인증 정보를 관리할 객체 생성
			Message message = new MimeMessage(mailSession);
			
			// 6. 전송할 메일 정보 설정
			// 1) 발신자 정보 설정 (발신자 주소, 발신자 이름); 
			// 스팸 정책으로 인해 기본적인 방법으로는 발신자 주소 변경 불가
			Address senderAddress = new InternetAddress("dbstjdgur0@gmail.com", "CatsArchive");
			// 2) 수신자 정보 설정 ( 수신자 주소 ); 수신자가 없을경우 예외 발생
			Address receiverAddress = new InternetAddress(email);
			// 3) Message 객체를 통한 메일 내용 설정
			// 3-1) 메일 헤더 정보 설정
			message.setHeader("content-type", "text/html; charset=UTF-8");
			// 3-2) 발신자 정보 설정
			message.setFrom(senderAddress);
			// 3-3) 수신자 정보 설정 (TO: 수신자, CC: 참조, BCC: 숨은참조)
			message.addRecipient(RecipientType.TO, receiverAddress);
			// 3-4) 메일 제목 설정
			message.setSubject(subject);
			// 3-5) 메일 본문 설정 (본문, 컨텐츠 타입); 파일 전송을 할경우 Multipart 사용
			message.setContent(content ,"text/html; charset=UTF-8");
			// 3-6) 메일 전송 날짜 및 시간 설정
			message.setSentDate(new Date());
			// 3-7) 메일 전송; javax.mail.Transport.send(message);
			Transport.send(message);
			
			// 메일 발송 후 처리
			System.out.println("발송완료");
			isSendSuccess = true;
		} catch (Exception e) {
			e.printStackTrace();
			
			// 메일 발송 후 처리
			System.out.println("발송실패");
		}
		
		return isSendSuccess;
	}
}
