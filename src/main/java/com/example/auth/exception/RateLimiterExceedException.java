package com.example.auth.exception;

public class RateLimiterExceedException extends RuntimeException {
    public RateLimiterExceedException(String message) {
        super(message);
    }
}
