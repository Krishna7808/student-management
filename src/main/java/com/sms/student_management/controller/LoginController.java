package com.sms.student_management.controller;

import com.sms.student_management.model.User;
import com.sms.student_management.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class LoginController {

    @Autowired
    private UserRepository userRepository;

    // --- LOGIN ---
    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String username, 
                            @RequestParam String password, 
                            HttpSession session) {
        
        User user = userRepository.findByUsername(username);
        
        if (user != null && user.getPassword().equals(password)) {
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getUsername());
            return "redirect:/";
        }
        return "redirect:/login?error=true";
    }

    // --- REGISTRATION ---
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute("user") User user, Model model) {
        
        // 1. Validation: Check if Username already exists
        if (userRepository.findByUsername(user.getUsername()) != null) {
            model.addAttribute("error", "Username already taken!");
            return "register";
        }

        // 2. Security: Verify Secret Code for Faculty roles
        if ("FACULTY".equals(user.getRole())) {
            String masterKey = "ADMIN123"; // This is the code they must enter
            if (!masterKey.equals(user.getSecretCode())) {
                model.addAttribute("error", "Invalid Faculty Secret Code!");
                return "register";
            }
        }

        // 3. Save User
        userRepository.save(user);
        return "redirect:/login?registered=true";
    }

    // --- LOGOUT ---
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}