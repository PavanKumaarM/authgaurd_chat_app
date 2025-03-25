// // router.dart
// import 'dart:async'; // Add this import for StreamSubscription
// import 'package:chat_application/auth/auth_service.dart';
// import 'package:chat_application/auth_service.dart';
// import 'package:chat_application/pages/chat_screen.dart';
// import 'package:chat_application/pages/home.page.dart';
// import 'package:chat_application/pages/login_screen.dart';
// import 'package:chat_application/pages/signup_screen.dart';
// import 'package:chat_application/model/user.model.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'router.g.dart';

// @riverpod
// class Router extends _$Router {
//   @override
//   GoRouter build() {
//     final authService = ref.watch(authProvider);

//     // GoRouter configuration
//     final router = GoRouter(
//       initialLocation: '/login',
//       redirect: (context, state) {
//         // Check if the user is authenticated
//         final isLoggedIn = authService.isAuthenticated;
//         final isLoginRoute = state.uri.toString() == '/login';
//         final isSignupRoute = state.uri.toString() == '/signup';

//         // If not logged in and not on login/signup page, redirect to login
//         if (!isLoggedIn && !isLoginRoute && !isSignupRoute) {
//           return '/login';
//         }

//         // If logged in and on login/signup page, redirect to home
//         if (isLoggedIn && (isLoginRoute || isSignupRoute)) {
//           return '/';
//         }

//         // No redirect needed
//         return null;
//       },
//       refreshListenable: GoRouterRefreshStream(authService.authStateChanges),
//       routes: [
//         GoRoute(
//           path: '/',
//           builder: (context, state) => const HomePage(),
//         ),
//         GoRoute(
//           path: '/login',
//           builder: (context, state) => const LoginScreen(),
//         ),
//         GoRoute(
//           path: '/signup',
//           builder: (context, state) => const SignupScreen(),
//         ),
//         GoRoute(
//           path: '/chat',
//           builder: (context, state) {
//             final extra = state.extra as Map<String, dynamic>;
//             final currentUser = extra['currentUser'] as UserModel;
//             final recipient = extra['recipient'] as UserModel;

//             return ChatScreen(
//               currentUser: currentUser,
//               recipient: recipient,
//             );
//           },
//         ),
//       ],
//     );

//     return router;
//   }
// }
import 'dart:async';
import 'package:chat_application/auth/auth_gaurd.dart';
import 'package:chat_application/auth/auth_service.dart';
import 'package:chat_application/model/user.model.dart';
import 'package:chat_application/pages/chat_screen.dart';
import 'package:chat_application/pages/home.page.dart';
import 'package:chat_application/pages/login_screen.dart';
import 'package:chat_application/pages/signup_screen.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'router.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  bool build() => false; // Default: not authenticated

  void login() => state = true;
  //void logout() => state = false;
}

@riverpod
GoRouter router(RouterRef ref) {
  final authService = ref.watch(authProvider);

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authService.authStateChanges),
    initialLocation: '/login', // Start at login as a safer default
    routes: [
      // Auth routes - redirect to dashboard if already logged in
      GoRouterAuthExtension.authRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRouterAuthExtension.authRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Protected routes - require authentication
      GoRouterAuthExtension.protectedRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRouterAuthExtension.protectedRoute(
        path: '/chat',
        builder: (context, state) {
          if (state.extra == null) {
            // Handle the case when no data is passed
            return const Scaffold(
              body: Center(
                child: Text("Chat information is missing"),
              ),
            );
          }

          final extra = state.extra as Map<String, dynamic>;

          // Additional safety checks for the map contents
          if (!extra.containsKey('currentUser') ||
              !extra.containsKey('recipient')) {
            return const Scaffold(
              body: Center(
                child: Text("Incomplete chat information"),
              ),
            );
          }

          final currentUser = extra['currentUser'] as UserModel;
          final recipient = extra['recipient'] as UserModel;

          return ChatScreen(
            currentUser: currentUser,
            recipient: recipient,
          );
        },
      ),
    ],
  );
}

//Helper class to convert Stream to Listenable for GoRouter refreshListenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
