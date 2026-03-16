import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Route guards for checking access permissions
class RouteGuards {
  /// Check if user is authenticated
  static Future<bool> isAuthenticated(Ref ref) async {
    return ref.read(isAuthenticatedProvider);
  }

  /// Check if user is premium
  static Future<bool> isPremium(Ref ref) async {
    // TODO: Implement premium check
    return false;
  }
}
