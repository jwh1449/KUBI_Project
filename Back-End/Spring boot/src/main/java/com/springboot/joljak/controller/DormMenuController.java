package com.springboot.joljak.controller;

import com.springboot.joljak.data.entity.DormMenuData;
import com.springboot.joljak.service.DormMenuService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/dormmenus")
@Tag(name = "기숙사 메뉴 조회", description = "기숙사 메뉴를 조회하는 API")
public class DormMenuController {

    private final DormMenuService dormMenuService;

    public DormMenuController(DormMenuService dormMenuService) {
        this.dormMenuService = dormMenuService;
    }

    @GetMapping
    @Operation(summary = "모든 기숙사 메뉴 조회", description = "전체 기숙사 메뉴 리스트를 조회합니다.")
    public List<DormMenuData> getAllDormMenus() {
        return dormMenuService.getAllDormMenus();
    }

    @GetMapping("/date/{partialDate}")
    @Operation(summary = "날짜로 기숙사 메뉴 조회 (요일 생략 가능)", description = "특정 날짜로 시작하는 기숙사 메뉴 정보를 조회합니다.")
    public List<DormMenuData> getDormMenusByPartialDate(@PathVariable String partialDate) {
        return dormMenuService.getDormMenusByPartialDate(partialDate);
    }
}