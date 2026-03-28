package com.example.auth.service;

import org.springframework.stereotype.Service;
import java.security.SecureRandom;
import java.util.concurrent.TimeUnit;

@Service
public class OtpService {

    public static final int TTL_SECONDS = 120; // 2 minutes

    private final RedisService redisStore;

    private final SecureRandom random = new SecureRandom();

    public OtpService(RedisService redisStore) {
        this.redisStore = redisStore;
    }

    /** Generates a 6-digit OTP, stores it, and returns it for sending. */
    public String generate(String email) {
        String code = String.format("%06d", random.nextInt(1_000_000)); // Fixed 6 random digits
        redisStore.saveData(email.toLowerCase(), code, TTL_SECONDS, TimeUnit.SECONDS);
        return code;
    }

    /** Returns true and removes the entry if the code is correct and not expired. */
    public boolean verify(String email, String code) {
        String storeCode = redisStore.getData(email.toLowerCase());
        if (storeCode == null) {
            redisStore.deleteData(email.toLowerCase());
            return false;
        }
        if (!storeCode.equals(code)) return false;
        redisStore.deleteData(email.toLowerCase()); // one-time use
        return true;
    }
}
