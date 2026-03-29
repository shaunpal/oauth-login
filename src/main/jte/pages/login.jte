@import com.example.auth.model.LoginForm
@import com.example.auth.security.CsrfHiddenInput

@param LoginForm loginForm
@param String errorMessage = null
@param CsrfHiddenInput csrfHiddenInput

@param String logoutReason = null

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sign in</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600&family=JetBrains+Mono:wght@300;400;500&display=swap" rel="stylesheet"/>

    <style>
        :root {
            --white:      #ffffff;
            --off-white:  #f9f8f6;
            --ink:        #111111;
            --ink-light:  #777777;
            --ink-xlight: #bbbbbb;
            --rule:       #e8e8e8;
            --danger:     #c0392b;
            --font-serif: 'Cormorant Garamond', Georgia, serif;
            --font-mono:  'JetBrains Mono', monospace;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: var(--off-white);
            font-family: var(--font-serif);
            color: var(--ink);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-wrap {
            width: 100%;
            max-width: 400px;
            padding: 1.5rem;
            animation: rise 0.5s cubic-bezier(0.22,1,0.36,1) both;
        }
        @keyframes rise {
            from { opacity: 0; transform: translateY(14px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .eyebrow {
            font-family: var(--font-mono);
            font-size: 0.65rem;
            font-weight: 400;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            margin-bottom: 1.6rem;
        }

        .login-heading {
            font-size: 2rem;
            font-weight: 300;
            letter-spacing: -0.01em;
            line-height: 1.15;
            color: var(--ink);
            margin-bottom: 0.5rem;
        }
        .login-sub {
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 300;
            color: var(--ink-light);
            line-height: 1.7;
        }

        .rule {
            border: none;
            border-top: 1px solid var(--rule);
            margin: 2rem 0;
        }

        .field-label {
            font-family: var(--font-mono);
            font-size: 0.65rem;
            font-weight: 400;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            margin-bottom: 0.45rem;
            display: block;
        }

        .email-input {
            font-family: var(--font-mono);
            font-size: 0.82rem;
            font-weight: 300;
            color: var(--ink);
            background: var(--white);
            border: 1px solid var(--rule);
            border-radius: 4px;
            width: 100%;
            padding: 13px 14px;
            outline: none;
            box-shadow: none !important;
            transition: border-color 0.18s;
        }
        .email-input::placeholder { color: var(--ink-xlight); font-weight: 300; }
        .email-input:focus        { border-color: var(--ink) !important; }
        .email-input.is-invalid   { border-color: var(--danger) !important; }

        .err-msg {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            color: var(--danger);
            margin-top: 0.5rem;
        }

        .btn-login {
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 400;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--white);
            background: var(--ink);
            border: 1px solid var(--ink);
            border-radius: 4px;
            width: 100%;
            padding: 13px;
            transition: background 0.18s, color 0.18s, opacity 0.18s;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .btn-login:hover:not(:disabled)  { background: var(--white); color: var(--ink); }
        .btn-login:active:not(:disabled) { transform: scale(0.99); }
        .btn-login:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        /* Spinner */
        .spinner {
            display: none;
            width: 12px;
            height: 12px;
            border: 1.5px solid currentColor;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.6s linear infinite;
            flex-shrink: 0;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        .btn-login.loading .spinner  { display: block; }
        .btn-login.loading .btn-text { opacity: 0.7; }

        .or-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 1.4rem 0;
        }
        .or-row::before, .or-row::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--rule);
        }
        .or-label {
            font-family: var(--font-mono);
            font-size: 0.62rem;
            color: var(--ink-xlight);
            letter-spacing: 0.1em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .btn-google {
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 400;
            letter-spacing: 0.06em;
            color: var(--ink);
            background: var(--white);
            border: 1px solid var(--rule);
            border-radius: 4px;
            width: 100%;
            padding: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
            transition: border-color 0.18s, box-shadow 0.18s;
            text-decoration: none;
        }
        .btn-google:hover  { border-color: var(--ink-xlight); box-shadow: 0 1px 6px rgba(0,0,0,0.06); }
        .btn-google:active { transform: scale(0.99); }
        .google-icon { width: 16px; height: 16px; flex-shrink: 0; }

        .footer-note {
            font-family: var(--font-mono);
            font-size: 0.62rem;
            color: var(--ink-xlight);
            letter-spacing: 0.04em;
        }
        .footer-note a {
            color: var(--ink-light);
            text-decoration: underline;
            text-underline-offset: 3px;
            transition: color 0.15s;
        }
        .footer-note a:hover { color: var(--ink); }
    </style>
</head>

<body>

<div class="login-wrap">
    @if("logout".equals(logoutReason))
        <p class="info-msg">You have been signed out.</p>
    @endif
    @if("expired".equals(logoutReason))
        <p class="info-msg">Your session expired. Please sign in again.</p>
    @endif
    <p class="eyebrow">Account · Access</p>

    <h1 class="login-heading">Welcome</h1>
    <p class="login-sub">Sign in to continue.</p>

    <hr class="rule"/>

    <%-- jte: action="/login", CSRF injected as hidden input via @param --%>
    <form action="/loginForm" method="post" id="login-form">
        ${csrfHiddenInput}
        <div class="mb-4">
            <label for="email" class="field-label">Email address</label>
            <input
                    type="email"
                    id="email"
                    name="email"
                    class="email-input${errorMessage != null ? " is-invalid" : ""}"
                    value="${loginForm.email() != null ? loginForm.email() : ""}"
                    placeholder="you@example.com"
                    autocomplete="email"
                    autofocus
            />
            <%-- jte: field-level error rendered when errorMessage is set --%>
            @if(errorMessage != null)
                <p class="err-msg">${errorMessage}</p>
            @endif
        </div>

        <button type="submit" class="btn-login" id="login-btn">
            <span class="spinner" aria-hidden="true"></span>
            <span class="btn-text">Continue</span>
        </button>

    </form>

    <div class="or-row">
        <span class="or-label">or</span>
    </div>

    <%-- Google OAuth2 — Spring Security authorization endpoint --%>
    <a href="/oauth2/authorization/google" class="btn-google" role="button">
        <svg class="google-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
            <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
            <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"/>
            <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
        </svg>
        Continue with Google
    </a>

    <hr class="rule"/>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('login-form').addEventListener('submit', function () {
        const btn = document.getElementById('login-btn');
        btn.classList.add('loading');
        btn.disabled = true;
    });
</script>
</body>
</html>
