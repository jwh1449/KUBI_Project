package com.springboot.joljak.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "notices") // 변경된 테이블 이름
public class UniversityNotice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notice_id")
    private Integer noticeId;

    @Column(name = "campus", nullable = false, length = 100)
    private String campus;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "link", length = 500)
    private String link;

    @Column(name = "author", length = 100)
    private String author;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "content", columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Column(name = "content_en", columnDefinition = "NVARCHAR(MAX)")
    private String contentEn;

    @Column(name = "content_zh", columnDefinition = "NVARCHAR(MAX)")
    private String contentZh;

    @Column(name = "title_en", columnDefinition = "NVARCHAR(MAX)") // 새로 추가된 필드
    private String titleEn;

    @Column(name = "title_zh", columnDefinition = "NVARCHAR(MAX)") // 새로 추가된 필드
    private String titleZh;
}