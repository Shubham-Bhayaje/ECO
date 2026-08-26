import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/welcome_screen.dart';
import '../pages/phone_auth_screen.dart';
import '../pages/otp_screen.dart';
import '../pages/sign_up.dart';
import '../pages/selfie_verification_screen.dart';
import '../pages/permission_screen.dart';
import '../pages/home/bottom_nav_shell.dart';
import '../pages/home/home_screen.dart';
import '../pages/driver/my_rides_screen.dart';
import '../pages/profile/profile_screen.dart';
import '../pages/driver/post_ride_screen.dart';
import '../pages/driver/add_vehicle_screen.dart';
import '../pages/driver/vehicle_verification_screen.dart';
import '../pages/driver/ride_requests_screen.dart';
import '../pages/rider/search_rides_screen.dart';
import '../pages/rider/ride_results_screen.dart';
import '../pages/rider/ride_detail_screen.dart';
import '../pages/chat/conversations_list_screen.dart';
import '../pages/chat/chat_screen.dart';
import '../pages/calling/masked_call_screen.dart';
import '../pages/subscription/subscription_screen.dart';
import '../pages/rating/rating_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorRides = GlobalKey<NavigatorState>(debugLabel: 'shellRides');
final _shellNavigatorChat = GlobalKey<NavigatorState>(debugLabel: 'shellChat');
final _shellNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

class AppRoutes {
  static const String welcome = '/';
  static const String phoneAuth = '/phone-auth';
  static const String otp = '/otp';
  static const String signUp = '/sign-up';
  static const String selfieVerification = '/selfie-verification';
  static const String permissions = '/permissions';
  static const String home = '/home';
  static const String myRides = '/my-rides';
  static const String chat = '/chat';
  static const String chatScreen = '/chat-screen';
  static const String maskedCall = '/masked-call';
  static const String profile = '/profile';
  static const String postRide = '/post-ride';
  static const String addVehicle = '/add-vehicle';
  static const String verifyVehicle = '/verify-vehicle';
  static const String rideRequests = '/ride-requests';
  static const String searchRides = '/search-rides';
  static const String rideResults = '/ride-results';
  static const String rideDetail = '/ride-detail';
  static const String subscription = '/subscription';
  static const String rateRide = '/rate-ride';

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: welcome,
    routes: [
      // Onboarding Routes
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: phoneAuth,
        name: 'phoneAuth',
        builder: (context, state) => const PhoneAuthScreen(),
      ),
      GoRoute(
        path: otp,
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OtpScreen(
            phoneNumber: extra['phoneNumber'] as String? ?? '',
            verificationId: extra['verificationId'] as String? ?? '',
            isRegistration: extra['isRegistration'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path: signUp,
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: selfieVerification,
        name: 'selfieVerification',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return SelfieVerificationScreen(
            firstName: extra['firstName'] as String?,
            phoneNumber: extra['phoneNumber'] as String?,
          );
        },
      ),
      GoRoute(
        path: permissions,
        name: 'permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),

      // Main App Shell with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: [
              GoRoute(
                path: home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Tab 1: My Rides
          StatefulShellBranch(
            navigatorKey: _shellNavigatorRides,
            routes: [
              GoRoute(
                path: myRides,
                name: 'myRides',
                builder: (context, state) => const MyRidesScreen(),
              ),
            ],
          ),
          // Tab 2: Messages / Conversations List
          StatefulShellBranch(
            navigatorKey: _shellNavigatorChat,
            routes: [
              GoRoute(
                path: chat,
                name: 'chat',
                builder: (context, state) => const ConversationsListScreen(),
              ),
            ],
          ),
          // Tab 3: Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: [
              GoRoute(
                path: profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Standalone Chat & Calling screens
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: chatScreen,
        name: 'chatScreen',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: maskedCall,
        name: 'maskedCall',
        builder: (context, state) => const MaskedCallScreen(),
      ),

      // Subscription & Rating screens
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: subscription,
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: rateRide,
        name: 'rateRide',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return RatingScreen(
            revieweeName: extra['revieweeName'] as String? ?? 'Rahul Verma',
          );
        },
      ),

      // Driver standalone screens
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: postRide,
        name: 'postRide',
        builder: (context, state) => const PostRideScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: addVehicle,
        name: 'addVehicle',
        builder: (context, state) => const AddVehicleScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: verifyVehicle,
        name: 'verifyVehicle',
        builder: (context, state) => const VehicleVerificationScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: rideRequests,
        name: 'rideRequests',
        builder: (context, state) => const RideRequestsScreen(),
      ),

      // Rider standalone screens
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: searchRides,
        name: 'searchRides',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return SearchRidesScreen(
            initialOrigin: extra['origin'] as String?,
            initialDestination: extra['destination'] as String?,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: rideResults,
        name: 'rideResults',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return RideResultsScreen(
            initialWomenOnly: extra['womenOnly'] as bool? ?? false,
            origin: extra['origin'] as String?,
            destination: extra['destination'] as String?,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: rideDetail,
        name: 'rideDetail',
        builder: (context, state) => const RideDetailScreen(),
      ),
    ],
  );
}
