package com.CatsArchive.service;

import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

@Service
public class RedisService {

	private static final Logger logger = LoggerFactory.getLogger(RedisService.class);
	
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

//    // 이메일, 인증번호 저장
//    public void saveEmailVerificationCode(String email, String code) {
//        ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
//        valueOperations.set(email, code, 3, TimeUnit.MINUTES); // 3분 후 만료
//    }
    public void saveEmailVerificationCode(String email, String code) {
        ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();

        logger.info("Saving email:{} and code:{}", email, code);

        valueOperations.set(email, code, 3, TimeUnit.MINUTES);

        logger.info("Email saved with expiration in 3 minutes");
    }
    
    
    // 이메일, 인증번호 확인
    public String getEmailVerificationCode(String email) {
        ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        return String.valueOf(valueOperations.get(email));
    }
}
