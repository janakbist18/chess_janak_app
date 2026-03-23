# ✅ Django Backend Integration - Setup Checklist

## Frontend Setup (✅ COMPLETED)

- [x] Updated `lib/core/config/env.dart` with Django backend URLs
  - Android Emulator: `http://10.0.2.2:8000`
  - Change IP for physical device/production as needed

- [x] Implemented `AuthRemoteDataSource` with all methods:
  - login, register, verifyOtp, googleSignIn
  - forgotPassword, resetPassword, token refresh
  - Automatic token storage & retrieval

- [x] Updated `ChessRemoteDataSource` with Django endpoints:
  - Connect to `/api/chess/room/{room_id}/` for game state
  - Connect to `/api/rooms/create/`, `/api/rooms/join/` for room management
  - WebSocket support for real-time moves

- [x] WebSocket client ready to connect to Django Channels:
  - Path: `ws://backend:8000/ws/room/{room_id}/`
  - Auto-reconnect with exponential backoff
  - JWT authentication support

- [x] Created `DJANGO_INTEGRATION.md` with complete reference

## Backend Setup (👈 YOU NEED TO DO)

### Step 1: Start Django Backend

```bash
cd c:\Users\ACER\OneDrive\Desktop\chess_janak_backend\chess_janak_backend
.venv\Scripts\activate
python manage.py runserver 0.0.0.0:8000
```

✅ Expected: Server running on `http://localhost:8000`

### Step 2: Verify Backend is Ready

Check in browser: `http://localhost:8000/api/`

You should see:

```json
{
  "project": "chess_janak_backend",
  "status": "running",
  "auth_base_url": "/api/auth/",
  "rooms_base_url": "/api/rooms/",
  "chess_base_url": "/api/chess/"
}
```

### Step 3: Test a Simple Endpoint

```bash
# Get health check
curl http://localhost:8000/api/auth/

# Or use Postman:
# GET http://localhost:8000/api/auth/
```

## Device Testing Setup (👈 OPTIONAL)

### For Physical Device Testing:

1. **Find your laptop IP:**

   ```bash
   ipconfig  # Windows
   # Look for IPv4 Address like 192.168.1.100
   ```

2. **Update Flutter Config:**
   Edit `lib/core/config/env.dart`:

   ```dart
   static const String apiBaseUrl = 'http://192.168.1.100:8000/api';
   static const String wsBaseUrl = 'ws://192.168.1.100:8000';
   ```

3. **Update Django Settings:**
   Edit `.env` in Django:

   ```env
   ALLOWED_HOSTS=localhost,127.0.0.1,192.168.1.100
   CORS_ALLOWED_ORIGINS=http://192.168.1.100:8000,http://localhost:8000
   ```

4. **Restart Django:**
   ```bash
   # Stop current server (Ctrl+C)
   # Run again
   python manage.py runserver 0.0.0.0:8000
   ```

## Flutter App Testing (👈 YOU NEED TO DO)

### Step 1: Run Flutter App

```bash
cd c:\Users\ACER\OneDrive\Desktop\chess_janak_app\chess_janak_app
flutter run
```

### Step 2: Test Auth Flow

- [ ] Register new account
- [ ] Verify account created in Django admin
- [ ] Login with credentials
- [ ] See user profile load correctly
- [ ] Logout clears session

### Step 3: Test Room Creation

- [ ] Create game room → See room_id returned
- [ ] Get room invite code
- [ ] Another user joins with code
- [ ] Both users see room details

### Step 4: Test WebSocket Connection

- [ ] Connect to room → WebSocket connects
- [ ] Make chess move → Other player receives move
- [ ] See real-time board updates
- [ ] Chat message sending (if implemented)

### Step 5: End-to-End Game

- [ ] Create room with one account
- [ ] Join with another account
- [ ] Play complete chess game
- [ ] Game ends correctly with result

## Troubleshooting

| Problem                  | Solution                                                       |
| ------------------------ | -------------------------------------------------------------- |
| CORS Error               | Check `CORS_ALLOWED_ORIGINS` in Django `.env`                  |
| Can't connect to backend | Verify Django is running on 0.0.0.0:8000                       |
| WebSocket fails          | Check `/ws/room/{id}/` path (not `/api/ws/...`)                |
| Token errors             | Ensure `ACCESS_TOKEN_LIFETIME_MINUTES` is set in Django `.env` |
| Device can't connect     | Check IP is correct and device is on same WiFi                 |
| Port already in use      | `python manage.py runserver 0.0.0.0:8001` (use different port) |

## Final Verification Checklist

- [ ] Django backend running on `0.0.0.0:8000`
- [ ] Can access `http://localhost:8000/api/` in browser
- [ ] Flutter app configured with correct backend URL
- [ ] Can register/login in Flutter app
- [ ] Can create and join game rooms
- [ ] WebSocket connects without errors
- [ ] Can make chess moves and see updates
- [ ] Can see other player's moves in real-time

---

## Quick Reference

**Backend Location:**

```
c:\Users\ACER\OneDrive\Desktop\chess_janak_backend\chess_janak_backend
```

**Frontend Location:**

```
c:\Users\ACER\OneDrive\Desktop\chess_janak_app\chess_janak_app
```

**Backend URL:**

```
http://localhost:8000
API: http://localhost:8000/api/
WebSocket: ws://localhost:8000/ws/room/{room_id}/
```

**Flutter Config File:**

```
lib/core/config/env.dart
lib/core/config/api_endpoints.dart
```

**Datasources (Just updated):**

```
lib/features/auth/data/datasources/auth_remote_datasource.dart
lib/features/chess/data/datasources/chess_remote_datasource.dart
```

---

## Documentation Files

- **DJANGO_INTEGRATION.md** - Complete integration reference with examples
- **CHESS_IMPLEMENTATION.md** - Chess engine & game logic
- **SETUP_CHECKLIST.md** - This file (setup steps)

---

**You're all set! 🎉 Just start the Django backend and run the Flutter app!**
