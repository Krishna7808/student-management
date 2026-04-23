package com.sms.student_management.controller;

import com.sms.student_management.model.Attendance;
import com.sms.student_management.model.Student;
import com.sms.student_management.repository.AttendanceRepository;
import com.sms.student_management.repository.StudentRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class StudentController {

    @Autowired private StudentRepository studentRepository;
    @Autowired private AttendanceRepository attendanceRepository;

    private static final List<String> SUBJECTS =
        Arrays.asList("Mathematics","Physics","Programming","Electronics","Mechanics");

    // ── Builds per-student attendance rows + chart string data ──────────────
    private void enrichStudents(List<Student> students, Model model) {
        // For each student, build attendanceData, chartLabels, chartThPct, chartPrPct
        // We store these as per-student maps keyed by student id
        Map<Long, List<Map<String,Object>>> attDataMap    = new LinkedHashMap<>();
        Map<Long, String>                  chartLabelsMap = new LinkedHashMap<>();
        Map<Long, String>                  chartThMap     = new LinkedHashMap<>();
        Map<Long, String>                  chartPrMap     = new LinkedHashMap<>();

        for (Student s : students) {
            List<Attendance> allAtt = attendanceRepository.findByStudentId(s.getId());
            Map<String, List<Attendance>> bySubject = allAtt.stream()
                .collect(Collectors.groupingBy(Attendance::getSubject));

            List<Map<String,Object>> rows = new ArrayList<>();
            StringBuilder labels = new StringBuilder();
            StringBuilder thPcts = new StringBuilder();
            StringBuilder prPcts = new StringBuilder();

            for (int i = 0; i < SUBJECTS.size(); i++) {
                String sub = SUBJECTS.get(i);
                List<Attendance> subList = bySubject.getOrDefault(sub, Collections.emptyList());
                Attendance th = subList.stream().filter(a -> "TH".equals(a.getType())).findFirst().orElse(null);
                Attendance pr = subList.stream().filter(a -> "PR".equals(a.getType())).findFirst().orElse(null);

                Map<String,Object> row = new LinkedHashMap<>();
                row.put("subject", sub);
                row.put("th", th);
                row.put("pr", pr);
                rows.add(row);

                if (i > 0) { labels.append(","); thPcts.append(","); prPcts.append(","); }
                labels.append("'").append(sub.substring(0,4)).append("'");
                thPcts.append(th != null ? th.getPercentage() : 0);
                prPcts.append(pr != null ? pr.getPercentage() : 0);
            }

            attDataMap.put(s.getId(), rows);
            chartLabelsMap.put(s.getId(), labels.toString());
            chartThMap.put(s.getId(), thPcts.toString());
            chartPrMap.put(s.getId(), prPcts.toString());
        }

        model.addAttribute("attDataMap",    attDataMap);
        model.addAttribute("chartLabelsMap", chartLabelsMap);
        model.addAttribute("chartThMap",    chartThMap);
        model.addAttribute("chartPrMap",    chartPrMap);
    }

    @GetMapping("/")
    public String viewHomePage(Model model, HttpSession session) {
        String role     = (String) session.getAttribute("userRole");
        String username = (String) session.getAttribute("userName");
        if (role == null) return "redirect:/login";

        List<Student> students;
        if ("FACULTY".equals(role)) {
            students = studentRepository.findAll();
        } else {
            Student s = studentRepository.findByUsername(username);
            students = s != null ? Collections.singletonList(s) : Collections.emptyList();
        }
        model.addAttribute("listStudents", students);
        enrichStudents(students, model);
        return "new_student";
    }

    @GetMapping("/showNewStudentForm")
    public String showNewStudentForm(Model model, HttpSession session) {
        if (!"FACULTY".equals(session.getAttribute("userRole"))) return "redirect:/";
        List<Student> students = studentRepository.findAll();
        model.addAttribute("listStudents", students);
        model.addAttribute("student", new Student());
        model.addAttribute("showForm", true);
        model.addAttribute("formType", "BASIC");
        enrichStudents(students, model);
        return "new_student";
    }

    @GetMapping("/showAddMarksForm/{id}")
    public String showAddMarksForm(@PathVariable long id, Model model, HttpSession session) {
        if (!"FACULTY".equals(session.getAttribute("userRole"))) return "redirect:/";
        List<Student> students = studentRepository.findAll();
        Student student = studentRepository.findById(id).orElseThrow();
        model.addAttribute("listStudents", students);
        model.addAttribute("student", student);
        model.addAttribute("showForm", true);
        model.addAttribute("formType", "MARKS");
        enrichStudents(students, model);
        return "new_student";
    }

    @PostMapping("/saveStudent")
    public String saveStudent(@ModelAttribute("student") Student student, HttpSession session) {
        if (!"FACULTY".equals(session.getAttribute("userRole"))) return "redirect:/";

        if (student.getMath() != null && student.getPhysics() != null &&
            student.getProgramming() != null && student.getElectronics() != null &&
            student.getMechanics() != null) {

            double total = student.getMath() + student.getPhysics() +
                           student.getProgramming() + student.getElectronics() +
                           student.getMechanics();
            student.setTotalMarks(total);

            double avg = total / 5;
            if      (avg >= 90) student.setGrade("A+");
            else if (avg >= 75) student.setGrade("A");
            else if (avg >= 60) student.setGrade("B");
            else if (avg >= 50) student.setGrade("C");
            else if (avg >= 40) student.setGrade("D");
            else                student.setGrade("F");
        }

        studentRepository.save(student);
        return "redirect:/";
    }

    @GetMapping("/showFormForUpdate/{id}")
    public String showFormForUpdate(@PathVariable long id, Model model, HttpSession session) {
        if (!"FACULTY".equals(session.getAttribute("userRole"))) return "redirect:/";
        List<Student> students = studentRepository.findAll();
        Student student = studentRepository.findById(id).orElseThrow();
        model.addAttribute("listStudents", students);
        model.addAttribute("student", student);
        model.addAttribute("showForm", true);
        model.addAttribute("formType", "BASIC");
        enrichStudents(students, model);
        return "new_student";
    }

    @GetMapping("/deleteStudent/{id}")
    public String deleteStudent(@PathVariable long id, HttpSession session) {
        if (!"FACULTY".equals(session.getAttribute("userRole"))) return "redirect:/";
        studentRepository.deleteById(id);
        return "redirect:/";
    }

    @GetMapping("/viewReport/{id}")
    public String viewReport(@PathVariable long id, Model model, HttpSession session) {
        if (session.getAttribute("userRole") == null) return "redirect:/login";

        Student student = studentRepository.findById(id).orElseThrow();
        List<Attendance> allAtt = attendanceRepository.findByStudentId(id);
        Map<String, List<Attendance>> bySubject = allAtt.stream()
            .collect(Collectors.groupingBy(Attendance::getSubject));

        List<Map<String,Object>> attRows = new ArrayList<>();
        StringBuilder chartLabels = new StringBuilder();
        StringBuilder chartThPct  = new StringBuilder();
        StringBuilder chartPrPct  = new StringBuilder();

        for (int i = 0; i < SUBJECTS.size(); i++) {
            String sub = SUBJECTS.get(i);
            List<Attendance> subList = bySubject.getOrDefault(sub, Collections.emptyList());
            Attendance th = subList.stream().filter(a -> "TH".equals(a.getType())).findFirst().orElse(null);
            Attendance pr = subList.stream().filter(a -> "PR".equals(a.getType())).findFirst().orElse(null);
            Map<String,Object> row = new LinkedHashMap<>();
            row.put("subject", sub); row.put("th", th); row.put("pr", pr);
            attRows.add(row);
            if (i > 0) { chartLabels.append(","); chartThPct.append(","); chartPrPct.append(","); }
            chartLabels.append("'").append(sub).append("'");
            chartThPct.append(th != null ? th.getPercentage() : 0);
            chartPrPct.append(pr != null ? pr.getPercentage() : 0);
        }

        List<Attendance> thList = allAtt.stream().filter(a -> "TH".equals(a.getType())).collect(Collectors.toList());
        List<Attendance> prList = allAtt.stream().filter(a -> "PR".equals(a.getType())).collect(Collectors.toList());
        int thP = thList.stream().mapToInt(Attendance::getPresentPeriods).sum();
        int thT = thList.stream().mapToInt(Attendance::getTotalPeriods).sum();
        int prP = prList.stream().mapToInt(Attendance::getPresentPeriods).sum();
        int prT = prList.stream().mapToInt(Attendance::getTotalPeriods).sum();
        double thPct  = thT > 0 ? Math.round(((double)thP/thT)*10000.0)/100.0 : 0;
        double prPct  = prT > 0 ? Math.round(((double)prP/prT)*10000.0)/100.0 : 0;
        double allPct = (thT+prT) > 0 ? Math.round(((double)(thP+prP)/(thT+prT))*10000.0)/100.0 : 0;

        model.addAttribute("s",           student);
        model.addAttribute("attRows",     attRows);
        model.addAttribute("thPresent",   thP); model.addAttribute("thTotal", thT); model.addAttribute("thPct", thPct);
        model.addAttribute("prPresent",   prP); model.addAttribute("prTotal", prT); model.addAttribute("prPct", prPct);
        model.addAttribute("allPresent",  thP+prP); model.addAttribute("allTotal", thT+prT); model.addAttribute("allPct", allPct);
        model.addAttribute("chartLabels", chartLabels.toString());
        model.addAttribute("chartThPct",  chartThPct.toString());
        model.addAttribute("chartPrPct",  chartPrPct.toString());
        return "student_report";
    }
}
