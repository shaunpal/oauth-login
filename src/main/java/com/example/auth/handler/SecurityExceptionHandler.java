package com.example.auth.handler;

import com.example.auth.exception.RateLimiterExceedException;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.concurrent.RejectedExecutionException;

@ControllerAdvice
public class SecurityExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(SecurityExceptionHandler.class);

    @ExceptionHandler(AccessDeniedException.class)
    public String handleAccessDenied(AccessDeniedException ex, HttpServletRequest request) {
        log.warn("Access denied to {} — redirecting to /login: {}", request.getRequestURI(), ex.getMessage());
        return "redirect:/login";
    }

    @ExceptionHandler(AuthenticationException.class)
    public String handleAuthenticationException(AuthenticationException ex, HttpServletRequest request) {
        log.warn("Authentication failure for {} — redirecting to /login: {}", request.getRequestURI(), ex.getMessage());
        return "redirect:/login";
    }

    // Exception thrown by 'reactor-core' after unsuccessful attempts of subscribing to broker
    @ExceptionHandler(RejectedExecutionException.class)
    public String handleRejectedExecutionException(RejectedExecutionException ex, HttpServletRequest request) {
        log.warn("Blocked subscriber failure due to broker for {} — redirecting to /login: {}", request.getRequestURI(), ex.getMessage());
        return "redirect:/login";
    }

    // Handle rate limiting
    @ExceptionHandler(RateLimiterExceedException.class)
    public ResponseEntity<String> handleRateLimiterExceedException(RateLimiterExceedException ex, HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(ex.getMessage());
    }
}

