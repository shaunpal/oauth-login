@import com.example.auth.model.OtpForm
@import org.springframework.security.web.csrf.CsrfToken
@import com.example.auth.security.CsrfHiddenInput
@import java.util.Objects
@import com.example.auth.service.OtpService

@param OtpForm otpForm
@param String email
@param String errorMessage = null
@param boolean resendSuccess = false
@param CsrfHiddenInput csrfHiddenInput
@param CsrfToken csrfToken

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>OTP Verification</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600&family=JetBrains+Mono:wght@300;400;500&display=swap" rel="stylesheet"/>

    <style>
        * {
            -webkit-user-select: none;
            -khtml-user-select: none;
            -moz-user-select: -moz-none;
            -o-user-select: none;
            user-select: none;
        }
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

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: var(--off-white);
            font-family: var(--font-serif);
            color: var(--ink);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .otp-wrap {
            width: 100%;
            max-width: 400px;
            padding: 1.5rem;
            animation: rise 0.5s cubic-bezier(0.22,1,0.36,1) both;
        }
        @keyframes rise {
            from { opacity: 0; transform: translateY(14px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .otp-eyebrow {
            font-family: var(--font-mono);
            font-size: 0.65rem;
            font-weight: 400;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            margin-bottom: 1.6rem;
        }

        .otp-heading {
            font-size: 2rem;
            font-weight: 300;
            letter-spacing: -0.01em;
            line-height: 1.15;
            color: var(--ink);
            margin-bottom: 0.5rem;
        }

        .otp-sub {
            font-family: var(--font-mono);
            font-size: 0.72rem;
            font-weight: 300;
            color: var(--ink-light);
            line-height: 1.7;
        }
        .otp-sub strong { font-weight: 500; color: var(--ink); }

        .rule {
            border: none;
            border-top: 1px solid var(--rule);
            margin: 2rem 0;
        }

        .otp-row {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .otp-input {
            flex: 1;
            height: 56px;
            text-align: center;
            font-family: var(--font-mono);
            font-size: 1.4rem;
            font-weight: 400;
            color: var(--ink);
            background: var(--white);
            border: 1px solid var(--rule);
            border-radius: 4px;
            outline: none;
            box-shadow: none !important;
            caret-color: var(--ink);
            transition: border-color 0.18s, color 0.18s;
            padding: 0;
        }
        .otp-input:focus  { border-color: var(--ink) !important; color: var(--ink); }
        .otp-input.filled { border-color: var(--ink-xlight); color: var(--ink); }
        .otp-input.error  { border-color: var(--danger) !important; color: var(--danger); }

        .otp-dot {
            font-family: var(--font-mono);
            font-size: 1rem;
            color: var(--ink-xlight);
            flex-shrink: 0;
            padding: 0 2px;
            user-select: none;
        }

        .err-msg {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            color: var(--danger);
            margin-top: 0.6rem;
        }

        .timer-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .timer-label {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            font-weight: 300;
            color: var(--ink-xlight);
            letter-spacing: 0.04em;
        }

        #timer-display {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            font-weight: 500;
            color: var(--ink);
            transition: color 0.4s;
        }
        #timer-display.warning { color: #b7791f; }
        #timer-display.danger  { color: var(--danger); }

        .timer-track {
            height: 1px;
            background: var(--rule);
            margin-top: 0.55rem;
            position: relative;
            overflow: hidden;
        }
        .timer-bar {
            position: absolute;
            left: 0; top: 0; bottom: 0;
            width: 100%;
            background: var(--ink);
            transition: width 1s linear, background 1s ease;
        }
        .timer-bar.warning { background: #b7791f; }
        .timer-bar.danger  { background: var(--danger); }

        .resend-btn {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            font-weight: 400;
            color: var(--ink);
            background: none;
            border: none;
            border-bottom: 1px solid var(--ink);
            padding: 0 0 1px;
            cursor: pointer;
            letter-spacing: 0.04em;
            transition: color 0.15s, border-color 0.15s;
            animation: fade-in 0.3s ease both;
        }
        .resend-btn:hover { color: var(--ink-light); border-color: var(--ink-light); }
        @keyframes fade-in {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        .resend-ok {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            color: var(--ink-light);
            animation: fade-in 0.3s ease both;
        }

        .btn-verify {
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
            padding: 14px;
            transition: background 0.18s, color 0.18s, opacity 0.18s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
        }
        .btn-verify:not(:disabled):hover {
            background: var(--white);
            color: var(--ink);
        }
        .btn-verify:disabled {
            background: var(--rule);
            border-color: var(--rule);
            color: var(--ink-xlight);
            cursor: not-allowed;
        }
        /* Spinner — shared by verify + resend */
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

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25%       { transform: translateX(-5px); }
            75%       { transform: translateX(5px); }
        }
        .shake { animation: shake 0.3s ease; }

        .back-link {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            font-weight: 400;
            letter-spacing: 0.06em;
            color: var(--ink-xlight);
            text-decoration: none;
            display: inline-block;
            margin-bottom: 1.8rem;
            transition: color 0.15s;
        }
        .back-link:hover {
            color: var(--ink);
            text-decoration: none;
        }

        .footer-note {
            font-family: var(--font-mono);
            font-size: 0.62rem;
            color: var(--ink-xlight);
            letter-spacing: 0.04em;
        }
    </style>
</head>

<body>

<div class="otp-wrap">

    <%-- Back link to login page --%>
    <a href="/login" class="back-link">← back</a>


    <p class="otp-eyebrow">Security · Verification</p>

    <h1 class="otp-heading">Enter your<br/>one-time code.</h1>

    <%-- jte: output-escape email value; use $unsafe{} only if pre-sanitised --%>
    <p class="otp-sub mt-2">
        Sent to&nbsp;<strong>${email.replaceAll(".(?=.{13})", "*")}</strong>
    </p>

    <hr class="rule"/>

    <%-- jte: CSRF token passed as @param from controller --%>
    <form action="/otp/verify" method="post" id="otp-form">

        ${csrfHiddenInput}

        <%-- 6 digit inputs — values pre-filled from otpForm if server round-trips --%>
        <div class="otp-row" id="otp-container">
            <input type="text" inputmode="numeric" maxlength="1"
                   name="digit1" id="otp-0"
                   class="otp-input form-control${errorMessage != null ? " error" : ""}"
                   value="${otpForm.digit1() != null ? otpForm.digit1() : ""}"
                   autocomplete="one-time-code" aria-label="Digit 1"/>

            <input type="text" inputmode="numeric" maxlength="1"
                   name="digit2" id="otp-1"
                   class="otp-input form-control${errorMessage != null ? " error" : ""}"
                   value="${otpForm.digit2() != null ? otpForm.digit2() : ""}"
                   autocomplete="off" aria-label="Digit 2"/>

            <input type="text" inputmode="numeric" maxlength="1"
                   name="digit3" id="otp-2"
                   class="otp-input form-control${errorMessage != null ? " error" : ""}"
                   value="${otpForm.digit3() != null ? otpForm.digit3() : ""}"
                   autocomplete="off" aria-label="Digit 3"/>

            <span class="otp-dot">—</span>

            <input type="text" inputmode="numeric" maxlength="1"
                   name="digit4" id="otp-3"
                   class="otp-input form-control${errorMessage != null ? " error" : ""}"
                   value="${otpForm.digit4() != null ? otpForm.digit4() : ""}"
                   autocomplete="off" aria-label="Digit 4"/>

            <input type="text" inputmode="numeric" maxlength="1"
                   name="digit5" id="otp-4"
                   class="otp-input form-control${errorMessage != null ? " error" : ""}"
                   value="${otpForm.digit5() != null ? otpForm.digit5() : ""}"
                   autocomplete="off" aria-label="Digit 5"/>

            <input type="text" inputmode="numeric" maxlength="1"
                   name="digit6" id="otp-5"
                   class="otp-input form-control${errorMessage != null ? " error" : ""}"
                   value="${otpForm.digit6() != null ? otpForm.digit6() : ""}"
                   autocomplete="off" aria-label="Digit 6"/>
        </div>

        <%-- jte: render error message when present --%>
        @if(errorMessage != null)
            <p class="err-msg">${errorMessage}</p>
        @endif

        <hr class="rule"/>

        <!-- Timer -->
        <div class="mb-4">
            <div class="timer-row">
                <span class="timer-label">expires in</span>
                <span id="timer-display">3:00</span>
            </div>
            <div class="timer-track">
                <div class="timer-bar" id="timer-bar"></div>
            </div>
        </div>

        <button type="submit" class="btn-verify" id="submit-btn" disabled>
            <span class="spinner" aria-hidden="true"></span>
            <span class="btn-text">Verify</span>
        </button>

    </form>

    <!-- Resend (hidden until timer expires — shown by JS) -->
    <div id="resend-wrapper" style="display:none; margin-top:0.8rem;">
        <button type="button" class="resend-btn" onclick="resetUI(); handleResend();">
            resend code →
        </button>
    </div>

    <!-- Resend success flash (JS-driven) -->
    <p id="resend-flash" class="resend-ok" style="display:none; margin-top:0.8rem;">
        ✓ New code sent.
    </p>

    <hr class="rule"/>

    <p class="footer-note">Didn't receive it? Check your spam folder.</p>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    /**********************
       OTP Input Behaviour
    ***********************/
    const inputs    = Array.from(document.querySelectorAll('.otp-input'));
    const submitBtn = document.getElementById('submit-btn');

    function checkFilled() {
        submitBtn.disabled = !inputs.every(i => /^\d$/.test(i.value));
    }

    inputs.forEach((inp, idx) => {
        inp.addEventListener('input', e => {
            const v = e.target.value.replace(/\D/g, '');
            e.target.value = v ? v[v.length - 1] : '';
            inp.classList.toggle('filled', !!e.target.value);
            inp.classList.remove('error');
            if (e.target.value && idx < inputs.length - 1) inputs[idx + 1].focus();
            checkFilled();
        });

        inp.addEventListener('keydown', e => {
            if (e.key === 'Backspace' && !inp.value && idx > 0) {
                inputs[idx - 1].value = '';
                inputs[idx - 1].classList.remove('filled');
                inputs[idx - 1].focus();
                checkFilled();
            }
            if (e.ctrlKey || e.metaKey) return;
            if (!/^\d$/.test(e.key) && !['Backspace','Tab','ArrowLeft','ArrowRight','Delete'].includes(e.key)) {
                e.preventDefault();
            }
        });

        inp.addEventListener('paste', e => {
            e.preventDefault();
            const t = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '');
            if (!t) return;
            // Fill from the current box onwards, wrapping remaining digits
            let pos = idx;
            for (let n = 0; n < t.length && pos < inputs.length; n++, pos++) {
                inputs[pos].value = t[n];
                inputs[pos].classList.toggle('filled', true);
                inputs[pos].classList.remove('error');
            }
            // Focus the next empty box, or the last filled one
            const nextEmpty = inputs.find((i, n) => n >= idx && !i.value);
            (nextEmpty || inputs[Math.min(pos - 1, inputs.length - 1)]).focus();
            checkFilled();
        });

        inp.addEventListener('copy', e => {
            // Copy all filled digits to clipboard on Ctrl+C
            const filled = inputs.map(i => i.value).join('');
            if (filled) {
                e.preventDefault();
                e.clipboardData.setData('text/plain', filled);
            }
        });

        inp.addEventListener('focus', () => inp.select());
    });

    // Shake + mark error inputs on server-side validation failure
    (function() {
        const err = document.querySelector('.err-msg');
        if (err && err.offsetParent !== null) {
            const c = document.getElementById('otp-container');
            void c.offsetWidth;
            c.classList.add('shake');
            inputs.forEach(i => i.classList.add('error'));
        }
    })();

    /*****************************************************
       2-Minute Countdown (Configurable with TTL_SECONDS)
    ******************************************************/
    const TOTAL       = ${OtpService.TTL_SECONDS};
    let   secondsLeft = TOTAL;

    const timerDisplay  = document.getElementById('timer-display');
    const timerBar      = document.getElementById('timer-bar');
    const resendWrapper = document.getElementById('resend-wrapper');

    function fmt(num) {
      return ""+Math.floor(num/60)+":"+String(num%60).padStart(2,'0');
    }

    function applyState(s) {
        timerBar.style.width = (s / TOTAL * 100) + '%';
        const cls = s > 60 ? '' : s > 20 ? 'warning' : 'danger';
        timerBar.className     = 'timer-bar' + (cls ? ' ' + cls : '');
        timerDisplay.className = cls;
    }

    let ticker = null;

    function startTimer() {
        ticker = setInterval(() => {
            secondsLeft--;
            timerDisplay.textContent = fmt(secondsLeft);
            applyState(secondsLeft);
            if (secondsLeft <= 0) {
                clearInterval(ticker);
                timerDisplay.textContent = '0:00';
                timerBar.style.width = '0%';
                resendWrapper.style.display = 'block';
            }
        }, 1000);
    }

    applyState(TOTAL);
    startTimer();

    /***********************
       Resend Handler
    ************************/
    function handleResend() {
      const csrfToken = '${Objects.nonNull(csrfToken) ? csrfToken.getToken() : ""}';
      const csrfParam = '${Objects.nonNull(csrfToken) ? csrfToken.getParameterName() : ""}';

      fetch('/otp/resend', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-CSRF-TOKEN': csrfToken
        },
        body: encodeURIComponent(csrfParam) + '=' + encodeURIComponent(csrfToken)
      })
      .then(r => { if (r.ok || r.redirected) console.log('Resend code submitted') })
      .catch(() => {
        console.log('Error resending code, redirecting to login')
        window.location.href = '/login?logout';
      });
    }

    function resetUI() {
        clearInterval(ticker);
        secondsLeft = TOTAL;
        timerDisplay.textContent = fmt(TOTAL);
        applyState(TOTAL);
        resendWrapper.style.display = 'none';
        startTimer();

        inputs.forEach(i => { i.value = ''; i.classList.remove('filled','error'); });
        inputs[0].focus();
        checkFilled();

        const flash = document.getElementById('resend-flash');
        flash.style.display = 'block';
        setTimeout(() => flash.style.display = 'none', 3000);
    }

    /************************
       Verify button spinner
    *************************/
    document.getElementById('otp-form').addEventListener('submit', function () {
        const btn = document.getElementById('submit-btn');
        btn.classList.add('loading');
        btn.disabled = true;
    });

    window.addEventListener('DOMContentLoaded', () => inputs[0].focus());
</script>
</body>
</html>
