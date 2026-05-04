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
import '../screens/announcement/announcement_screen.dart';
import '../screens/visual_ads/visual_ads_screen.dart';
import '../screens/doctor/doctors_screen.dart';
import '../screens/doctor/doctor_detail_screen.dart';
import '../screens/chemist_shop/chemist_shops_screen.dart';
import '../screens/chemist_shop/chemist_shop_detail_screen.dart';
import '../screens/stockist/stockists_screen.dart';
import '../screens/stockist/stockist_detail_screen.dart';
import '../screens/dcr/dcr_screen.dart';
import '../screens/dcr/dcr_details_screen.dart';
import '../screens/chemist_shop_reporting/chemist_shop_reporting_screen.dart';
import '../screens/chemist_shop_reporting/chemist_shop_reporting_details_screen.dart';
import '../screens/order/orders_screen.dart';
import '../screens/order/order_details_screen.dart';
import '../screens/gift/gift_screen.dart';
import '../screens/gift/gift_inventory_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/monthly_target/monthly_target_screen.dart';

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
  static const doctorDetail = '/doctor-detail';
  static const chemistDetail = '/chemist-detail';
  static const stockistDetail = '/stockist-detail';
  static const dcrDetail = '/dcr-detail';
  static const chemistShopReportingDetail = '/chemist-shop-reporting-detail';
  static const orders = '/orders';
  static const orderDetail = '/order-detail';
  static const giftInventory = '/gift-inventory';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
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
      GoRoute(
        path: announcements,
        builder: (context, state) => const AnnouncementScreen(),
      ),
      GoRoute(
        path: visualAds,
        builder: (context, state) => const VisualAdsScreen(),
      ),
      GoRoute(
        path: doctorConnections,
        builder: (context, state) => const DoctorsScreen(),
      ),
      GoRoute(
        path: '$doctorDetail/:id',
        builder: (context, state) => DoctorDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: chemistConnections,
        builder: (context, state) => const ChemistShopsScreen(),
      ),
      GoRoute(
        path: '$chemistDetail/:id',
        builder: (context, state) => ChemistShopDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: stockistConnections,
        builder: (context, state) => const StockistsScreen(),
      ),
      GoRoute(
        path: '$stockistDetail/:id',
        builder: (context, state) => StockistDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: dcr,
        builder: (context, state) => const DcrScreen(),
      ),
      GoRoute(
        path: '$dcrDetail/:id',
        builder: (context, state) => DcrDetailsScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: chemistReporting,
        builder: (context, state) => const ChemistShopReportingScreen(),
      ),
      GoRoute(
        path: '$chemistShopReportingDetail/:id',
        builder: (context, state) => ChemistShopReportingDetailsScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: orders,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '$orderDetail/:id',
        builder: (context, state) => OrderDetailsScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: gifts,
        builder: (context, state) => const GiftScreen(),
      ),
      GoRoute(
        path: giftInventory,
        builder: (context, state) => const GiftInventoryScreen(),
      ),
      GoRoute(
        path: monthlyTarget,
        builder: (context, state) => const MonthlyTargetScreen(),
      ),
    ],
  );
}
