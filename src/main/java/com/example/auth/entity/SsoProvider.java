package com.example.auth.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "tssoprovider")
public class SsoProvider {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "provider")
    private String ssoProviderName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getSsoProviderName() {
        return ssoProviderName;
    }

    public void setSsoProviderName(String ssoProviderName) {
        this.ssoProviderName = ssoProviderName;
    }
}
