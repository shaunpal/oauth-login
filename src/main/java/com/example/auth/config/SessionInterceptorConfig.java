package com.example.auth.config;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.SimpMessageType;
import org.springframework.session.Session;
import org.springframework.session.web.socket.server.SessionRepositoryMessageInterceptor;

import java.util.EnumSet;

@Configuration
public class SessionInterceptorConfig {

    private final SessionRepositoryMessageInterceptor<Session> sessionRepositoryInterceptor;

    public SessionInterceptorConfig(SessionRepositoryMessageInterceptor<Session> sessionRepositoryInterceptor) {
        this.sessionRepositoryInterceptor = sessionRepositoryInterceptor;
    }

    @PostConstruct
    public void init() {
        // Force the interceptor to recognize HEARTBEAT as activity
        sessionRepositoryInterceptor.setMatchingMessageTypes(EnumSet.of(
                SimpMessageType.CONNECT,
                SimpMessageType.MESSAGE,
                SimpMessageType.SUBSCRIBE,
                SimpMessageType.UNSUBSCRIBE,
                SimpMessageType.HEARTBEAT // Adds heartbeat support
        ));
    }
}
