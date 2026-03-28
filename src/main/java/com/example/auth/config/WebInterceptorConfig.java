package com.example.auth.config;

import com.example.auth.interceptor.ClientWebInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebInterceptorConfig implements WebMvcConfigurer {

    private final ClientWebInterceptor clientWebInterceptor;

    public WebInterceptorConfig(ClientWebInterceptor clientWebInterceptor) {
        this.clientWebInterceptor = clientWebInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(clientWebInterceptor);
    }
}
