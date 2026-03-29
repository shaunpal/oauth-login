package com.example.auth.service;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class RedisRateLimiter {

    private final StringRedisTemplate stringRedisTemplate;

    public RedisRateLimiter(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
    }

    public boolean isAllowed(String key, int limit, int timeWindowSeconds) {
        Long requestCount = stringRedisTemplate.opsForValue().increment(key);

        if (requestCount == 1) {
            stringRedisTemplate.expire(key, timeWindowSeconds, TimeUnit.SECONDS);
        }
        // Allow up to limit
        return requestCount == limit;
    }
}
