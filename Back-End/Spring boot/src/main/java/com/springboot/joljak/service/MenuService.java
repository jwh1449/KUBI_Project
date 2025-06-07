package com.springboot.joljak.service;

import com.springboot.joljak.data.entity.MenuData;
import com.springboot.joljak.data.repository.MenuRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MenuService {

    private final MenuRepository menuRepository;

    public MenuService(MenuRepository menuRepository) {
        this.menuRepository = menuRepository;
    }

    public List<MenuData> getAllMenus() {
        return menuRepository.findAll();
    }

    public Optional<MenuData> getMenuById(Integer id) {
        return menuRepository.findById(id);
    }

    // 날짜별 메뉴 조회
    public List<MenuData> getMenusByPartialDate(String partialDate) {
        return menuRepository.findByMenuDateStartsWith(partialDate);
    }
}
