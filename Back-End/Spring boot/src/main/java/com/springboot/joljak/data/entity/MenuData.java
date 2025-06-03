package com.springboot.joljak.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "menu_data")
public class MenuData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "menu_id")
    private Integer menuId;

    @Column(name = "menu_date", length = 50)
    private String menuDate;

    @Column(name = "menu_type", length = 50)
    private String menuType;

    @Column(name = "meal_time", length = 50)
    private String mealTime;

    @Column(name = "menu_items", columnDefinition = "NVARCHAR(MAX)")
    private String menuItems;

    @Column(name = "menu_en", columnDefinition = "NVARCHAR(MAX)")
    private String menuEn;

    @Column(name = "menu_zh", columnDefinition = "NVARCHAR(MAX)")
    private String menuZh;
}
