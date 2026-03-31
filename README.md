# 🔐 IAM Login + SSO OAuth Provider (Spring Boot Security)

This project demonstrates a secure authentication system built with **Spring Boot Security**, supporting both:

- **IAM-based login (OTP via email)**
- **SSO login using OAuth providers**

---

## 🚀 Features

### 🔑 IAM Login (Email + OTP)

- **Email-based login**
    - Users enter their email to initiate authentication.
- **One-Time Password (OTP) verification**
    - A secure OTP is generated and sent to the user’s email.
- **OTP validation**
    - Users must enter the correct OTP to complete login.
- **Resend OTP functionality**
    - Users can request a new OTP if they didn’t receive or expired.
- **OTP expiration & security**
    - OTPs are time-bound and invalidated after use.

---

### 🔄 Resend OTP Feature

- Allows users to request a new OTP.
- Prevents abuse via:
    - Rate limiting (e.g., cooldown between requests, especially for resending otp)
    - Maximum retry attempts
- Automatically invalidates previously issued OTPs.

---

### 🌐 SSO Login (OAuth2)

- Supports third-party authentication provider:
    - Google
    - GitHub (In-progress)
- Seamless login without requiring local credentials.
- Automatic user provisioning (optional).

---

## 🏗️ Tech Stack

- **Java 17+**
- **Spring Boot**
- **Java Template Engine (jte)**
- **Spring Security**
- **Spring OAuth2 Client**
- **Gmail integration**
- **Java Mail Sender (for OTP delivery)**
- **Redis (session management)**
- **StompJS Websocket (for app heartbeat)**
- **External libraries (for parsing device info)**

---

## 🔄 Authentication Flow

### IAM Login Flow

1. User enters email.
2. System generates OTP and sends via email.
3. User submits OTP.
4. System validates OTP:
    - ✅ Success → User authenticated
    - ❌ Failure → Error remain on otp page
5. User can click **Resend OTP** if timer runs out
6. Once logged in, user is authenticated in the system

---

### SSO Login Flow

1. User selects OAuth provider, currently only Google
2. Redirect to provider login page.
3. User authenticates with provider.
4. Provider redirects back to application dashboard.
5. User is authenticated in the system.

---

## 🔐 Security Considerations

- OTP expiration stored in redis cache (3 minutes)
- Session expiry/timeouts (10-mins)
- Distributed session management
- Deny fetch/AJAX web-based script requests
- CSRF protection enabled
- Cookies (http-only, secure, same-site)
- OAuth2 SSO provider
- Detects if server is offline via heartbeats with auto logout
- Rate-limiting on endpoints
- Maximum retries on login attempts

---

## 📦 API Endpoints (Sample)

### IAM Authentication

| Method | Endpoint       | Description                        |
|--------|----------------|------------------------------------|
| GET    | /dashboard     | Shows user and device info         |
| GET    | /login         | Shows login form                   |
| POST   | /loginForm     | Submit login form                  |
| POST   | /logout        | Clears sessions, logout user       |
| GET    | /otp/verify    | Direct user to otp page            |
| POST   | /otp/verify    | Submits otp, verifies code         |
| POST   | /otp/resend    | Invalidates otp, triggers new code |

---

### OAuth2 SSO Login

| Endpoint                          | Description                |
|----------------------------------|----------------------------|
| /oauth2/authorization/{provider} | Redirect to OAuth provider |
| /login/oauth2/code/*             | OAuth callback endpoint    |

---

## ⚙️ Configuration

### Email (SMTP)
```yaml
spring:
  mail:
    host: smtp.gmail.com
    port: 587
    username: your-email
    password: your-password
```
---

### OAuth2 Providers
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: YOUR_CLIENT_ID
            client-secret: YOUR_CLIENT_SECRET
```
# Screenshots

### Login Page
![Image](images/login%20screen.png)

### OTP screen
![Image](images/otp%20screen.png)

### Server heartbeat
![Image](images/online%20server.png)


---

## 🧪 Future Enhancements

- Multi-factor authentication (MFA)
- SMS-based OTP support
- Admin dashboard for user/session management
- Refresh token support for OAuth/JWT
- Account lockout after failed attempts
