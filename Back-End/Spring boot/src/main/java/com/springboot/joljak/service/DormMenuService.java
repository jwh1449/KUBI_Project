package com.springboot.joljak.service;

import com.springboot.joljak.data.entity.DormMenuData;
import com.springboot.joljak.data.repository.DormMenuRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DormMenuService {

    private final DormMenuRepository dormMenuRepository;

    public DormMenuService(DormMenuRepository dormMenuRepository) {
        this.dormMenuRepository = dormMenuRepository;
    }

    public List<DormMenuData> getAllDormMenus() {
        return dormMenuRepository.findAll();
    }

    public Optional<DormMenuData> getDormMenuById(Integer id) {
        return dormMenuRepository.findById(id);
    }

    public List<DormMenuData> getDormMenusByPartialDate(String partialDate) {
        return dormMenuRepository.findByMenuDateStartsWith(partialDate);
    }
}