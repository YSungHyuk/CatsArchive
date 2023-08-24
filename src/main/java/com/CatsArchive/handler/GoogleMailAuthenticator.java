package com.CatsArchive.handler;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

// 자바 메일 기능 사용; 메일서버 인증을 위한 정보 관리 용도
public class GoogleMailAuthenticator extends Authenticator {
	private PasswordAuthentication passwordAuthentication;

	private String sender = "dbstjdgur0";
	
	public GoogleMailAuthenticator() {
		passwordAuthentication = new PasswordAuthentication(sender, "xslvwtcdpwqdzgqk");
	}

	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return passwordAuthentication;
	}

	public String getSender() {
		return sender;
	}
	
}
