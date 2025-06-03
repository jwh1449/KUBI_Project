package com.springboot.joljak.data.repository;

import com.springboot.joljak.data.entity.MenuData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MenuRepository extends JpaRepository<MenuData, Integer> {
    @Query("SELECT m FROM MenuData m WHERE m.menuDate LIKE CONCAT(:prefix, '%')")
    List<MenuData> findByMenuDateStartsWith(@Param("prefix") String prefix);
}
