package com.example.auth.repository;

import com.example.auth.entity.SsoProvider;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SSOProviderRepository extends JpaRepository<SsoProvider, Integer> {
}
