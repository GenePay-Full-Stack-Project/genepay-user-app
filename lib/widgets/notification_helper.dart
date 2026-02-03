import 'dart:developer' as developer;
import 'package:flutter/material.dart';

/// Centralized notification helper to show consistent
/// success / error / info messages across the app.
///
/// Behavior changes requested:
/// - SnackBar appears near the top of the screen (floating)
/// - Slightly smaller visual footprint and text
/// - Errors are logged (so backend-provided errors are recorded)
class NotificationHelper {
  static void _log(String level, String message, {Object? error}) {
    // use developer.log so messages are visible in observatory/logs
    developer.log(
      message,
      name: 'NotificationHelper',
      level: level == 'error' ? 1000 : 800,
      error: error,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snack = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      duration: duration,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      // If no ScaffoldMessenger in context, log and print as fallback
      _log(
        'error',
        'No ScaffoldMessenger found in context to show notification: $message',
      );
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snack);
  }

  /// Show an error message and log it. Prefer passing backend error text
  /// directly so it is visible in logs. Keep the on-screen message
  /// concise for users.
  static String _extractErrorMessage(Object? error, String? fallback) {
    if (error == null) return fallback ?? 'Something went wrong';

    try {
      // If error is a Map (e.g., decoded JSON), prefer common keys
      if (error is Map) {
        final candidates = [
          error['message'],
          error['error'],
          error['detail'],
          error['msg'],
        ];
        for (var c in candidates) {
          if (c != null) return c.toString();
        }
        // don't append status to user-facing message; prefer concise message only
      }

      final s = error.toString();
      // Try to match patterns like: ApiException: Invalid NIC or password (Status: 401)
      final apiRegex = RegExp(
        r'ApiException:\s*(.*?)\s*\(Status:\s*(\d{3})\)',
        dotAll: true,
      );
      final m = apiRegex.firstMatch(s);
      if (m != null) {
        final message = m.group(1)?.trim() ?? s;
        return message;
      }

      // Try generic "SomeException: message" patterns
      final genericRegex = RegExp(r'^[^:]+:\s*(.*)');
      final mg = genericRegex.firstMatch(s);
      String result;
      if (mg != null) {
        result = mg.group(1)!.trim();
      } else {
        result = s;
      }

      // Return the concise message only (do not append status code to UI text)
      return result;
    } catch (_) {
      return fallback ?? 'Something went wrong';
    }
  }

  /// Show an error message and log it. If an [error] object is provided,
  /// the displayed text prefers the parsed API error (concise) rather than
  /// the developer-facing message.
  static void showError(
    BuildContext context, {
    String? message,
    Duration? duration,
    Object? error,
  }) {
    final display = _extractErrorMessage(error, message);
    _log('error', display, error: error);
    _show(
      context,
      message: display,
      backgroundColor: const Color(0xFFEF4444), // red-500
      icon: Icons.error_outline,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _log('info', message);
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFF10B981), // green-500
      icon: Icons.check_circle_outline,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _log('info', message);
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFF3B82F6), // blue-500
      icon: Icons.info_outline,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
