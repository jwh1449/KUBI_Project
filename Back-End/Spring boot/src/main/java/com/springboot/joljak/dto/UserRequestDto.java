package com.springboot.joljak.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRequestDto {

    private String userIdEmail;

    private String username;
    private String password;
    private String phoneNumber;
    private String selectedLanguage;
    private String nationality;
    private String major;
}
