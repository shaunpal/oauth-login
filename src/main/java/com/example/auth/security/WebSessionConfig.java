package com.example.auth.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

@Component
public class WebSessionConfig {

    @Bean
    public AuthenticationEntryPoint authenticationEntryPoint() {
        return (HttpServletRequest req, HttpServletResponse res,
                AuthenticationException ex) -> {

            // AJAX / fetch requests get a 401 so JS can handle it in order to
            // prevent CSRF attack from browser-based script like AJAX
            String requestedWith = req.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                res.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Session expired");
            } else {
                // Full page requests redirect to login
                res.sendRedirect("/login?expired");
            }
        };
    }
}
