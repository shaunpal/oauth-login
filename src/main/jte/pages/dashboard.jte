@import java.time.Instant
@import java.time.ZoneId
@import java.util.Collection
@import com.example.auth.security.CsrfHiddenInput
@import org.springframework.security.core.GrantedAuthority
@import org.springframework.security.web.csrf.CsrfToken
@import java.util.Objects

@param String username = ""
@param String email = ""
@param String deviceName = ""
@param String deviceBrandName = ""
@param String osName = ""
@param String browserName = ""
@param String deviceLocation = ""
@param Collection<? extends GrantedAuthority> authorities = null
@param CsrfHiddenInput csrfHiddenInput
@param CsrfToken csrfToken

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard</title>

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
        }

        /* ── Content width — single source of truth ── */
        :root {
            --content-max-width: 860px;
            --content-padding:   2rem;
        }

        /* ── Top nav ── */
        .topnav {
            border-bottom: 1px solid var(--rule);
            background: var(--white);
        }

        .topnav-inner {
            max-width: var(--content-max-width);
            margin: 0 auto;
            padding: 1.2rem var(--content-padding);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .nav-brand {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--ink-xlight);
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 1.6rem;
        }

        .nav-email {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            color: var(--ink-light);
        }

        /* ── Logout form/button ── */
        .btn-logout {
            font-family: var(--font-mono);
            font-size: 0.68rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            background: none;
            border: none;
            padding: 0;
            cursor: pointer;
            transition: color 0.15s;
        }
        .btn-logout:hover { color: var(--danger); }

        /* ── Page layout ── */
        .page {
            max-width: var(--content-max-width);
            margin: 0 auto;
            padding: 3rem var(--content-padding);
            animation: rise 0.5s cubic-bezier(0.22,1,0.36,1) both;
        }
        @keyframes rise {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Section eyebrow ── */
        .eyebrow {
            font-family: var(--font-mono);
            font-size: 0.63rem;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            margin-bottom: 1.6rem;
        }

        /* ── Rule ── */
        .rule {
            border: none;
            border-top: 1px solid var(--rule);
            margin: 2.5rem 0;
        }

        /* ── Profile card ── */
        .profile-card {
            display: flex;
            align-items: flex-start;
            gap: 2rem;
        }

        .avatar {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: var(--ink);
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-mono);
            font-size: 1.2rem;
            font-weight: 500;
            flex-shrink: 0;
            letter-spacing: 0.05em;
        }

        .profile-info { flex: 1; }

        .profile-name {
            font-size: 2rem;
            font-weight: 300;
            letter-spacing: -0.01em;
            line-height: 1.1;
            margin-bottom: 0.35rem;
        }

        .profile-email {
            font-family: var(--font-mono);
            font-size: 0.75rem;
            font-weight: 300;
            color: var(--ink-light);
        }

        /* ── Detail grid ── */
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0;
        }

        .detail-row {
            display: contents;
        }

        .detail-label {
            font-family: var(--font-mono);
            font-size: 0.63rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            padding: 0.9rem 0;
            border-bottom: 1px solid var(--rule);
        }

        .detail-value {
            font-family: var(--font-mono);
            font-size: 0.75rem;
            color: var(--ink);
            padding: 0.9rem 0;
            border-bottom: 1px solid var(--rule);
            text-align: right;
        }

        /* ── Stats row ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1px;
            background: var(--rule);
            border: 1px solid var(--rule);
            border-radius: 4px;
            overflow: hidden;
        }

        .stat-cell {
            background: var(--white);
            padding: 1.4rem 1.5rem;
        }

        .stat-label {
            font-family: var(--font-mono);
            font-size: 0.62rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 300;
            letter-spacing: -0.02em;
            color: var(--ink);
            line-height: 1;
        }

        /* ── Activity list ── */
        .activity-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.85rem 0;
            border-bottom: 1px solid var(--rule);
        }
        .activity-item:last-child { border-bottom: none; }

        .activity-desc {
            font-family: var(--font-mono);
            font-size: 0.72rem;
            color: var(--ink);
        }

        .activity-time {
            font-family: var(--font-mono);
            font-size: 0.65rem;
            color: var(--ink-xlight);
            white-space: nowrap;
            margin-left: 1rem;
        }

        /* ── Section heading ── */
        .section-title {
            font-size: 1.1rem;
            font-weight: 400;
            letter-spacing: -0.01em;
            color: var(--ink);
            margin-bottom: 1rem;
        }

        /* ── Detail grid ── */
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0;
        }

        .detail-row {
            display: contents;
        }

        .detail-label {
            font-family: var(--font-mono);
            font-size: 0.63rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            padding: 0.9rem 0;
            border-bottom: 1px solid var(--rule);
        }

        .detail-value {
            font-family: var(--font-mono);
            font-size: 0.75rem;
            color: var(--ink);
            padding: 0.9rem 0;
            border-bottom: 1px solid var(--rule);
            text-align: right;
        }

        /* ── Stats row ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1px;
            background: var(--rule);
            border: 1px solid var(--rule);
            border-radius: 4px;
            overflow: hidden;
        }

        .stat-cell {
            background: var(--white);
            padding: 1.4rem 1.5rem;
        }

        .stat-label {
            font-family: var(--font-mono);
            font-size: 0.62rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 300;
            letter-spacing: -0.02em;
            color: var(--ink);
            line-height: 1;
        }

        /* ── Activity list ── */
        .activity-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.85rem 0;
            border-bottom: 1px solid var(--rule);
        }
        .activity-item:last-child { border-bottom: none; }

        .activity-desc {
            font-family: var(--font-mono);
            font-size: 0.72rem;
            color: var(--ink);
        }

        .activity-time {
            font-family: var(--font-mono);
            font-size: 0.65rem;
            color: var(--ink-xlight);
            white-space: nowrap;
            margin-left: 1rem;
        }

        /* ── Section heading ── */
        .section-title {
            font-size: 1.1rem;
            font-weight: 400;
            letter-spacing: -0.01em;
            color: var(--ink);
            margin-bottom: 1rem;
        }

        /* ── Inactivity modal overlay ── */
        .idle-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(17,17,17,0.45);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .idle-overlay.visible { display: flex; }

        .idle-modal {
            background: var(--white);
            border: 1px solid var(--rule);
            border-radius: 8px;
            padding: 2.2rem 2.4rem;
            width: 100%;
            max-width: 360px;
            margin: 1rem;
            animation: modal-in 0.2s cubic-bezier(0.22,1,0.36,1) both;
        }
        @keyframes modal-in {
            from { opacity: 0; transform: translateY(10px) scale(0.98); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        .idle-eyebrow {
            font-family: var(--font-mono);
            font-size: 0.62rem;
            letter-spacing: 0.16em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            margin-bottom: 1rem;
        }

        .idle-heading {
            font-size: 1.4rem;
            font-weight: 300;
            letter-spacing: -0.01em;
            line-height: 1.2;
            color: var(--ink);
            margin-bottom: 0.5rem;
        }

        .idle-sub {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            font-weight: 300;
            color: var(--ink-light);
            line-height: 1.7;
            margin-bottom: 1.6rem;
        }

        .idle-ring-wrap {
            display: flex;
            align-items: center;
            gap: 0.9rem;
            margin-bottom: 1.8rem;
        }
        .idle-ring { transform: rotate(-90deg); flex-shrink: 0; }
        .idle-ring-track { fill: none; stroke: var(--rule); stroke-width: 2.5; }
        .idle-ring-bar {
            fill: none; stroke: var(--ink); stroke-width: 2.5;
            stroke-linecap: round;
            transition: stroke-dashoffset 1s linear, stroke 0.5s ease;
        }
        .idle-ring-bar.warning { stroke: #b7791f; }
        .idle-ring-bar.danger  { stroke: var(--danger); }

        .idle-countdown-text {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            color: var(--ink-light);
            line-height: 1.6;
        }
        .idle-countdown-text strong {
            font-size: 1.1rem;
            font-weight: 500;
            color: var(--ink);
            display: block;
        }
        .idle-countdown-text strong.warning { color: #b7791f; }
        .idle-countdown-text strong.danger  { color: var(--danger); }

        .idle-actions { display: flex; gap: 0.8rem; }

        .btn-stay {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--white);
            background: var(--ink);
            border: 1px solid var(--ink);
            border-radius: 4px;
            padding: 11px 20px;
            cursor: pointer;
            transition: background 0.18s, color 0.18s;
            flex: 1;
        }
        .btn-stay:hover { background: var(--white); color: var(--ink); }

        .btn-signout-now {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--ink-xlight);
            background: none;
            border: 1px solid var(--rule);
            border-radius: 4px;
            padding: 11px 20px;
            cursor: pointer;
            transition: color 0.15s, border-color 0.15s;
            flex: 1;
        }
        /* ── Offline / session-ended banner ── */
        .offline-banner {
            position: fixed;
            top: -80px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 2000;
            border-radius: 6px;
            padding: 0.75rem 1.2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: 0 4px 24px rgba(0,0,0,0.18);
            transition: top 0.35s cubic-bezier(0.22,1,0.36,1);
            white-space: nowrap;
            pointer-events: none;
        }
        .offline-banner.visible {
            top: 1.2rem;
            pointer-events: auto;
        }

        /* Offline — dark */
        .offline-banner.offline {
            background: var(--ink);
            color: var(--white);
        }

        /* Online / reconnected — light */
        .offline-banner.online {
            background: var(--white);
            color: var(--ink);
            border: 1px solid var(--rule);
        }

        .offline-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            flex-shrink: 0;
            animation: blink 1.2s ease-in-out infinite;
        }
        .offline-banner.offline .offline-dot { background: var(--danger); }
        .offline-banner.online  .offline-dot { background: #2d8a4e; animation: none; }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50%       { opacity: 0.3; }
        }

        .offline-msg {
            font-family: var(--font-mono);
            font-size: 0.7rem;
            letter-spacing: 0.04em;
        }
        .offline-banner.offline .offline-msg { color: var(--white); }
        .offline-banner.online  .offline-msg { color: var(--ink); }

        .banner-close {
            font-family: var(--font-mono);
            font-size: 0.8rem;
            line-height: 1;
            color: var(--ink-xlight);
            background: none;
            border: none;
            padding: 0 0 0 0.2rem;
            cursor: pointer;
            transition: color 0.15s;
            margin-left: 0.2rem;
        }
        .banner-close:hover { color: var(--ink); }

        /* responsive */
        @media (max-width: 600px) {
            :root { --content-padding: 1.2rem; }
            .nav-email { display: none; }
            .profile-card { flex-direction: column; gap: 1rem; }
            .detail-grid { grid-template-columns: 1fr 1fr; }
            .stats-row { grid-template-columns: 1fr; }
            .offline-banner { white-space: normal; max-width: calc(100vw - 2rem); }
        }
    </style>
</head>

<body>

<%-- Offline banner — no close button, stays until reconnected --%>
<div class="offline-banner offline" id="banner-offline" role="alert" aria-live="assertive">
    <span class="offline-dot"></span>
    <span class="offline-msg">Server is offline.</span>
</div>

<%-- Online / reconnected banner — has a close button --%>
<div class="offline-banner online" id="banner-online" role="status" aria-live="polite">
    <span class="offline-dot"></span>
    <span class="offline-msg">Server is online and reconnected.</span>
    <button class="banner-close" onclick="closeOnlineBanner()" aria-label="Dismiss">✕</button>
</div>

<%-- Inactivity modal --%>
<div class="idle-overlay" id="idle-overlay" role="dialog" aria-modal="true" aria-labelledby="idle-heading">
    <div class="idle-modal">
        <p class="idle-eyebrow">Session · Timeout</p>
        <h2 class="idle-heading" id="idle-heading">Still there?</h2>
        <p class="idle-sub">
            You've been inactive for a while.<br/>
            You'll be signed out automatically in:
        </p>

        <div class="idle-ring-wrap">
            <%-- SVG countdown ring: circumference of r=22 circle ≈ 138.23 --%>
            <svg class="idle-ring" width="52" height="52" viewBox="0 0 52 52">
                <circle class="idle-ring-track" cx="26" cy="26" r="22"/>
                <circle class="idle-ring-bar" id="idle-ring-bar" cx="26" cy="26" r="22"
                        stroke-dasharray="138.23"
                        stroke-dashoffset="0"/>
            </svg>
            <div class="idle-countdown-text">
                <strong id="idle-count">20</strong>
                seconds remaining
            </div>
        </div>

        <div class="idle-actions">
            <button class="btn-stay" id="btn-stay" onclick="stayLoggedIn()">
                Stay signed in
            </button>
            <button class="btn-signout-now" onclick="doLogout()">
                Sign out now
            </button>
        </div>
    </div>
</div>

<%-- Top navigation --%>
<nav class="topnav">
    <div class="topnav-inner">
        <span class="nav-brand">Dashboard</span>
        <div class="nav-right">
            <%-- jte: render authenticated user's email --%>
            <span class="nav-email">${email}</span>

            <%-- jte: logout POST form with CSRF token --%>
            <form action="/logout" method="post" style="margin:0;">
                ${csrfHiddenInput}
                <button type="submit" class="btn-logout">Sign out</button>
            </form>
        </div>
    </div>
</nav>

<div class="page">

    <%-- Profile section --%>
    <p class="eyebrow">Account · Profile</p>

    <div class="profile-card">
        <%-- Avatar initials derived from name --%>
        <div class="avatar">${username.isEmpty() ? email.isEmpty() ? "" : email.substring(0, 1).toUpperCase() : username.substring(0, 1).toUpperCase()}</div>
        <div class="profile-info">
            <h1 class="profile-name">${username.isEmpty() ? "Unknown" : username}</h1>
            <p class="profile-email">${email}</p>
        </div>
    </div>


    <hr class="rule"/>

    <%-- Detail rows --%>
    <div class="detail-grid">
        <span class="detail-label">LOGIN TIME</span>
        <span class="detail-value">${String.valueOf(Instant.now().atZone(ZoneId.systemDefault()))}</span>

        <span class="detail-label">DEVICE</span>
        <span class="detail-value">${deviceName}</span>

        <span class="detail-label">Operating System</span>
        <span class="detail-value">${osName}</span>

        <span class="detail-label">Detected Browser</span>
        <span class="detail-value">${browserName}</span>

        <span class="detail-label">LOCATION</span>
        <span class="detail-value">${deviceLocation}</span>

    </div>

    <hr class="rule"/>

    <%-- Stats --%>
<%--    <p class="eyebrow" style="margin-bottom:1rem;">Overview</p>--%>
<%--    <div class="stats-row">--%>
<%--        <div class="stat-cell">--%>
<%--            <p class="stat-label">Sessions</p>--%>
<%--            <p class="stat-value">${user.totalSessions()}</p>--%>
<%--        </div>--%>
<%--        <div class="stat-cell">--%>
<%--            <p class="stat-label">Days active</p>--%>
<%--            <p class="stat-value">${user.daysActive()}</p>--%>
<%--        </div>--%>
<%--        <div class="stat-cell">--%>
<%--            <p class="stat-label">Logins this month</p>--%>
<%--            <p class="stat-value">${user.loginsThisMonth()}</p>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <hr class="rule"/>--%>

<%--    --%><%-- Recent activity --%>
<%--    <p class="eyebrow" style="margin-bottom:1rem;">Recent activity</p>--%>
<%--    @for(var activity : user.recentActivity())--%>
<%--        <div class="activity-item">--%>
<%--            <span class="activity-desc">${activity.description()}</span>--%>
<%--            <span class="activity-time">${activity.timestamp()}</span>--%>
<%--        </div>--%>
<%--    @endfor--%>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.2.0/bundles/stomp.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script>
    /**********************************************************************
       Inactivity auto-logout
       • IDLE_MS      — inactivity threshold before prompt (3 min)
       • COUNTDOWN_S  — seconds to auto-logout after prompt appears (20 s)
    ***********************************************************************/
    const IDLE_MS     = 3 * 60 * 1000; // 3 minutes
    const COUNTDOWN_S = 20;
    const CIRCUMFERENCE = 138.23;      // circle circumference for the spinner on timeout prior to logout

    const overlay   = document.getElementById('idle-overlay');
    const countEl   = document.getElementById('idle-count');
    const ringBar   = document.getElementById('idle-ring-bar');

    let idleTimer    = null;
    let countTimer   = null;
    let countLeft    = COUNTDOWN_S;

    /* Show the inactivity prompt */
    function showPrompt() {
        if (overlay.classList.contains('visible')) return; // ignore idleTimer on inactivity prompt overlay
        countLeft = COUNTDOWN_S;
        updateRing(countLeft);
        overlay.classList.add('visible');
        document.getElementById('btn-stay').focus();

        countTimer = setInterval(() => {
            countLeft--;
            updateRing(countLeft);
            if (countLeft <= 0) {
                clearInterval(countTimer);
                doLogout();
            }
        }, 1000);
    }

    /* Update the SVG ring + number */
    function updateRing(s) {
        countEl.textContent = s;
        const offset = CIRCUMFERENCE * (1 - s / COUNTDOWN_S);
        ringBar.style.strokeDashoffset = offset;

        const cls = s > 10 ? '' : s > 5 ? 'warning' : 'danger';
        ringBar.className = 'idle-ring-bar' + (cls ? ' ' + cls : '');
        countEl.className = cls;
    }

    /* User clicked "Stay signed in" */
    function stayLoggedIn() {
        clearInterval(countTimer);
        overlay.classList.remove('visible');
        // Notify the server to refresh the session
        fetch('/session/keep-alive', { method: 'POST',
            headers: { 'X-CSRF-TOKEN': '${Objects.nonNull(csrfToken) ? csrfToken.getToken() : ""}' }
        }).catch(() => {});
        // Restart the idle clock
        idleTimer = setTimeout(showPrompt, IDLE_MS);
    }

    /* Perform logout */
    function doLogout() {
        clearInterval(countTimer);
        clearTimeout(idleTimer);
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/logout';
        const csrf  = document.createElement('input');
        csrf.type   = 'hidden';
        csrf.name   = '${Objects.nonNull(csrfToken) ? csrfToken.getParameterName() : ""}';
        csrf.value  = '${Objects.nonNull(csrfToken) ? csrfToken.getToken() : ""}';
        form.appendChild(csrf);
        document.body.appendChild(form);
        form.submit();
    }

    // Kick off the idle clock on page load
    idleTimer = setTimeout(showPrompt, IDLE_MS);

    /********************************************************************
       Server heartbeats ping every 10s
         • After max unsuccessful attempts → redirect to /login?expired
         • network error → show offline banner
         • recovers on successful ping-pong → show online banner
    ********************************************************************/

    let reconnectAttempts  = 0;
    const MAX_ATTEMPTS_ON_RECONNECTING = 5;
    const WEBSOCKET_URL    = "http://localhost:8080/ws";
    const bannerOffline    = document.getElementById('banner-offline');
    const bannerOnline     = document.getElementById('banner-online');
    let serverWasOffline   = false;

    function showOfflineBanner() {
        if (bannerOffline.classList.contains('visible')) return;
        bannerOnline.classList.remove('visible');
        // Hide idle prompt if open
        overlay.classList.remove('visible');
        clearInterval(countTimer);
        clearTimeout(idleTimer);
        bannerOffline.classList.add('visible');
        serverWasOffline = true;
    }

    function showOnlineBanner() {
        bannerOffline.classList.remove('visible');
        bannerOnline.classList.add('visible');
        serverWasOffline = false;
        // Restart idle clock now that server is back
        idleTimer = setTimeout(showPrompt, IDLE_MS);
    }

    function closeOnlineBanner() {
        bannerOnline.classList.remove('visible');
    }

    const client = new StompJs.Client({
        webSocketFactory: () => new SockJS(WEBSOCKET_URL),
        connectHeaders: {
            'X-CSRF-TOKEN': '${Objects.nonNull(csrfToken) ? csrfToken.getToken() : ""}'
        },
        debug: function (str) {
            console.log(str);
        },
        reconnectDelay: 5000,
        heartbeatIncoming: 10000,
        heartbeatOutgoing: 10000,

        onConnect: () => {
          if (serverWasOffline) showOnlineBanner();
          console.log('Successfully connected!');
          client.subscribe('/topic', message => {
            console.log('Received: ' + message.body);
          });
        },

        onStompError: (frame) => {
          showOfflineBanner();
          console.error('Broker reported error: ' + frame.headers['message']);
          console.error('Additional details: ' + frame.body);

          if (frame.headers['message'].includes('401') || frame.headers['message'].includes('403')) {
            window.location.href = '/login?expired'; // Redirect to login
          }
          window.location.href = "/login?logout";
        },

        onDisconnect: (frame) => {
          showOfflineBanner();
          console.log('Disconnected');
        },
        onWebSocketError: (event) => {
          console.error('WebSocket error:', event);
        },
        onWebSocketClose: (event) => {
          showOfflineBanner();
          reconnectAttempts++;
          console.warn('Connection closed. Attempt '+ reconnectAttempts+' of '+MAX_ATTEMPTS_ON_RECONNECTING);

          if (reconnectAttempts >= MAX_ATTEMPTS_ON_RECONNECTING) {
            console.error("Max reconnect attempts reached. Redirecting to login...");
            client.deactivate(); // Stop trying
            reconnectAttempts = 0; // reset reconnectAttempts to 0
            window.location.href = "/login?logout";
          }
        },
    });

    client.activate();
</script>
</body>
</html>
