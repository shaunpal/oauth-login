package com.example.auth.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class DashboardController {

    @GetMapping(value= "/dashboard")
    public String dashboard(Authentication authentication, HttpServletRequest request, Model model) {
        if (authentication.getPrincipal() instanceof OAuth2User oauth2User) {
            model.addAttribute("username", oauth2User.getAttribute("name"));
            model.addAttribute("email", oauth2User.getAttribute("email"));
            model.addAttribute("authorities", oauth2User.getAuthorities());
        } else if (authentication.getDetails() instanceof WebAuthenticationDetails) {
            model.addAttribute("username", "ROLE_USER");
            model.addAttribute("email", authentication.getPrincipal());
            model.addAttribute("authorities", authentication.getAuthorities());
        }

        // Add CSRF token
        CsrfToken csrf = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
        if (csrf != null) {
            model.addAttribute("csrf", csrf);
        }

        // Add Device information
        model.addAttribute("deviceName", request.getAttribute("deviceName"));
        model.addAttribute("browserName", request.getAttribute("browserName"));
        model.addAttribute("osName", request.getAttribute("osName"));
        model.addAttribute("deviceBrandName", request.getAttribute("deviceBrandName"));
        model.addAttribute("deviceLocation", request.getAttribute("deviceLocation"));

        return "pages/dashboard";
    }
}
