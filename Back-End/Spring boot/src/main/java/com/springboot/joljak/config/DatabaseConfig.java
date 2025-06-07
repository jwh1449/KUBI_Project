package com.springboot.joljak.config;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class DatabaseConfig {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostConstruct
    public void testConnection() {
        try {
            // PostgreSQL에 맞는 SQL 쿼리로 변경: SELECT NOW() 또는 SELECT CURRENT_TIMESTAMP
            String result = jdbcTemplate.queryForObject("SELECT NOW()", String.class);
            System.out.println("PostgreSQL 연결 성공! 현재 시간: " + result);
        } catch (Exception e) {
            System.err.println("PostgreSQL 연결 실패: " + e.getMessage());
        }
    }
}