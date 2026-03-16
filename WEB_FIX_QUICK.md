# ✅ Fix Google Sign-In Web Error - 2 Minutes

## Your Error

```
Error: Exception: Google Sign-In error: Assertion failed
"ClientID not set. Either set it on a <meta name=\"google-signin-client_id\"
```

## Quick Fix

### Step 1: Get Your Web Client ID (1 minute)

Go to: https://console.cloud.google.com

1. Select your project
2. Go to **Credentials**
3. Find your "OAuth 2.0 Client IDs" for "Web application"
4. Copy the **Client ID**

It looks like: `123456789-abcdefghijklmnop.apps.googleusercontent.com`

### Step 2: Add to web/index.html (30 seconds)

**File:** `web/index.html`

Find this line:

```html
<meta
  name="google-signin-client_id"
  content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com"
/>
```

Replace `YOUR_WEB_CLIENT_ID` with your actual Client ID from Step 1.

Example:

```html
<meta
  name="google-signin-client_id"
  content="123456789-abcdefghijklmnop.apps.googleusercontent.com"
/>
```

### Step 3: Run Again (30 seconds)

```bash
flutter run -d chrome
```

## Done! ✅

Your web app should now work with Google Sign-In!

---

## If You Don't Have a Web Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your Firebase project
3. Go to **Credentials** → **Create Credentials** → **OAuth client ID**
4. Choose **Web application**
5. Add authorized origins:
   ```
   http://localhost:3000
   http://localhost:5000
   http://localhost:8080
   ```
6. Click **Create**
7. Copy the Client ID
8. Follow **Step 2** above

---

## Platform-Specific Guide

See: [WEB_GOOGLE_SIGNIN_SETUP.md](./WEB_GOOGLE_SIGNIN_SETUP.md)

---

**Time to fix: ~2 minutes** ⏱️
