package com.springboot.joljak.dto;

public class ClubRequestDto {
    private String clubName;
    private String clubCategory;
    private String clubDescription;
    private String clubDescriptionEn;
    private String clubDescriptionZh;

    // Getter & Setter
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
}
