package com.sms.student_management.model;

import jakarta.persistence.*;

@Entity
@Table(name = "attendance")
public class Attendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long studentId;
    private String subject;   // e.g. "Mathematics"
    private String type;      // "TH" or "PR"
    private int presentPeriods;
    private int totalPeriods;
    private double percentage;

    public Attendance() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getPresentPeriods() { return presentPeriods; }
    public void setPresentPeriods(int presentPeriods) { this.presentPeriods = presentPeriods; }

    public int getTotalPeriods() { return totalPeriods; }
    public void setTotalPeriods(int totalPeriods) { this.totalPeriods = totalPeriods; }

    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }
}
