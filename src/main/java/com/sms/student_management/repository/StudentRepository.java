package com.sms.student_management.repository;

import com.sms.student_management.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    // This custom method allows us to find a student by their login username
    // Spring Boot automatically generates the SQL for this!
    Student findByUsername(String username);
}