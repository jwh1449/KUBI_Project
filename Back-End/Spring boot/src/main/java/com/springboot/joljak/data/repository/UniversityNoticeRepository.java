package com.springboot.joljak.data.repository;

import com.springboot.joljak.data.entity.UniversityNotice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UniversityNoticeRepository extends JpaRepository<UniversityNotice, Integer> {
    // 한국어 제목 검색 (기존)
    List<UniversityNotice> findByTitleContainingIgnoreCaseOrderByDateDesc(String keyword);
    List<UniversityNotice> findByCampusAndTitleContainingIgnoreCaseOrderByDateDesc(String campus, String keyword);

    // 영어 제목 검색 (기존)
    List<UniversityNotice> findByTitleEnContainingIgnoreCaseOrderByDateDesc(String keyword);
    List<UniversityNotice> findByCampusAndTitleEnContainingIgnoreCaseOrderByDateDesc(String campus, String keyword);

    // 중국어 제목 검색 (기존)
    List<UniversityNotice> findByTitleZhContainingIgnoreCaseOrderByDateDesc(String keyword);
    List<UniversityNotice> findByCampusAndTitleZhContainingIgnoreCaseOrderByDateDesc(String campus, String keyword);

    // 모든 공지사항을 날짜(date) 기준으로 최신에서 오래된 순으로 정렬
    List<UniversityNotice> findAllByOrderByDateDesc();

    // 특정 캠퍼스의 모든 공지사항을 날짜(date) 기준으로 최신에서 오래된 순으로 정렬
    List<UniversityNotice> findByCampusOrderByDateDesc(String campus);
}