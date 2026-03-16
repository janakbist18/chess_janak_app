# ⚡ Quick Integration Guide - Step by Step

Your Flutter app is now ready for integration! This guide will get you up and running in 5 minutes.

---

## 🔥 Start Here (3 Steps)

### Step 1: Start Django Backend (2 minutes)

```bash
# Open terminal in your Django backend folder
cd c:\Users\ACER\OneDrive\Desktop\chess_janak_backend\chess_janak_backend

# Activate virtual environment
.venv\Scripts\activate

# Start the server
python manage.py runserver 0.0.0.0:8000
```

**Expected output:**

```
Starting development server at http://0.0.0.0:8000/
```

**Leave this terminal running!**

### Step 2: Run Flutter App (2 minutes)

```bash
# Open new terminal in your Flutter app folder
cd c:\Users\ACER\OneDrive\Desktop\chess_janak_app\chess_janak_app

# Run the app
flutter run
```

### Step 3: Test Backend Connection

1. In Flutter app, open: **lib/core/testing/backend_connection_test.dart**
2. Add to your main app:

   ```dart
   import 'package:chess_janak_app/core/testing/backend_connection_test.dart';

   // In main.dart, temporarily use this screen:
   @override
   Widget build(BuildContext context) {
     return BackendConnectionTest();
   }
   ```

3. Run app and watch the tests ✅

---

## 🎯 Files You Just Got

### 1. **auth_provider.dart** - Authentication State

```
lib/features/auth/presentation/providers/auth_provider.dart
```

- `authStateProvider` - Current user state
- Methods: `login()`, `register()`, `logout()`, `getCurrentUser()`
- Automatically saves/loads JWT tokens

**Usage in UI:**

```dart
// In any screen with ConsumerWidget/ConsumerStatefulWidget
Consumer(
  builder: (context, ref, child) {
    final auth = ref.watch(authStateProvider);

    return auth.when(
      data: (user) {
        if (user == null) {
          return LoginScreen();
        }
        return HomeScreen(user: user);
      },
      loading: () => LoadingScreen(),
      error: (err, __) => ErrorScreen(error: err.toString()),
    );
  },
);
```

### 2. **game_provider.dart** - Chess Game State

```
lib/features/chess/presentation/providers/game_provider.dart
```

- `currentGameStateProvider` - Current game state
- Methods: `fetchGameState()`, `createRoom()`, `joinRoom()`, `makeMove()`
- Auto-connects WebSocket when game loads
- Listens for opponent moves

**Usage in UI:**

```dart
// Create room
final gameNotifier = ref.read(currentGameStateProvider.notifier);
final roomId = await gameNotifier.createRoom(
  gameMode: 'blitz',
  timeLimit: 300,
);

// In game screen - make a move
await gameNotifier.makeMove(
  from: 'e2',
  to: 'e4',
);
```

### 3. **rooms_provider.dart** - Rooms Management

```
lib/features/rooms/presentation/providers/rooms_provider.dart
```

- `userRoomsProvider` - List of user's games
- `createRoomProvider` - Create new room
- `joinRoomProvider` - Join with invite code
- Helper providers for room data

**Usage in UI:**

```dart
// Get user's rooms
final rooms = ref.watch(userRoomsProvider);

rooms.when(
  data: (roomsList) {
    return ListView.builder(
      itemCount: roomsList.length,
      itemBuilder: (context, index) {
        final room = roomsList[index];
        return ListTile(
          title: Text(room['status']),
        );
      },
    );
  },
  loading: () => CircularProgressIndicator(),
  error: (err, __) => Text('Error: $err'),
);
```

### 4. **backend_connection_test.dart** - Connection Validator

```
lib/core/testing/backend_connection_test.dart
```

Tests:

- ✅ API Root accessibility
- ✅ Health check endpoint
- ✅ Auth endpoints
- ✅ WebSocket connectivity

**Display in your app:**

```dart
import 'package:chess_janak_app/core/testing/backend_connection_test.dart';

// In main.dart
void main() {
  // During development, show connection test first
  runApp(MyApp(home: BackendConnectionTest()));
}
```

---

## 📝 Complete Example: Login Screen

Create `lib/features/auth/presentation/screens/login_screen_example.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreenExample extends ConsumerStatefulWidget {
  const LoginScreenExample({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreenExample> createState() => _LoginScreenExampleState();
}

class _LoginScreenExampleState extends ConsumerState<LoginScreenExample> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'user@example.com',
              ),
            ),
            SizedBox(height: 16),

            // Password field
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '••••••••',
              ),
            ),
            SizedBox(height: 32),

            // Login button or loading indicator
            authState.when(
              data: (user) {
                if (user != null) {
                  // Already logged in, show success
                  return Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 48),
                        SizedBox(height: 16),
                        Text('Welcome ${user.username}!'),
                      ],
                    ),
                  );
                }

                // Show login button
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref.read(authStateProvider.notifier).login(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: Text('Login'),
                  ),
                );
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) => Text(
                'Login failed: $error',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
```

---

## 🧪 Testing Checklist

Do these in order:

- [ ] **Backend Running**: Django server started at `http://localhost:8000`
- [ ] **API Test**: Can access `http://localhost:8000/api/` in browser
- [ ] **Connection Test**: Run `BackendConnectionTest` screen, all tests pass
- [ ] **Login Test**: Can login with test user in Flutter app
- [ ] **Profile Test**: User data displays correctly after login
- [ ] **Rooms Test**: Can create a new game room
- [ ] **Join Test**: Can join room with invite code
- [ ] **Game Test**: Can see opponent in room details
- [ ] **WebSocket Test**: Can connect to WebSocket without errors
- [ ] **Move Test**: Can make chess move and see it update

---

## 🚨 Common Issues & Fixes

### Issue: "Connection refused" error

**Cause:** Django backend not running
**Fix:**

```bash
# Make sure you have Django running:
python manage.py runserver 0.0.0.0:8000
```

### Issue: CORS error in console

**Cause:** Django CORS settings don't allow Flutter domain
**Fix:** Update Django `.env`:

```env
CORS_ALLOWED_ORIGINS=http://10.0.2.2:8000,http://localhost:8000
```

### Issue: Login fails with 401 error

**Cause:** Wrong credentials or server returned invalid response
**Fix:**

1. Test endpoint in Postman directly
2. Check Django user exists in admin panel
3. Verify response format has `access` and `refresh` fields

### Issue: WebSocket won't connect

**Cause:** Django Channels not running or wrong path
**Fix:**

1. Ensure WebSocket path is `/ws/room/{id}/` (not `/api/ws/...`)
2. Check Django Channels is installed
3. Test with a WebSocket client tool

---

## 🎓 How It Works (Architecture)

```
┌─────────────────────────────────────────────────────────┐
│  Flutter App                                             │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  UI Screens (LoginScreen, GameScreen, etc)              │
│        ↓                                                │
│  Providers (authStateProvider, gameStateProvider)       │
│        ↓                                                │
│  Datasources (AuthRemoteDataSource, ChessRemoteData)   │
│        ↓                                                │
│  HTTP/WebSocket                                        │
│                                                          │
└─────────────────────────────────────────────────────────┘
              ↓↓↓ Network ↓↓↓
┌─────────────────────────────────────────────────────────┐
│  Django Backend                                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  REST API (login, register, create room, etc)          │
│  WebSocket Consumer (real-time moves)                   │
│  Database (users, rooms, moves)                         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Data Flow Example:**

```
User taps "Login"
    ↓
LoginScreen calls authStateProvider.login()
    ↓
auth_provider.dart calls authRemoteDataSource.login()
    ↓
authRemoteDataSource posts to /api/auth/login/
    ↓
Django validates & returns JWT tokens
    ↓
Tokens auto-saved to secure storage
    ↓
UI updates to show logged-in home screen
```

---

## 📚 Next Features to Add

Once basic login/rooms work:

1. **Chat in Room** - Send messages before game starts
2. **Timer Display** - Show game time countdown
3. **Move Validation** - Highlight legal moves
4. **Game End Screen** - Show winner/loser
5. **Leaderboard** - Display top players
6. **Player Profile** - View stats and history
7. **Replay** - Analyze past games

---

## 🎯 One More Thing

To make development faster, you **don't need a release build** yet:

```bash
# Debug mode (fastest)
flutter run -d "your device name"

# Always use this while developing!
```

---

**You're all set! Start with Step 1 and follow the checklist. 🚀**

Questions? Check:

- `DJANGO_INTEGRATION.md` for API details
- `NEXT_STEPS.md` for implementation roadmap
- `SETUP_CHECKLIST.md` for setup verification
