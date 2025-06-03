package com.springboot.joljak.controller;

import com.springboot.joljak.data.entity.MenuData;
import com.springboot.joljak.service.MenuService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/menus")
@Tag(name = "학식 메뉴 조회", description = "학식 메뉴를 조회하는 API")
public class MenuController {

    private final MenuService menuService;

    public MenuController(MenuService menuService) {
        this.menuService = menuService;
    }

    @GetMapping
    @Operation(summary = "모든 메뉴 조회", description = "전체 학식 메뉴 리스트를 조회합니다.")
    public List<MenuData> getAllMenus() {
        return menuService.getAllMenus();
    }

    @GetMapping("/date/{partialDate}")
    @Operation(summary = "날짜로 메뉴 조회 (요일 생략 가능)", description = "특정 날짜로 시작하는 메뉴 정보를 조회합니다.")
    public List<MenuData> getMenuByPartialDate(@PathVariable String partialDate) {
        return menuService.getMenusByPartialDate(partialDate);
    }
}
