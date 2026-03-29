package com.example.auth.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "app")
public class AppConfig {

    private String geocodingBaseUrl;
    private String geocodingUri;

    public String getGeocodingBaseUrl() {
        return geocodingBaseUrl;
    }

    public void setGeocodingBaseUrl(String geocodingBaseUrl) {
        this.geocodingBaseUrl = geocodingBaseUrl;
    }

    public String getGeocodingUri() {
        return geocodingUri;
    }

    public void setGeocodingUri(String geocodingUri) {
        this.geocodingUri = geocodingUri;
    }
}
