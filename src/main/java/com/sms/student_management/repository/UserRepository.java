package com.sms.student_management.repository;

import com.sms.student_management.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // This allows the controller to find the user during login
    User findByUsername(String username);
}