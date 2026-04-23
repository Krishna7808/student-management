package com.sms.student_management.controller;

import com.sms.student_management.model.Marks;
import com.sms.student_management.model.Attendance;
import com.sms.student_management.repository.MarksRepository;
import com.sms.student_management.repository.AttendanceRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller
public class MarksController {

    @Autowired
    private MarksRepository marksRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @GetMapping("/addMarks/{id}")
    public String showAddMarksForm(@PathVariable long id, Model model, HttpSession session) {
        if (!"FACULTY".equals(session.getAttribute("userRole"))) return "redirect:/";
        Marks marks = new Marks();
        marks.setStudentId(id);
        model.addAttribute("marks", marks);
        return "add_marks";
    }

    @PostMapping("/saveMarks")
    public String saveMarks(@ModelAttribute("marks") Marks marks, HttpSession session) {
        if (!"FACULTY".equals(session.getAttribute("userRole"))) return "redirect:/";
        marksRepository.save(marks);
        return "redirect:/";
    }

    @GetMapping("/viewRecords/{id}")
    public String viewStudentRecords(@PathVariable long id, Model model, HttpSession session) {
        if (session.getAttribute("userRole") == null) return "redirect:/login";

        // --- MARKS ---
        List<Marks> studentMarks = marksRepository.findByStudentId(id);
        int totalObtained = studentMarks.stream().mapToInt(Marks::getObtainedMarks).sum();
        int totalMax      = studentMarks.stream().mapToInt(Marks::getMaxMarks).sum();
        double academicPercent = totalMax > 0 ? ((double) totalObtained / totalMax) * 100 : 0;

        // --- ATTENDANCE ---
        List<Attendance> allAtt = attendanceRepository.findByStudentId(id);

        // Group by subject
        Map<String, List<Attendance>> bySubject = allAtt.stream()
            .collect(Collectors.groupingBy(Attendance::getSubject));

        // Build ordered subject list matching marks subjects
        List<String> subjects = Arrays.asList("Mathematics","Physics","Programming","Electronics","Mechanics");

        // Build structured rows for JSP table: each entry = {subject, th, pr}
        List<Map<String, Object>> attRows = new ArrayList<>();
        for (String sub : subjects) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("subject", sub);
            List<Attendance> subList = bySubject.getOrDefault(sub, Collections.emptyList());
            Attendance th = subList.stream().filter(a -> "TH".equals(a.getType())).findFirst().orElse(null);
            Attendance pr = subList.stream().filter(a -> "PR".equals(a.getType())).findFirst().orElse(null);
            row.put("th", th);
            row.put("pr", pr);
            attRows.add(row);
        }

        // Totals
        List<Attendance> thList = allAtt.stream().filter(a -> "TH".equals(a.getType())).collect(Collectors.toList());
        List<Attendance> prList = allAtt.stream().filter(a -> "PR".equals(a.getType())).collect(Collectors.toList());
        int thPresent = thList.stream().mapToInt(Attendance::getPresentPeriods).sum();
        int thTotal   = thList.stream().mapToInt(Attendance::getTotalPeriods).sum();
        int prPresent = prList.stream().mapToInt(Attendance::getPresentPeriods).sum();
        int prTotal   = prList.stream().mapToInt(Attendance::getTotalPeriods).sum();
        double thPct  = thTotal > 0 ? Math.round(((double) thPresent / thTotal) * 10000.0) / 100.0 : 0;
        double prPct  = prTotal > 0 ? Math.round(((double) prPresent / prTotal) * 10000.0) / 100.0 : 0;
        double allPct = (thTotal + prTotal) > 0
            ? Math.round(((double)(thPresent + prPresent) / (thTotal + prTotal)) * 10000.0) / 100.0 : 0;

        // Chart data — TH percentages per subject
        StringBuilder chartLabels  = new StringBuilder();
        StringBuilder chartThPct   = new StringBuilder();
        StringBuilder chartPrPct   = new StringBuilder();
        for (int i = 0; i < subjects.size(); i++) {
            String sub = subjects.get(i);
            List<Attendance> subList = bySubject.getOrDefault(sub, Collections.emptyList());
            Attendance th = subList.stream().filter(a -> "TH".equals(a.getType())).findFirst().orElse(null);
            Attendance pr = subList.stream().filter(a -> "PR".equals(a.getType())).findFirst().orElse(null);
            if (i > 0) { chartLabels.append(","); chartThPct.append(","); chartPrPct.append(","); }
            chartLabels.append("'").append(sub).append("'");
            chartThPct.append(th != null ? th.getPercentage() : 0);
            chartPrPct.append(pr != null ? pr.getPercentage() : 0);
        }

        model.addAttribute("marksList",       studentMarks);
        model.addAttribute("totalObtained",   totalObtained);
        model.addAttribute("totalMax",         totalMax);
        model.addAttribute("academicPercent", String.format("%.2f", academicPercent));
        model.addAttribute("attRows",          attRows);
        model.addAttribute("thPresent",        thPresent);
        model.addAttribute("thTotal",          thTotal);
        model.addAttribute("thPct",            thPct);
        model.addAttribute("prPresent",        prPresent);
        model.addAttribute("prTotal",          prTotal);
        model.addAttribute("prPct",            prPct);
        model.addAttribute("allPresent",       thPresent + prPresent);
        model.addAttribute("allTotal",         thTotal + prTotal);
        model.addAttribute("allPct",           allPct);
        model.addAttribute("chartLabels",      chartLabels.toString());
        model.addAttribute("chartThPct",       chartThPct.toString());
        model.addAttribute("chartPrPct",       chartPrPct.toString());
        model.addAttribute("studentId",        id);

        return "view_records";
    }
}
