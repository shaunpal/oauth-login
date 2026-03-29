package com.example.auth.interceptor;

import com.example.auth.config.AppConfig;
import com.example.auth.model.dao.GeoCodeResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import nl.basjes.parse.useragent.UserAgent;
import nl.basjes.parse.useragent.UserAgentAnalyzer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.servlet.HandlerInterceptor;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.Duration;
import java.util.Locale;
import java.util.Objects;

@Component
public class ClientWebInterceptor implements HandlerInterceptor {

    private final Logger log = LoggerFactory.getLogger(ClientWebInterceptor.class);

    private final UserAgentAnalyzer userAgentAnalyzer;

    private final WebClient webClient;

    private final AppConfig appConfig;

    public ClientWebInterceptor(UserAgentAnalyzer userAgentAnalyzer, WebClient webClient, AppConfig appConfig) {
        this.userAgentAnalyzer = userAgentAnalyzer;
        this.webClient = webClient;
        this.appConfig = appConfig;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String userAgentString = request.getHeader("User-Agent");
        if (userAgentString != null) {
            UserAgent userAgent = userAgentAnalyzer.parse(userAgentString);

            // Extract details
            String device = userAgent.getValue(UserAgent.DEVICE_NAME);
            String os = userAgent.getValue(UserAgent.OPERATING_SYSTEM_NAME);
            String brand = userAgent.getValue(UserAgent.DEVICE_BRAND);
            String browserName = userAgent.getValue(UserAgent.AGENT_NAME);

            log.debug("Detected Browser: {} , OS: {}, Device: {}, Brand: {}", browserName, os, device, brand);

            request.setAttribute("deviceName", device);
            request.setAttribute("browserName", browserName);
            request.setAttribute("osName", os);
            request.setAttribute("deviceBrandName", brand);

            determineGeocoding(request);
        }
        return true; // Continue processing the request
    }

    private void determineGeocoding(HttpServletRequest request) {
        String geocodingLocation = Locale.getDefault().getDisplayCountry();
        String remoteIpAddress = Objects.nonNull(request.getHeader("X-Forwarded-For")) ? request.getHeader("X-Forwarded-For") : request.getRemoteAddr();
        try {
            InetAddress address = InetAddress.getByName(remoteIpAddress);
            // If the request is from the local machine or a link-local address, avoid calling external API
            if (address.isAnyLocalAddress() || address.isLoopbackAddress() || address.isLinkLocalAddress()) {
                request.setAttribute("deviceLocation", geocodingLocation);
                return;
            }

            // Build the external API URI
            String uri = String.format(appConfig.getGeocodingUri(), remoteIpAddress);

            // Make a short-blocking call with a timeout and map the response to a readable string
            String deviceLocation;
            try {
                deviceLocation = webClient.get()
                        .uri(uri)
                        .retrieve()
                        .bodyToMono(GeoCodeResponse.class)
                        .timeout(Duration.ofSeconds(3))
                        .map(result -> {
                            if (result != null && result.getCity() != null && result.getCountry() != null) {
                                return String.format("%s, %s", result.getCity(), result.getCountry());
                            }
                            return geocodingLocation;
                        })
                        .block(Duration.ofSeconds(3));
            } catch (Exception e) {
                log.debug("Geocoding request failed for {}: {}", remoteIpAddress, e.toString());
                deviceLocation = geocodingLocation;
            }

            if (deviceLocation == null) deviceLocation = geocodingLocation;
            request.setAttribute("deviceLocation", deviceLocation);

        } catch (UnknownHostException e) {
            log.error("Unable to determine approx. geocoding location: {}", e.getMessage());
            request.setAttribute("deviceLocation", geocodingLocation);
        }
    }
}
