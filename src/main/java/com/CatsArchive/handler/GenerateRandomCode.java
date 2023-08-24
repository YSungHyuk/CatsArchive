package com.CatsArchive.handler;

import org.apache.commons.lang3.RandomStringUtils;

public class GenerateRandomCode {
	public static String getRandomCode(int length) {
		return RandomStringUtils.randomAlphanumeric(length);	
	}
	 
}
