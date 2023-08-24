package com.CatsArchive.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.CatsArchive.mapper.MemberMapper;

@Service
public class MemberService {

	@Autowired
	private MemberMapper mapper;

}
