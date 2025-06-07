package com.springboot.joljak.service;

import com.springboot.joljak.data.entity.ClubActivity;
import com.springboot.joljak.data.repository.ClubRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClubService {

    private final ClubRepository clubRepository;

    public ClubService(ClubRepository clubRepository) {
        this.clubRepository = clubRepository;
    }

    // 모든 동아리 조회
    public List<ClubActivity> getAllClubs() {
        return clubRepository.findAll();
    }

    // 동아리 이름 검색
    public List<ClubActivity> searchClubsByName(String keyword) {
        return clubRepository.findByClubNameContainingIgnoreCase(keyword);
    }
}
