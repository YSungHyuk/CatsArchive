package com.CatsArchive.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {

	Map<String, Object> selectEmail(String email);

	int insertMember(Map<String, Object> map);

	String selectPasswd(Map<String, Object> map);

}
