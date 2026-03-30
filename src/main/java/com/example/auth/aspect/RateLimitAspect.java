package com.example.auth.aspect;

import com.example.auth.custom.RateLimit;
import com.example.auth.exception.RateLimiterExceedException;
import com.example.auth.service.RedisRateLimiter;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

@Aspect
@Component
public class RateLimitAspect {

    private final RedisRateLimiter redisRateLimiter;

    private final HttpServletRequest httpServletRequest;

    public RateLimitAspect(RedisRateLimiter redisRateLimiter, HttpServletRequest httpServletRequest) {
        this.redisRateLimiter = redisRateLimiter;
        this.httpServletRequest = httpServletRequest;
    }

    @Around("@annotation(com.example.auth.custom.RateLimit)")
    public Object rateLimit(ProceedingJoinPoint joinPoint) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        RateLimit rateLimit = method.getAnnotation(RateLimit.class);

        String clientIp = httpServletRequest.getRemoteAddr();

        String redisKey = String.format("ratelimit:%s:%s", clientIp, method.getName());

        boolean allowed = redisRateLimiter.isAllowed(redisKey, rateLimit.limit(), rateLimit.timeWindowSeconds());

        if (!allowed) throw new RateLimiterExceedException("Too Many Requests. Please try again.");

        return joinPoint.proceed();
    }
}
