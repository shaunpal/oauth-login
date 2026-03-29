package com.example.auth.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {

    private final AppConfig appConfig;

    public WebClientConfig(AppConfig appConfig) {
        this.appConfig = appConfig;
    }

    @Bean
    public WebClient.Builder webClientBuilder() {
        return WebClient.builder();
    }

    @Bean
    public WebClient webClient(WebClient.Builder builder) {
        return builder
                .baseUrl(appConfig.getGeocodingBaseUrl()) // Set your base URL
                .defaultHeader("Content-Type", "application/json")
                .build();
    }
}
