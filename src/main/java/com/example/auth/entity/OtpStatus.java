package com.example.auth.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "totpstatus")
public class OtpStatus {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String email;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private LoginStatus loginStatus;

    @Column(name = "session")
    private String httpSession;
}
