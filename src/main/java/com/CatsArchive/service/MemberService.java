package com.CatsArchive.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.CatsArchive.mapper.MemberMapper;

@Service
public class MemberService {

	@Autowired
	private MemberMapper mapper;

	public String idDuplicateCheck(String email) {
		boolean isCheck = false;
		Map<String,Object> map = null;
		map = mapper.selectEmail(email);
		if (map == null) {
			return "false";
		} else {
			return "true";
		}
	}

}
