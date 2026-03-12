# 🎯 Chess Janak - Django Backend Integration

Your Flutter app is now configured to work with your Django backend!

## ✅ What's Been Updated

### 1. **Environment Configuration** (`lib/core/config/env.dart`)

- Updated to point to Django backend at `http://10.0.2.2:8000`
- Android Emulator: Uses `10.0.2.2` (special alias for host)
- Physical Device: Change to your local IP (e.g., `192.168.1.100:8000`)
- Production: Update with your deployed domain

### 2. **Auth Datasource** (`lib/features/auth/data/datasources/auth_remote_datasource.dart`)

✅ Fully implemented to work with Django:

- `login()` - Authenticates with `/api/auth/login/`
- `register()` - Creates account at `/api/auth/register/`
- `verifyOtp()` - Verifies OTP at `/api/auth/verify-otp/`
- `googleSignIn()` - Google auth at `/api/auth/google/`
- `getCurrentUser()` - Fetches user profile at `/api/auth/me/`
- `forgotPassword()` - Triggers password reset
- `resetPassword()` - Resets password with OTP token

### 3. **Chess Datasource** (`lib/features/chess/data/datasources/chess_remote_datasource.dart`)

✅ Updated to work with Django endpoints:

- GET `/api/chess/room/{room_id}/` - Fetch game state
- GET `/api/chess/room/{room_id}/moves/` - Fetch move history
- GET `/api/rooms/mine/` - Get user's active rooms
- POST `/api/rooms/create/` - Create new game room
- POST `/api/rooms/join/` - Join existing room
- GET `/api/rooms/{room_id}/` - Get room details
- GET `/api/rooms/invite/{code}/` - Look up invite codes

### 4. **API Endpoints** (`lib/core/config/api_endpoints.dart`)

✅ Already configured for Django paths:

```dart
/api/auth/login/
/api/auth/register/
/api/auth/verify-otp/
/api/chess/room/{room_id}/
/api/rooms/create/
/api/rooms/mine/
...
```

### 5. **WebSocket Client** (`lib/core/websocket/socket_client.dart`)

✅ Ready to connect to Django Channels:

- Connects to: `ws://your-backend:8000/ws/room/{room_id}/`
- Auto-reconnect with exponential backoff
- JWT token authentication support
- Message listening with callbacks

---

## 🚀 How to Connect

### Step 1: Make Sure Django Backend is Running

```bash
cd c:\Users\ACER\OneDrive\Desktop\chess_janak_backend\chess_janak_backend

# Activate virtual environment
.venv\Scripts\activate

# Run backend
python manage.py runserver 0.0.0.0:8000
```

Django will run on: **http://localhost:8000**
CORS is configured to allow Flutter from: `http://10.0.2.2:8000`

### Step 2: Update Backend IP (If Needed)

**For Physical Device Testing:**

1. Find your laptop's local IP:

   ```bash
   ipconfig  # Windows
   ifconfig  # Mac/Linux
   ```

   Look for IPv4 address like `192.168.1.100`

2. Update `lib/core/config/env.dart`:

   ```dart
   static const String apiBaseUrl = 'http://192.168.1.100:8000/api';
   static const String wsBaseUrl = 'ws://192.168.1.100:8000';
   ```

3. Update Django CORS in `.env`:
   ```env
   CORS_ALLOWED_ORIGINS=http://192.168.1.100:8000,http://localhost:8000
   ```

### Step 3: Run Flutter App

```bash
flutter run
```

### Step 4: Test Authentication Flow

On the app:

1. **Register** → Creates user in Django DB
2. **Login** → Gets JWT tokens, stores in secure storage
3. **Home** → Fetches user profile from `/api/auth/me/`

---

## 🔄 Real-Time Chess with WebSocket

### How It Works

1. **Create Room** → POST `/api/rooms/create/` → Gets `room_id`
2. **Join Room** → POST `/api/rooms/join/` → Confirms join
3. **Connect to WebSocket** → `ws://backend:8000/ws/room/{room_id}/`
4. **Send Move** → Through WebSocket to Django RoomConsumer
5. **Receive Move** → RoomConsumer broadcasts to all players in room

### Example Flow in Code

```dart
// In ChessGameState provider

// 1. Create room
final roomResponse = await chessDataSource.createRoom(
  gameMode: 'blitz',
  timeLimit: 300,
);
final roomId = roomResponse['room_id'];

// 2. Connect to WebSocket
await socketClient.connect(
  '${AppConfig.wsBaseUrl}/ws/room/$roomId/',
  token: jwtToken,
);

// 3. Listen for moves
socketClient.on((message) {
  if (message.type == 'move') {
    // Update game board
    updateGameBoard(message.payload);
  }
});

// 4. Send move
socketClient.send(SocketMessage(
  type: 'move',
  payload: {
    'from': 'e2',
    'to': 'e4',
    'san': 'e4',
  },
));
```

---

## 📡 Django API Reference

### Authentication

**Login**

```
POST /api/auth/login/
Body: {"email": "user@example.com", "password": "pass"}
Response: {
  "access": "jwt_token",
  "refresh": "refresh_token",
  "user": {...}
}
```

**Register**

```
POST /api/auth/register/
Body: {"email": "user@example.com", "password": "pass", "username": "username"}
Response: {
  "access": "jwt_token",
  "user": {...}
}
```

**Verify OTP**

```
POST /api/auth/verify-otp/
Body: {"email": "user@example.com", "otp": "123456"}
Response: {access, refresh, user}
```

**Get Current User**

```
GET /api/auth/me/
Headers: Authorization: Bearer {token}
Response: {id, email, username, avatar, ...}
```

### Rooms (Game Creation)

**Create Room**

```
POST /api/rooms/create/
Body: {"game_mode": "blitz", "time_limit": 300}
Response: {
  "room_id": "uuid",
  "invite_code": "ABC123",
  "white_player": {...},
  "status": "waiting"
}
```

**Join Room**

```
POST /api/rooms/join/
Body: {"invite_code": "ABC123"}
Response: {
  "room_id": "uuid",
  "white_player": {...},
  "black_player": {...},
  "status": "ready"
}
```

**Get My Rooms**

```
GET /api/rooms/mine/
Response: [
  {
    "room_id": "uuid",
    "white_player": {...},
    "black_player": {...},
    "status": "ongoing",
    "invite_code": "ABC123"
  },
  ...
]
```

**Get Room Details**

```
GET /api/rooms/{room_id}/
Response: {
  "room_id": "uuid",
  "white_player": {...},
  "black_player": {...},
  "fen": "...",
  "moves": ["e4", "e5", ...],
  "status": "ongoing"
}
```

### Chess

**Get Game State**

```
GET /api/chess/room/{room_id}/
Response: {
  "room_id": "uuid",
  "fen": "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
  "white_player": {...},
  "black_player": {...},
  "moves": [],
  "status": "ongoing",
  "last_move": null
}
```

**Get Move History**

```
GET /api/chess/room/{room_id}/moves/
Response: [
  {
    "id": "uuid",
    "san": "e4",
    "from": "e2",
    "to": "e4",
    "timestamp": "2024-01-15T10:30:00Z"
  },
  ...
]
```

---

## 🔐 Authentication with JWT

### How Token Flow Works

1. **Login** → Receive `access` and `refresh` tokens
2. **Auto-Added Headers** → ApiClient adds `Authorization: Bearer {token}` to all requests
3. **Token Expires** → After 60 minutes (from your Django settings)
4. **Refresh Token** → Use refresh token to get new access token
5. **Logout** → Clear tokens from SecureStorage

### Token Storage

Tokens are stored in **secure storage** (encrypted):

```dart
// Automatically saved after login
await secureStorage.saveToken(accessToken);
await secureStorage.saveRefreshToken(refreshToken);

// Automatically loaded for API calls
final token = await secureStorage.getToken();
```

---

## 🧪 Testing the Connection

### Test 1: Login via REST API

```bash
# 1. Get a token
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'

# Response:
# {
#   "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
#   "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
#   "user": { ... }
# }

# 2. Use token to get user profile
curl -X GET http://localhost:8000/api/auth/me/ \
  -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc..."
```

### Test 2: Create Room & Join

```bash
# 1. Create room (need valid token)
curl -X POST http://localhost:8000/api/rooms/create/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{"game_mode":"blitz","time_limit":300}'

# Response:
# {
#   "room_id": "abc-123-def",
#   "invite_code": "ABC123DEF",
#   ...
# }

# 2. Get room code and join with another user
curl -X POST http://localhost:8000/api/rooms/join/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token2}" \
  -d '{"invite_code":"ABC123DEF"}'
```

### Test 3: WebSocket Connection

```bash
# Use a WebSocket client or terminal:
websocat ws://localhost:8000/ws/room/abc-123-def/?token=your_jwt_token

# Message format (send as JSON):
# {"type": "move", "from": "e2", "to": "e4"}

# Receive broadcasts from other players in the room
```

---

## ⚠️ Common Issues & Solutions

### Issue 1: CORS Error

```
Error: Access to XMLHttpRequest blocked by CORS policy
```

**Solution:**

- Update Django `.env`:
  ```env
  CORS_ALLOWED_ORIGINS=http://10.0.2.2:8000,http://localhost:8000
  ```
- Restart Django server
- Clear Flutter build cache: `flutter clean`

### Issue 2: WebSocket Connection Fails

```
Error: WebSocketException: Connection closed prematurely
```

**Solutions:**

1. Ensure Django is running: `python manage.py runserver`
2. Check backend URL in `env.dart` matches Django host
3. Verify Django Channels is installed: `pip list | grep channels`
4. Check WebSocket path: `/ws/room/{room_id}/` (no `/api/` prefix)

### Issue 3: Token Expired

```
Error: 401 Unauthorized
```

**Solution:**

- The app automatically refreshes tokens
- If still fails, re-login to get fresh token
- Check `ACCESS_TOKEN_LIFETIME_MINUTES` in Django `.env`

### Issue 4: Physical Device Can't Connect

```
Error: Connection refused to 192.168.1.100:8000
```

**Solutions:**

1. Firewall: Allow port 8000
   ```bash
   # Windows
   netsh advfirewall firewall add rule name="Django" dir=in action=allow protocol=tcp localport=8000
   ```
2. Network: Device and laptop on same WiFi
3. URL: Update `env.dart` with correct local IP
4. Django ALLOWED_HOSTS: Add IP to `.env`
   ```env
   ALLOWED_HOSTS=localhost,127.0.0.1,192.168.1.100
   ```

---

## 📊 Data Model Mapping

### Django User → Flutter AuthUserModel

```
Django User {
  id, email, username, first_name, last_name,
  is_active, date_joined, avatar, bio
}
→
Flutter AuthUserModel {
  id, email, username, avatar, token, refreshToken,
  createdAt, isEmailVerified
}
```

### Django Room → Flutter GameStateModel

```
Django Room {
  id, white_player, black_player, invite_code,
  fen, moves, status, created_at, updated_at
}
→
Flutter GameStateModel {
  gameId, whitePlayerId, blackPlayerId, fen,
  moves, status, createdAt, updatedAt
}
```

---

## 🔗 Important URLs

| Purpose         | URL                                    |
| --------------- | -------------------------------------- |
| Django Admin    | http://localhost:8000/admin/           |
| API Root        | http://localhost:8000/api/             |
| Auth Endpoints  | http://localhost:8000/api/auth/        |
| Rooms Endpoints | http://localhost:8000/api/rooms/       |
| Chess Endpoints | http://localhost:8000/api/chess/       |
| WebSocket       | ws://localhost:8000/ws/room/{room_id}/ |

---

## ✨ Next Steps

1. **Run Django Backend** - Ensure it's running on `0.0.0.0:8000`
2. **Run Flutter App** - `flutter run`
3. **Test Login** - Register → Login → View Profile
4. **Test Room Creation** - Create room → Join room → Check WebSocket
5. **Test Chess Game** - Make moves → See real-time updates

---

**Questions?** Check your Django backend logs:

```bash
tail -f logs/debug.log  # if logging is configured
# or check Django console output
```

Happy Chess! 🎯♟️
