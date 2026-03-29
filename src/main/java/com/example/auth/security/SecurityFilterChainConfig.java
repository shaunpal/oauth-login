package com.example.auth.security;

import com.example.auth.handler.RedirectAccessDeniedHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.HeaderWriterLogoutHandler;
import org.springframework.security.web.header.writers.ClearSiteDataHeaderWriter;
import org.springframework.security.web.session.HttpSessionEventPublisher;

import static org.springframework.security.web.header.writers.ClearSiteDataHeaderWriter.Directive.COOKIES;
import static org.springframework.security.web.header.writers.ClearSiteDataHeaderWriter.Directive.STORAGE;

@Configuration
@EnableWebSecurity
public class SecurityFilterChainConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) {
         return http
             .csrf(csrf -> csrf.ignoringRequestMatchers("/otp/resend"))
             .authorizeHttpRequests( authorise -> authorise
                .requestMatchers("/login", "/loginForm", "/otp/verify", "/otp/resend",
                                "/oauth2/**", "/css/**", "/js/**").permitAll() // allow unauthenticated access to login form, websocket and related endpoints
                .anyRequest().authenticated())
            .formLogin(form -> form
                 .loginPage("/login")
                 .defaultSuccessUrl("/dashboard", true)
                 .permitAll()
            )
            // Map access denied (403) to a redirect
            .exceptionHandling(ex -> ex
                .accessDeniedHandler(new RedirectAccessDeniedHandler())
            )
             //  Session management
             .sessionManagement(session -> session
                 // Prevent session fixation attacks on login
                 .sessionFixation().migrateSession()
                 // Only allow one active session per user
                 .maximumSessions(1)
                 .maxSessionsPreventsLogin(false)           // new login kicks old session
                 .expiredUrl("/login?expired")              // redirect when session is kicked
             )

             // OAuth2 (Google SSO)
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login")
                .defaultSuccessUrl("/dashboard", true)
            )

             // Handle logout flow - clear/invalidate sessions
             .logout(logout -> logout
                 .logoutUrl("/logout")
                 .invalidateHttpSession(true)                     // destroy HttpSession
                 .clearAuthentication(true)                       // clear SecurityContext
                 .deleteCookies("JSESSIONID", "remember-me")  // remove session cookies
                 .addLogoutHandler(                               // Clear-Site-Data header
                     new HeaderWriterLogoutHandler(
                             new ClearSiteDataHeaderWriter(COOKIES, STORAGE)
                     )
                 )
                .logoutSuccessUrl("/login?logout")
                .permitAll()
            )
            .build();
    }

    // Required for maximumSessions() to detect session destruction events
    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }
}
