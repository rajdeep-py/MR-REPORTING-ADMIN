import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRouter {
  static const splash = '/';
  static const login = '/login';
  static const profile = '/profile';

  // App Routes
  static const dashboard = '/dashboard';
  static const employeeManagement = '/employee-management';
  static const attendance = '/attendance';
  static const routine = '/routine';
  static const expense = '/expense';
  static const gifts = '/gifts';
  static const dcr = '/dcr';
  static const chemistReporting = '/chemist-reporting';
  static const doctorConnections = '/doctor-connections';
  static const chemistConnections = '/chemist-connections';
  static const stockistConnections = '/stockist-connections';
  static const teamManagement = '/team-management';
  static const visualAds = '/visual-ads';
  static const announcements = '/announcements';
  static const aboutUs = '/about-us';
  static const helpCenter = '/help-center';
  static const notifications = '/notifications';
  static const terms = '/terms';
  static const privacy = '/privacy';
  static const feedback = '/feedback';
  static const monthlyTarget = '/monthly-target';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
