package com.springboot.joljak.data.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "club_activities") // 실제 테이블 이름
public class ClubActivity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "club_id")
    private Integer clubId;

    @Column(name = "club_name", nullable = false, length = 100)
    private String clubName;

    @Column(name = "club_category", nullable = false, length = 50)
    private String clubCategory;

    @Column(name = "club_description", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String clubDescription;

    @Column(name = "club_description_en", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String clubDescriptionEn;

    @Column(name = "club_description_zh", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String clubDescriptionZh;

    // Getter & Setter
    public Integer getClubId() { return clubId; }
    public void setClubId(Integer clubId) { this.clubId = clubId; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }

    public String getClubCategory() { return clubCategory; }
    public void setClubCategory(String clubCategory) { this.clubCategory = clubCategory; }

    public String getClubDescription() { return clubDescription; }
    public void setClubDescription(String clubDescription) { this.clubDescription = clubDescription; }

    public String getClubDescriptionEn() { return clubDescriptionEn; }
    public void setClubDescriptionEn(String clubDescriptionEn) { this.clubDescriptionEn = clubDescriptionEn; }

    public String getClubDescriptionZh() { return clubDescriptionZh; }
    public void setClubDescriptionZh(String clubDescriptionZh) { this.clubDescriptionZh = clubDescriptionZh; }

    @Override
    public String toString() {
        return "Club{" +
                "clubId=" + clubId +
                ", clubName='" + clubName + '\'' +
                ", clubCategory='" + clubCategory + '\'' +
                ", clubDescription='" + clubDescription + '\'' +
                ", clubDescriptionEn='" + clubDescriptionEn + '\'' +
                ", clubDescriptionZh='" + clubDescriptionZh + '\'' +
                '}';
    }
}
