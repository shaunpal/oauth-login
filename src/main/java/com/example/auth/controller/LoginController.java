package com.example.auth.controller;

import com.example.auth.custom.RateLimit;
import com.example.auth.model.LoginForm;
import com.example.auth.model.OtpForm;
import com.example.auth.service.EmailService;
import com.example.auth.service.OtpService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.regex.Pattern;

@Controller
public class LoginController {

    private static final Logger log = LoggerFactory.getLogger(LoginController.class);

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    private final OtpService otpService;
    private final EmailService emailService;

    public LoginController(OtpService otpService, EmailService emailService) {
        this.otpService   = otpService;
        this.emailService = emailService;
    }

    @GetMapping("/login")
    public String login(
            @RequestParam(required = false) String logout,
            @RequestParam(required = false) String expired,
            HttpServletRequest request,
            HttpSession session,
            Model model
    ) {
        if (logout != null)  model.addAttribute("logoutReason", "logout");
        if (expired != null) model.addAttribute("logoutReason", "expired");
        model.addAttribute("loginForm",   new LoginForm(null));
        return "pages/login";
    }

    @PostMapping("/loginForm")
    public String handleLoginForm(@RequestParam("email") String email, HttpSession session, Model model) {
        // lowercase email string (Usually emails are not case-sensitive)
        email = email.trim().toLowerCase();

        log.debug("POST /loginForm for session {} — email {}", session.getId(), email);

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            model.addAttribute("loginForm",    new LoginForm(email));
            model.addAttribute("errorMessage", "Please enter a valid email address.");
            return "pages/login";
        }

        // 2. Generate OTP and send it
        String code = otpService.generate(email);
        emailService.sendOtp(email, code);

        // 3. Store email in session for the OTP page to use
        session.setAttribute("pendingEmail", email);
        log.debug("Setting pendingEmail:'{}' on session: {}", email, session.getId());
        log.debug("Session attributes now: {}", Collections.list(session.getAttributeNames()));

        // 4. Redirect to OTP page
        return "redirect:/otp/verify"; // Go to GET /otp/verify
    }

    @PostMapping(value = "/logout")
    public String handleLogout(HttpSession session, HttpServletRequest request) {
        session.removeAttribute("pendingEmail");
        return "redirect:/login";
    }

    /* show OTP form */
    @GetMapping("/otp/verify")
    public String showOtp(HttpSession session, Model model) {

        log.debug("GET /otp/verify for session {} — attributes: {}", session.getId(), Collections.list(session.getAttributeNames()));

        if (Objects.nonNull(session.getAttribute("isEmailVerified")) && session.getAttribute("isEmailVerified").equals(true)) {
            throw new AccessDeniedException("You are not allowed to perform this action again");
        }

        session.setAttribute("isEmailVerified", false);
        String email = (String) session.getAttribute("pendingEmail");

        // Guard: if someone lands here without going through login, send them back
        if (email == null) {
            log.warn("pendingEmail missing in GET /otp/verify for session {} — redirecting to /login", session.getId());
            return "redirect:/login";
        }

        model.addAttribute("email",    email);
        model.addAttribute("otpForm",  new OtpForm(null, null, null, null, null, null));
        session.setAttribute("isEmailVerified", true);
        return "pages/otp-verification";
    }


    /* validate submitted OTP */
    @PostMapping("/otp/verify")
    public String handleOtp(
            @RequestParam("digit1") String d1,
            @RequestParam("digit2") String d2,
            @RequestParam("digit3") String d3,
            @RequestParam("digit4") String d4,
            @RequestParam("digit5") String d5,
            @RequestParam("digit6") String d6,
            HttpServletRequest request,
            HttpSession session,
            Model model) {

        log.debug("POST /otp/verify for session {} — attributes before read: {}", session.getId(), Collections.list(session.getAttributeNames()));
        String email = (String) session.getAttribute("pendingEmail");
        if (email == null) {
            log.warn("pendingEmail missing in POST /otp/verify for session {} — redirecting to /login", session.getId());
            return "redirect:/login";
        }

        String code = d1 + d2 + d3 + d4 + d5 + d6;
        log.debug("Verifying OTP for {} (session {}) code={}", email, session.getId(), code);

        if (!otpService.verify(email, code)) {
            model.addAttribute("email",        email);
            model.addAttribute("otpForm",      new OtpForm(d1, d2, d3, d4, d5, d6));
            model.addAttribute("errorMessage", "Incorrect or expired code — please try again.");
            return "pages/otp-verification";
        }

        // OTP valid — clear session gate and mark user as authenticated
        session.removeAttribute("pendingEmail");
        session.setAttribute("authenticatedEmail", email);

        // Create a Spring Security Authentication so /dashboard (which requires authentication) will be accessible
        List<SimpleGrantedAuthority> authorities = List.of(new SimpleGrantedAuthority("ROLE_USER"));
        UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(email, null, authorities);
        // Attach request details (session id, remote address)
        authToken.setDetails(new WebAuthenticationDetails(request));
        SecurityContextHolder.getContext().setAuthentication(authToken);

        // Persist SecurityContext in session so subsequent requests remain authenticated via the SecurityContextPersistenceFilter
        request.getSession().setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, SecurityContextHolder.getContext());

        log.debug("SecurityContext Authentication: {}", SecurityContextHolder.getContext().getAuthentication());
        log.debug("Session context: {}", request.getSession().getAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY));

        // Redirect to your protected home/dashboard
        return "redirect:/dashboard";
    }


    /* /otp/resend - regenerate and resend OTP */
    @RateLimit(limit = 10, timeWindowSeconds = 60)
    @PostMapping("/otp/resend")
    public String resendOtp(HttpSession session, Model model) {

        log.debug("POST /otp/resend for session {} — attributes before read: {}", session.getId(), Collections.list(session.getAttributeNames()));

        String email = (String) session.getAttribute("pendingEmail");
        if (email == null) return "redirect:/login";

        String code = otpService.generate(email); // resets the TTL
        emailService.sendOtp(email, code);

        model.addAttribute("email",         email);
        model.addAttribute("otpForm",       new OtpForm(null, null, null, null, null, null));
        model.addAttribute("resendSuccess", true);
        return "pages/otp-verification";
    }
}
