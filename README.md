# Chess Janak App

A modern, feature-rich Flutter chess application with real-time multiplayer gameplay, live chat, and video calling capabilities.

## Features

- **Authentication**: Email/password, Google Sign-In, OTP verification
- **User Profiles**: Customizable profiles with statistics and ratings
- **Chess Gameplay**:
  - Real-time multiplayer chess in dedicated game rooms
  - Support for different time controls
  - Move validation and game state management
  - Move history tracking
  - Comprehensive game analysis
- **Room Management**: Create private/public rooms, join rooms with invites
- **Chat System**: In-game chat with typing indicators
- **Video Calling**: Real-time video calls using WebRTC
- **Dashboard**: Match history, statistics, and friendly matches
- **Settings**: Customizable themes, sound effects, and notifications

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # App configuration
├── bootstrap.dart               # Initialization logic
├── firebase_options.dart        # Firebase configuration
├── core/                        # Shared core functionality
│   ├── config/                  # App configuration
│   ├── constants/               # App-wide constants
│   ├── theme/                   # Theme management
│   ├── network/                 # API client & networking
│   ├── websocket/               # WebSocket client
│   ├── storage/                 # Local storage services
│   ├── utils/                   # Utility functions
│   ├── widgets/                 # Reusable components
│   └── routing/                 # Navigation configuration
├── shared/                      # Shared models & providers
│   ├── models/                  # Generic data models
│   └── providers/               # Shared providers
└── features/                    # Feature modules (per feature)
    ├── splash/                  # Splash screen
    ├── auth/                    # Authentication
    ├── profile/                 # User profiles
    ├── dashboard/               # Main dashboard
    ├── rooms/                   # Room management
    ├── chess/                   # Game play
    ├── chat/                    # In-game chat
    ├── call/                    # Video calling
    └── settings/                # App settings
```

## Architecture

**Clean Architecture** with **Riverpod** state management:

- **Domain Layer**: Entities and business logic
- **Data Layer**: Models, repositories, and data sources
- **Presentation Layer**: Screens and widgets with state management

## Getting Started

### Prerequisites

- Flutter 3.0+
- Dart 3.0+
- Firebase Account

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/chess_janak_app.git
   cd chess_janak_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Copy `.env.example` to `.env`
   - Update API endpoints and Firebase credentials

4. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Update `firebase_options.dart` with your credentials
3. Enable required services:
   - Authentication (Email & Google)
   - Realtime Database
   - Storage
   - Cloud Messaging

### API Endpoints

Update `lib/core/config/api_endpoints.dart` with your backend API URLs.

## Dependencies

**Key Packages:**

- `flutter_riverpod` - State management
- `go_router` - Navigation
- `dio` - HTTP client
- `firebase_core` - Firebase integration
- `flutter_webrtc` - Video calling
- `web_socket_channel` - Real-time communication

See `pubspec.yaml` for complete dependency list.

## Code Standards

- **Naming**: camelCase for variables/methods, PascalCase for classes
- **File Organization**: Organized by feature with clean architecture patterns
- **Comments**: Meaningful comments for complex logic
- **Error Handling**: Comprehensive error handling with custom exceptions
- **Testing**: Unit and widget tests in `test/` directory

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Support

For issues and questions, please open an issue on GitHub.

## Roadmap

- [ ] Chess puzzle modes
- [ ] Tournament system
- [ ] Live streaming of games
- [ ] Advanced statistics and analytics
- [ ] Mobile app optimization
- [ ] Offline mode support
