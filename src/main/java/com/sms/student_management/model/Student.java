package com.sms.student_management.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "students")
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    // Basic Information
    private String name;
    private String email;
    private String course;
    
    @Column(unique = true)
    private String username;

    // 5 Engineering Subjects (Max 100 each)
    private Double math;
    private Double physics;
    private Double programming;
    private Double electronics;
    private Double mechanics;

    // Calculated Academic Data
    private Double totalMarks; // Sum of the 5 subjects (Max 500)
    private Double attendance; // Percentage
    private String grade;
    
    // Attendance Tracking by Date
    private LocalDate attendanceUpdateDate;

    public Student() {
    }

    // --- Getters and Setters ---

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Double getMath() {
        return math;
    }

    public void setMath(Double math) {
        this.math = math;
    }

    public Double getPhysics() {
        return physics;
    }

    public void setPhysics(Double physics) {
        this.physics = physics;
    }

    public Double getProgramming() {
        return programming;
    }

    public void setProgramming(Double programming) {
        this.programming = programming;
    }

    public Double getElectronics() {
        return electronics;
    }

    public void setElectronics(Double electronics) {
        this.electronics = electronics;
    }

    public Double getMechanics() {
        return mechanics;
    }

    public void setMechanics(Double mechanics) {
        this.mechanics = mechanics;
    }

    public Double getTotalMarks() {
        return totalMarks;
    }

    public void setTotalMarks(Double totalMarks) {
        this.totalMarks = totalMarks;
    }

    public Double getAttendance() {
        return attendance;
    }

    public void setAttendance(Double attendance) {
        this.attendance = attendance;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public LocalDate getAttendanceUpdateDate() {
        return attendanceUpdateDate;
    }

    public void setAttendanceUpdateDate(LocalDate attendanceUpdateDate) {
        this.attendanceUpdateDate = attendanceUpdateDate;
    }
}