package com.CatsArchive.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {

	Map<String, Object> selectEmail(String email);

}
