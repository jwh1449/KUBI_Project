package com.springboot.joljak.data.repository;

import com.springboot.joljak.data.entity.ClubActivity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClubRepository extends JpaRepository<ClubActivity, Integer> {

    // 🔥 동아리 이름에 특정 단어가 포함된 목록 조회
    List<ClubActivity> findByClubNameContainingIgnoreCase(String keyword);
}
