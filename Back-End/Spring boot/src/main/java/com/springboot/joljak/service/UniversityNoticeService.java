package com.springboot.joljak.service;

import com.springboot.joljak.data.entity.UniversityNotice;
import com.springboot.joljak.data.repository.UniversityNoticeRepository;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UniversityNoticeService {

    private final UniversityNoticeRepository universityNoticeRepository;

    public UniversityNoticeService(UniversityNoticeRepository universityNoticeRepository) {
        this.universityNoticeRepository = universityNoticeRepository;
    }

    public List<UniversityNotice> getAllNotices() {
        return universityNoticeRepository.findAllByOrderByDateDesc();
    }

    public Optional<UniversityNotice> getNoticeById(Integer id) {
        return universityNoticeRepository.findById(id);
    }

    // --- 한국어 제목 검색 관련 메서드 (기존 로직 유지) ---
    public List<UniversityNotice> searchNoticesByTitle(String keyword) {
        return universityNoticeRepository.findByTitleContainingIgnoreCaseOrderByDateDesc(keyword);
    }

    public List<UniversityNotice> searchNoticesByCampusAndTitle(String campus, String keyword) {
        List<UniversityNotice> result;

        if ("전체".equals(campus)) {
            result = universityNoticeRepository.findAllByOrderByDateDesc();
            if (StringUtils.hasText(keyword)) {
                result = result.stream()
                        .filter(notice -> notice.getTitle() != null && notice.getTitle().toLowerCase().contains(keyword.toLowerCase()))
                        .collect(Collectors.toList());
            }
        } else {
            if (!StringUtils.hasText(keyword)) {
                result = universityNoticeRepository.findByCampusOrderByDateDesc(campus);
            } else {
                result = universityNoticeRepository.findByCampusAndTitleContainingIgnoreCaseOrderByDateDesc(campus, keyword);
            }
        }
        return result;
    }

    // --- 영어 제목 검색 관련 메서드 (로직 수정) ---
    public List<UniversityNotice> searchNoticesByCampusAndTitleEn(String campus, String keyword) {
        List<UniversityNotice> baseNotices;

        if ("전체".equals(campus)) {
            baseNotices = universityNoticeRepository.findAllByOrderByDateDesc();
        } else {
            baseNotices = universityNoticeRepository.findByCampusOrderByDateDesc(campus);
        }

        // 가져온 공지사항 목록에서 영어 제목 필드로 필터링
        return baseNotices.stream()
                .filter(notice -> notice.getTitleEn() != null) // 영어 제목이 존재하는 공지사항만
                .filter(notice -> !StringUtils.hasText(keyword) || notice.getTitleEn().toLowerCase().contains(keyword.toLowerCase())) // 키워드가 없거나 키워드를 포함하는 경우
                .collect(Collectors.toList());
    }

    // --- 중국어 제목 검색 관련 메서드 (로직 수정) ---
    public List<UniversityNotice> searchNoticesByCampusAndTitleZh(String campus, String keyword) {
        List<UniversityNotice> baseNotices;

        if ("전체".equals(campus)) {
            baseNotices = universityNoticeRepository.findAllByOrderByDateDesc();
        } else {
            baseNotices = universityNoticeRepository.findByCampusOrderByDateDesc(campus);
        }

        // 가져온 공지사항 목록에서 중국어 제목 필드로 필터링
        return baseNotices.stream()
                .filter(notice -> notice.getTitleZh() != null) // 중국어 제목이 존재하는 공지사항만
                .filter(notice -> !StringUtils.hasText(keyword) || notice.getTitleZh().toLowerCase().contains(keyword.toLowerCase())) // 키워드가 없거나 키워드를 포함하는 경우
                .collect(Collectors.toList());
    }
}