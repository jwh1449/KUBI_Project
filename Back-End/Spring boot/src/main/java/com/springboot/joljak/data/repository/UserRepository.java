package com.springboot.joljak.data.repository;

import com.springboot.joljak.data.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<User, String> {

    // username에 특정 문자열이 포함된 유저 검색
    List<User> findByUsernameContainingIgnoreCase(String username);
}
