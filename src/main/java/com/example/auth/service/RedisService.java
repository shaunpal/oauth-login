package com.example.auth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class RedisService {

    private final RedisTemplate<String, String> redisTemplate;

    public RedisService(RedisTemplate<String, String> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    // 1. Save data (with an optional timeout/expiration)
    public void saveData(String key, String value, Integer timeout,  TimeUnit unit) {
        redisTemplate.opsForValue().set(key, value, timeout, unit);
    }

    @Cacheable
    // 2. Retrieve data
    public String getData(String key) {
        return redisTemplate.opsForValue().get(key);
    }

    // 3. Delete data
    public void deleteData(String key) {
        redisTemplate.delete(key);
    }
}
