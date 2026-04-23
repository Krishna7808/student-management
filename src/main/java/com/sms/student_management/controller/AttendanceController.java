package com.sms.student_management.controller;

import com.sms.student_management.model.Attendance;
import com.sms.student_management.repository.AttendanceRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@Controller
public class AttendanceController {

    @Autowired
    private AttendanceRepository attendanceRepository;

    // Subjects matching the Student model marks fields
    private static final List<String> SUBJECTS = Arrays.asList(
        "Mathematics", "Physics", "Programming", "Electronics", "Mechanics"
    );

    @GetMapping("/markAttendance/{id}")
    public String showAttendanceForm(@PathVariable long id, Model model, HttpSession session) {
        if (!"FACULTY".equals(session.getAttribute("userRole"))) {
            return "redirect:/";
        }

        // Fetch existing records for this student
        List<Attendance> existing = attendanceRepository.findByStudentId(id);

        // Build a 2D structure: for each subject, TH and PR
        // Pass subjects list and existing data to JSP
        model.addAttribute("studentId", id);
        model.addAttribute("subjects", SUBJECTS);
        model.addAttribute("existingRecords", existing);
        return "mark_attendance";
    }

    @PostMapping("/saveAttendance")
    public String saveAttendance(
            @RequestParam long studentId,
            @RequestParam(value = "subject") String[] subjects,
            @RequestParam(value = "type") String[] types,
            @RequestParam(value = "presentPeriods") int[] presentPeriods,
            @RequestParam(value = "totalPeriods") int[] totalPeriods,
            HttpSession session) {

        if (!"FACULTY".equals(session.getAttribute("userRole"))) {
            return "redirect:/";
        }

        // Delete old attendance records for this student and re-save fresh
        List<Attendance> old = attendanceRepository.findByStudentId(studentId);
        attendanceRepository.deleteAll(old);

        for (int i = 0; i < subjects.length; i++) {
            Attendance att = new Attendance();
            att.setStudentId(studentId);
            att.setSubject(subjects[i]);
            att.setType(types[i]);
            att.setPresentPeriods(presentPeriods[i]);
            att.setTotalPeriods(totalPeriods[i]);

            double pct = (totalPeriods[i] > 0)
                ? Math.round(((double) presentPeriods[i] / totalPeriods[i]) * 10000.0) / 100.0
                : 0.0;
            att.setPercentage(pct);

            attendanceRepository.save(att);
        }

        return "redirect:/";
    }
}
