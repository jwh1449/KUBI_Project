package com.springboot.joljak.controller;

import com.springboot.joljak.data.entity.User;
import com.springboot.joljak.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@Tag(name = "user-controller", description = "유저 관리 API")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // 유저 전체 조회
    @GetMapping
    @Operation(summary = "전체 유저 조회", description = "모든 유저를 조회합니다.")
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    // 유저 등록
    @PostMapping
    @Operation(summary = "유저 등록", description = "새로운 유저를 등록합니다.")
    public ResponseEntity<User> createUser(@RequestBody User user) {
        return ResponseEntity.ok(userService.createUser(user));
    }

    // 유저 수정
    @PutMapping("/{userIdEmail}")
    @Operation(summary = "유저 수정", description = "특정 유저를 수정합니다.")
    public ResponseEntity<User> updateUser(@PathVariable String userIdEmail, @RequestBody User userDetails) {
        return ResponseEntity.ok(userService.updateUser(userIdEmail, userDetails));
    }

    // 유저 삭제
    @DeleteMapping("/{userIdEmail}")
    @Operation(summary = "유저 삭제", description = "특정 유저를 삭제합니다.")
    public ResponseEntity<Void> deleteUser(@PathVariable String userIdEmail) {
        userService.deleteUser(userIdEmail);
        return ResponseEntity.noContent().build();
    }

    // 유저 이름으로 검색
    @GetMapping("/search")
    @Operation(summary = "유저 이름 검색", description = "이름에 특정 키워드를 포함하는 유저를 검색합니다.")
    public List<User> searchUsersByUsername(@RequestParam String username) {
        return userService.searchUsersByUsername(username);
    }
}
