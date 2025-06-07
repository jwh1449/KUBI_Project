package com.springboot.joljak.service;

import com.springboot.joljak.data.entity.User;
import com.springboot.joljak.data.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 유저 전체 조회
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // 유저 등록
    public User createUser(User user) {
        return userRepository.save(user);
    }

    // 유저 수정
    public User updateUser(String userIdEmail, User userDetails) {
        Optional<User> optionalUser = userRepository.findById(userIdEmail);
        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            user.setUsername(userDetails.getUsername());
            user.setPassword(userDetails.getPassword());
            user.setPhoneNumber(userDetails.getPhoneNumber());
            user.setNationality(userDetails.getNationality());
            user.setMajor(userDetails.getMajor());
            user.setSelectedLanguage(userDetails.getSelectedLanguage());
            return userRepository.save(user);
        } else {
            throw new RuntimeException("User not found with email: " + userIdEmail);
        }
    }

    // 유저 삭제
    public void deleteUser(String userIdEmail) {
        userRepository.deleteById(userIdEmail);
    }

    // 유저 이름으로 검색
    public List<User> searchUsersByUsername(String username) {
        return userRepository.findByUsernameContainingIgnoreCase(username);
    }
}
