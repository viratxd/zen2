import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/web_view_session_screen/web_view_session_screen.dart';
import '../presentation/add_session_screen/add_session_screen.dart';
import '../presentation/session_settings_screen/session_settings_screen.dart';
import '../presentation/session_dashboard/session_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String webViewSessionScreen = '/web-view-session-screen';
  static const String addSessionScreen = '/add-session-screen';
  static const String sessionSettingsScreen = '/session-settings-screen';
  static const String sessionDashboard = '/session-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    webViewSessionScreen: (context) => const WebViewSessionScreen(),
    addSessionScreen: (context) => const AddSessionScreen(),
    sessionSettingsScreen: (context) => const SessionSettingsScreen(),
    sessionDashboard: (context) => const SessionDashboard(),
    // TODO: Add your other routes here
  };
}
