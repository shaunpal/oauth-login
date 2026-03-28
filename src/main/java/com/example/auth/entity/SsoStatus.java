package com.example.auth.entity;


import jakarta.persistence.*;

@Entity
@Table(name = "tssostatus")
public class SsoStatus {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @MapsId
    @JoinColumn(name = "provider_id")
    private SsoProvider ssoProvider;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoginStatus status;

    @Column(name = "session")
    private String httpSession;

    private String email;

    @Column(name = "authority_principal_sub")
    private String authorityPrincipalSubject;

    @Column(name = "authority_seesion_id")
    private String authoritySessionId;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LoginStatus getStatus() {
        return status;
    }

    public void setStatus(LoginStatus status) {
        this.status = status;
    }

    public String getHttpSession() {
        return httpSession;
    }

    public void setHttpSession(String httpSession) {
        this.httpSession = httpSession;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAuthorityPrincipalSubject() {
        return authorityPrincipalSubject;
    }

    public void setAuthorityPrincipalSubject(String authorityPrincipalSubject) {
        this.authorityPrincipalSubject = authorityPrincipalSubject;
    }

    public String getAuthoritySessionId() {
        return authoritySessionId;
    }

    public void setAuthoritySessionId(String authoritySessionId) {
        this.authoritySessionId = authoritySessionId;
    }

    public SsoProvider getSsoProvider() {
        return ssoProvider;
    }

    public void setSsoProvider(SsoProvider ssoProvider) {
        this.ssoProvider = ssoProvider;
    }
}
