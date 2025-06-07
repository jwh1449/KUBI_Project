package com.springboot.joljak.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "dormitory_menu") // 기숙사 메뉴 테이블 이름
public class DormMenuData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id") // menus 테이블의 id 컬럼과 동일하게 설정
    private Integer id;

    @Column(name = "menu_date", length = 50)
    private String menuDate;

    @Column(name = "meal_time", length = 50)
    private String mealTime;

    @Column(name = "menu_items", columnDefinition = "NVARCHAR(MAX)")
    private String menuItems;

    @Column(name = "menu_en", columnDefinition = "NVARCHAR(MAX)")
    private String menuEn;

    @Column(name = "menu_zh", columnDefinition = "NVARCHAR(MAX)")
    private String menuZh;
}