package com.example.auth.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseStatus;

@Controller
public class SessionController {

    // Called by the frontend "Stay signed in" button every time the user
    // clicks it — resets the server-side session last-accessed time
    @PostMapping("/session/keep-alive")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void keepAlive(HttpSession session) {
        session.setAttribute("lastActivity", System.currentTimeMillis());
    }

    // Lightweight endpoint polled by the frontend to detect server-down
    // or expired session — returns 200 if valid, 401 if not
    @GetMapping("/session/check")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void checkSession() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            throw new AccessDeniedException("No session");
        }
    }
}
