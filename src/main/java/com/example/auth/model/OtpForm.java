package com.example.auth.model;

public record OtpForm(
        String digit1, String digit2, String digit3,
        String digit4, String digit5, String digit6
) {}
