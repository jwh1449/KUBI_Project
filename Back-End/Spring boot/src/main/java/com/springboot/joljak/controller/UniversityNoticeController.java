package com.springboot.joljak.controller;

import com.springboot.joljak.data.entity.UniversityNotice;
import com.springboot.joljak.service.UniversityNoticeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notices")
@Tag(name = "공지사항 조회", description = "대학 공지사항을 조회하는 API")
public class UniversityNoticeController {

    private final UniversityNoticeService universityNoticeService;

    public UniversityNoticeController(UniversityNoticeService universityNoticeService) {
        this.universityNoticeService = universityNoticeService;
    }

    @GetMapping
    @Operation(summary = "모든 공지사항 조회", description = "날짜 최신순으로 모든 공지사항을 조회합니다.")
    public List<UniversityNotice> getAllNotices() {
        return universityNoticeService.getAllNotices();
    }

    @GetMapping("/search")
    @Operation(summary = "캠퍼스 및 다국어 제목 키워드 검색", description = "특정 캠퍼스에서 입력한 키워드가 제목에 포함된 공지사항을 최신순으로 조회합니다. 키워드를 입력하지 않으면 해당 캠퍼스의 모든 공지사항을 조회합니다. 캠퍼스를 '전체'로 선택하면 모든 캠퍼스의 공지사항을 조회합니다. 'lang' 파라미터를 통해 검색할 제목의 언어를 지정할 수 있습니다 (ko, en, zh).")
    public List<UniversityNotice> searchNotices(
            @RequestParam @Parameter(description = "검색할 캠퍼스 이름 (예: 코로나19대응, 삼척·도계, 전체)", in = ParameterIn.QUERY) String campus,
            @RequestParam(required = false) @Parameter(description = "제목에 포함될 키워드 (선택 사항, 공백 시 해당 캠퍼스 전체 조회)", in = ParameterIn.QUERY) String keyword,
            @RequestParam(required = false, defaultValue = "ko") @Parameter(description = "검색할 제목의 언어 (ko, en, zh)", in = ParameterIn.QUERY) String lang) {

        if ("en".equalsIgnoreCase(lang)) {
            return universityNoticeService.searchNoticesByCampusAndTitleEn(campus, keyword);
        } else if ("zh".equalsIgnoreCase(lang)) {
            return universityNoticeService.searchNoticesByCampusAndTitleZh(campus, keyword);
        } else { // 기본값 또는 "ko"
            return universityNoticeService.searchNoticesByCampusAndTitle(campus, keyword);
        }
    }

    // 기존 /title/{keyword} 엔드포인트는 이제 위의 /search 엔드포인트로 통합되거나 제거될 수 있습니다.
    // 유지하고 싶다면, 해당 엔드포인트도 Lang 파라미터를 추가하거나, 아니면 그대로 두시면 됩니다.
    // @GetMapping("/title/{keyword}")
    // @Operation(summary = "제목 키워드 검색 (한국어 전용)", description = "입력한 키워드가 제목에 포함된 공지사항을 최신순으로 조회합니다.")
    // public List<UniversityNotice> searchNoticesByTitle(@PathVariable String keyword) {
    //     return universityNoticeService.searchNoticesByTitle(keyword);
    // }
}