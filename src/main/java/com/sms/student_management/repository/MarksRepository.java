package com.sms.student_management.repository;

import com.sms.student_management.model.Marks;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MarksRepository extends JpaRepository<Marks, Long> {
    // This custom method helps find all marks belonging to ONE specific student
    List<Marks> findByStudentId(Long studentId);
}