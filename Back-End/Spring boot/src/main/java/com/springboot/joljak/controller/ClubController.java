package com.springboot.joljak.controller;

import com.springboot.joljak.data.entity.ClubActivity;
import com.springboot.joljak.service.ClubService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/clubs")
@Tag(name = "동아리 조회", description = "동아리 목록 및 검색 API")
public class ClubController {

    private final ClubService clubService;

    public ClubController(ClubService clubService) {
        this.clubService = clubService;
    }

    // 모든 동아리 조회
    @GetMapping
    @Operation(summary = "모든 동아리 조회", description = "모든 동아리 활동 목록을 조회합니다.")
    public List<ClubActivity> getAllClubs() {
        return clubService.getAllClubs();
    }

    // 동아리 이름으로 검색
    @GetMapping("/search/{keyword}")
    @Operation(summary = "동아리 이름 검색", description = "입력한 키워드가 포함된 동아리 이름을 조회합니다.")
    public List<ClubActivity> searchClubsByName(@PathVariable String keyword) {
        return clubService.searchClubsByName(keyword);
    }
}
