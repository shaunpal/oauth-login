package com.example.auth.repository;

import com.example.auth.entity.OtpStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OtpStatusRepository extends JpaRepository<OtpStatus, Long> {
}
