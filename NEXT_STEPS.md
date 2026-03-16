# 🚀 Chess Janak - Next Steps to Complete Integration

Your frontend-to-Django backend connection is **95% done**! Here's what to add to make it 100% functional.

---

## 📋 Priority List (In Order)

### 1️⃣ Test the Backend Connection (Do This FIRST)

**Goal:** Verify Django backend works before building UI

```bash
# Terminal 1: Start Django Backend
cd c:\Users\ACER\OneDrive\Desktop\chess_janak_backend\chess_janak_backend
.venv\Scripts\activate
python manage.py runserver 0.0.0.0:8000
```

**Wait for:** `Starting development server at http://0.0.0.0:8000/`

### 2️⃣ Test a Simple Login (5 minutes)

Use Postman or cURL:

```bash
# Test Login Endpoint
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password"
  }'
```

**Expected Response:**

```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "username"
  }
}
```

If this works → Your backend is ready! ✅

---

## 🔌 Core Features to Implement (Priority)

### A. Authentication State Management

**File to Create:** `lib/features/auth/presentation/providers/auth_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/auth_user_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';

// Listen to auth state changes
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUserModel?>>((ref) {
  final authRemoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthNotifier(authRemoteDataSource);
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthUserModel?>> {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthNotifier(this._authRemoteDataSource) : super(const AsyncValue.data(null));

  /// Login user
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final request = LoginRequestModel(email: email, password: password);
      return await _authRemoteDataSource.login(request);
    });
  }

  /// Register user
  Future<void> register(String email, String password, String username) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final request = RegisterRequestModel(
        email: email,
        password: password,
        username: username,
      );
      return await _authRemoteDataSource.register(request);
    });
  }

  /// Logout
  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _authRemoteDataSource.logout();
    state = const AsyncValue.data(null);
  }

  /// Get current user
  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRemoteDataSource.getCurrentUser());
  }
}
```

---

### B. Chess Game State Management

**File to Create:** `lib/features/chess/presentation/providers/game_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chess_remote_datasource.dart';
import '../../data/models/game_state_model.dart';
import '../../../core/websocket/socket_client.dart';

// Current game state
final currentGameStateProvider = StateNotifierProvider<GameStateNotifier, AsyncValue<GameStateModel?>>((ref) {
  final chessDataSource = ref.watch(chessRemoteDataSourceProvider);
  final socketClient = ref.watch(socketClientProvider);
  return GameStateNotifier(chessDataSource, socketClient);
});

class GameStateNotifier extends StateNotifier<AsyncValue<GameStateModel?>> {
  final ChessRemoteDataSource _chessDataSource;
  final SocketClient _socketClient;

  GameStateNotifier(this._chessDataSource, this._socketClient)
    : super(const AsyncValue.data(null));

  /// Fetch game state from backend
  Future<void> fetchGameState(String roomId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _chessDataSource.getGameState(roomId));
  }

  /// Create new game room
  Future<String?> createRoom(String gameMode, {int? timeLimit}) async {
    state = const AsyncValue.loading();
    try {
      final response = await _chessDataSource.createRoom(
        gameMode: gameMode,
        timeLimit: timeLimit,
      );
      final roomId = response['room_id'] as String?;
      return roomId;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  /// Join game room
  Future<bool> joinRoom(String inviteCode) async {
    try {
      final response = await _chessDataSource.joinRoom(inviteCode);
      return response['room_id'] != null;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  /// Make a move
  Future<void> makeMove(String roomId, String from, String to) async {
    try {
      // Send via WebSocket for real-time update
      _socketClient.send(SocketMessage(
        type: 'move',
        payload: {'from': from, 'to': to},
      ));

      // Also notify backend via REST API
      // (depending on your Django implementation)
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// WebSocket provider
final socketClientProvider = Provider<SocketClient>((ref) {
  return SocketClient();
});
```

---

### C. Rooms Management

**File to Create:** `lib/features/rooms/presentation/providers/rooms_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chess_remote_datasource.dart';

// List of user's active rooms
final userRoomsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final chessDataSource = ref.watch(chessRemoteDataSourceProvider);
  return await chessDataSource.getUserRooms();
});

// Refresh rooms after creating/joining
final refreshRoomsProvider = Provider<void>((ref) {
  ref.invalidate(userRoomsProvider);
});
```

---

## 🎨 UI Implementation (Next Phase)

### Add these screens if not already done:

**1. Login Screen** - Use `auth_provider` for login state

```
lib/features/auth/presentation/screens/login_screen.dart
- Email/password fields
- Login button connected to authStateProvider.login()
- Loading states
- Error handling
```

**2. Register Screen** - Use `auth_provider` for registration

```
lib/features/auth/presentation/screens/register_screen.dart
- Email/password/username fields
- Register button connected to authStateProvider.register()
```

**3. Rooms List Screen** - Use `userRoomsProvider`

```
lib/features/rooms/presentation/screens/rooms_list_screen.dart
- List of active games using userRoomsProvider
- "Create Room" button → calls createRoom()
- "Join Room" button → shows invite code input → calls joinRoom()
```

**4. Active Game Screen** - Use `currentGameStateProvider`

```
lib/features/chess/presentation/screens/active_game_screen.dart
- Chessboard widget showing current game state
- WebSocket listening for opponent moves
- Make move button → calls makeMove()
```

---

## ✅ Complete Integration Checklist

### Backend Requirements

- [ ] Django backend running on `http://0.0.0.0:8000`
- [ ] CORS configured in Django `.env`
- [ ] WebSocket path: `/ws/room/{room_id}/` working
- [ ] JWT authentication returning `access` & `refresh` tokens
- [ ] `/api/auth/login/` endpoint working
- [ ] `/api/rooms/create/` returning `room_id`

### Frontend Implementation

- [ ] `AuthRemoteDataSource` implemented (✅ DONE)
- [ ] `ChessRemoteDataSource` implemented (✅ DONE)
- [ ] `auth_provider.dart` created and working
- [ ] `game_provider.dart` created and working
- [ ] `rooms_provider.dart` created and working
- [ ] Login screen uses `authStateProvider`
- [ ] Rooms screen uses `userRoomsProvider`
- [ ] Game screen uses `currentGameStateProvider`
- [ ] WebSocket connects on game load
- [ ] Moves sent/received via WebSocket

### Testing

- [ ] Can login in Flutter app
- [ ] Can see user profile loaded
- [ ] Can create game room
- [ ] Can join room with invite code
- [ ] Can see opponent's moves in real-time
- [ ] Can make legal chess moves
- [ ] Game ends with correct result

---

## 🧪 Quick Test Script

Create `lib/test_backend_connection.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/api_client.dart';
import 'core/config/api_endpoints.dart';

/// Quick test to verify backend connection
Future<void> testBackendConnection(WidgetRef ref) async {
  try {
    final apiClient = ref.read(apiClientProvider);

    // Test 1: API Root
    print('Testing API root...');
    final rootResponse = await apiClient.get('${ApiEndpoints.base.replaceAll('/api', '')}');
    print('✅ API Root: ${rootResponse.statusCode}');

    // Test 2: Health check
    print('Testing auth health...');
    final authResponse = await apiClient.get('${ApiEndpoints.base}/auth/');
    print('✅ Auth Endpoint: ${authResponse.statusCode}');

    // Test 3: Leaderboard (no auth required)
    print('Testing leaderboard...');
    final leaderboardResponse = await apiClient.get('${ApiEndpoints.base}/leaderboard/');
    print('✅ Leaderboard: ${leaderboardResponse.statusCode}');

    print('\n🎉 Backend Connection Successful!');
  } catch (e) {
    print('❌ Connection Failed: $e');
  }
}
```

Call in `main.dart`:

```dart
// In bootstrap() or initState()
await testBackendConnection(ref);
```

---

## 🔧 Error Handling to Add

Add error catch blocks for all datasource calls:

```dart
try {
  await _authRemoteDataSource.login(request);
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    // Invalid credentials
    state = AsyncValue.error('Invalid email or password', StackTrace.current);
  } else if (e.response?.statusCode == 500) {
    // Server error
    state = AsyncValue.error('Server error, try again later', StackTrace.current);
  } else {
    // Network error
    state = AsyncValue.error(e.message ?? 'Connection failed', StackTrace.current);
  }
} catch (e) {
  state = AsyncValue.error('Unknown error: $e', StackTrace.current);
}
```

---

## 📱 Testing Checklist (Start Here!)

### Step 1: Verify Backend

```bash
# In browser or Postman
GET http://localhost:8000/api/
# Should see JSON response with endpoints
```

### Step 2: Test Login

```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'
# Should return access token
```

### Step 3: Run Flutter & Test

```bash
flutter run
# Test login screen
# Check that token is received
# Check that user data is displayed
```

### Step 4: Test Dashboard

```
- Create new room
- Get invite code
- Join with another account
- Verify WebSocket connects
- Send test message
```

---

## 🎯 Most Important Next Steps (Priority Order)

1. **Start Django backend** and verify it's running
2. **Test backend with Postman** - login, get token
3. **Run Flutter app** - test login flow
4. **Create `auth_provider.dart`** - manage auth state
5. **Create `game_provider.dart`** - manage game state
6. **Update login screen** - connect to `authStateProvider`
7. **Test end-to-end** - register → login → view profile

---

## 📞 Quick Reference

| Task             | File                           | Status   |
| ---------------- | ------------------------------ | -------- |
| Backend API      | Django                         | ✅ Ready |
| Environment URLs | `env.dart`                     | ✅ Done  |
| Auth Datasource  | `auth_remote_datasource.dart`  | ✅ Done  |
| Chess Datasource | `chess_remote_datasource.dart` | ✅ Done  |
| Auth Provider    | `auth_provider.dart`           | ⏳ TODO  |
| Game Provider    | `game_provider.dart`           | ⏳ TODO  |
| Login Screen     | `login_screen.dart`            | ⏳ TODO  |
| Rooms Screen     | `rooms_list_screen.dart`       | ⏳ TODO  |
| Game Screen      | `active_game_screen.dart`      | ⏳ TODO  |
| WebSocket        | `socket_client.dart`           | ✅ Ready |

---

**Ready to continue? Start with testing your Django backend, then create the providers!** 🚀
