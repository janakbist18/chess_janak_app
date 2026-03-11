/// Helper utilities
class Helpers {
  /// Check if a value is null or empty
  static bool isEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.trim().isEmpty;
    if (value is List) return value.isEmpty;
    if (value is Map) return value.isEmpty;
    return false;
  }

  /// Check if a value is not null and not empty
  static bool isNotEmpty(dynamic value) {
    return !isEmpty(value);
  }

  /// Capitalize first letter of string
  static String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  /// Convert camelCase to title case
  static String camelCaseToTitleCase(String str) {
    final result = <String>[];
    for (int i = 0; i < str.length; i++) {
      if (i == 0) {
        result.add(str[i].toUpperCase());
      } else if (str[i] == str[i].toUpperCase()) {
        result.add(' ');
        result.add(str[i]);
      } else {
        result.add(str[i]);
      }
    }
    return result.join();
  }

  /// Truncate string with ellipsis
  static String truncate(String str, {int maxLength = 50}) {
    if (str.length <= maxLength) return str;
    return '${str.substring(0, maxLength)}...';
  }

  /// Check if string contains only numbers
  static bool isNumeric(String? str) {
    if (str == null || str.isEmpty) return false;
    return double.tryParse(str) != null;
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var index = 0;
    var size = bytes.toDouble();

    while (size > 1024 && index < suffixes.length - 1) {
      size /= 1024;
      index++;
    }

    return '${size.toStringAsFixed(2)} ${suffixes[index]}';
  }

  /// Generate random string
  static String randomString({int length = 32}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = <String>[];
    for (int i = 0; i < length; i++) {
      random.add(chars[DateTime.now().microsecond % chars.length]);
    }
    return random.join();
  }
}
