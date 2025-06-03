package com.springboot.joljak.data.repository;

import com.springboot.joljak.data.entity.DormMenuData;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DormMenuRepository extends JpaRepository<DormMenuData, Integer> {
    List<DormMenuData> findByMenuDateStartsWith(String prefix);
}