package com.example.auth.entity;


import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "tsessions")
public class Session {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "email")
    private String email;

    @Column(name = "login_time")
    private LocalDateTime loginTime;

    @Column(name = "session")
    private String httpSession;

    @Column(name = "device")
    private String device;

    @Column(name = "ip_address")
    private String ipAddress;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public LocalDateTime getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(LocalDateTime loginTime) {
        this.loginTime = loginTime;
    }

    public String getHttpSession() {
        return httpSession;
    }

    public void setHttpSession(String httpSession) {
        this.httpSession = httpSession;
    }

    public String getDevice() {
        return device;
    }

    public void setDevice(String device) {
        this.device = device;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
}
