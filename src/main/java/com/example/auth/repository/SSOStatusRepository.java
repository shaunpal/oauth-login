package com.example.auth.repository;

import com.example.auth.entity.SsoStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SSOStatusRepository extends JpaRepository<SsoStatus, Long> {
}
