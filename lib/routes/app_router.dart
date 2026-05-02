import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/employee/employees_screen.dart';
import '../screens/employee/add_edit_employee_screen.dart';
import '../screens/employee/employee_detail_screen.dart';
import '../screens/team/teams_screen.dart';
import '../screens/team/team_details_screen.dart';
import '../screens/team/create_edit_team_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/routine/routine_screen.dart';
import '../screens/routine/routine_detail_screen.dart';
import '../screens/routine/create_routine_screen.dart';
import '../screens/expense/expense_screen.dart';
import '../screens/expense/expense_detail_screen.dart';
import '../screens/about_us/about_us_screen.dart';
import '../screens/help_center/help_center_screen.dart';
import '../screens/privacy_policy/privacy_policy_screen.dart';
import '../screens/terms_conditions/terms_conditions_screen.dart';
import '../screens/feedback/feedback_screen.dart';

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
  
  static const addEditEmployee = '/add-edit-employee';
  static const employeeDetail = '/employee-detail';
  
  static const createEditTeam = '/create-edit-team';
  static const teamDetails = '/team-details';
  
  static const createRoutine = '/create-routine';
  static const routineDetail = '/routine-detail';
  
  static const expenseDetail = '/expense-detail';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: employeeManagement,
        builder: (context, state) => const EmployeesScreen(),
      ),
      GoRoute(
        path: attendance,
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: addEditEmployee,
        builder: (context, state) => const AddEditEmployeeScreen(),
      ),
      GoRoute(
        path: '$addEditEmployee/:id',
        builder: (context, state) => AddEditEmployeeScreen(id: state.pathParameters['id']),
      ),
      GoRoute(
        path: '$employeeDetail/:id',
        builder: (context, state) => EmployeeDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: teamManagement,
        builder: (context, state) => const TeamsScreen(),
      ),
      GoRoute(
        path: createEditTeam,
        builder: (context, state) => const CreateEditTeamScreen(),
      ),
      GoRoute(
        path: '$createEditTeam/:id',
        builder: (context, state) => CreateEditTeamScreen(id: state.pathParameters['id']),
      ),
      GoRoute(
        path: '$teamDetails/:id',
        builder: (context, state) => TeamDetailsScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: routine,
        builder: (context, state) => const RoutineScreen(),
      ),
      GoRoute(
        path: '$routineDetail/:id',
        builder: (context, state) => RoutineDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '$createRoutine/:id',
        builder: (context, state) => CreateRoutineScreen(employeeId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: expense,
        builder: (context, state) => const ExpenseScreen(),
      ),
      GoRoute(
        path: '$expenseDetail/:id',
        builder: (context, state) => ExpenseDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: aboutUs,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: helpCenter,
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: privacy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: terms,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: feedback,
        builder: (context, state) => const FeedbackScreen(),
      ),
    ],
  );
}
