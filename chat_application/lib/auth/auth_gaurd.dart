import 'package:chat_application/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthGuard extends ConsumerWidget {
  /// Child widget to render if authentication condition is met
  final Widget child;

  /// Route to redirect to if not authenticated (for protected routes)
  final String unauthenticatedRedirectRoute;

  /// Route to redirect to if authenticated (for login/signup routes)
  final String authenticatedRedirectRoute;

  /// Whether this route should be protected (requires auth)
  /// If false, it means this is a login/signup route that should be inaccessible to authenticated users
  final bool isProtected;

  const AuthGuard({
    Key? key,
    required this.child,
    this.unauthenticatedRedirectRoute = '/login',
    this.authenticatedRedirectRoute = '/home',
    this.isProtected = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the authentication state stream
    final authStateChanges = ref.watch(authStateChangesProvider);

    return authStateChanges.when(
      data: (authState) {
        final isAuthenticated = authState.session != null;

        // For protected routes: redirect unauthenticated users
        if (isProtected && !isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(unauthenticatedRedirectRoute);
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // For auth routes: redirect authenticated users
        if (!isProtected && isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(authenticatedRedirectRoute);
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // Show the child if conditions are met
        return child;
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Authentication error: ${error.toString()}'),
        ),
      ),
    );
  }
}

extension GoRouterAuthExtension on GoRouter {
  /// Create a protected route (requires authentication)
  static GoRoute protectedRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<GoRoute> routes = const [],
    String unauthenticatedRedirectRoute = '/login',
  }) {
    return GoRoute(
      path: path,
      routes: routes,
      builder: (context, state) => AuthGuard(
        isProtected: true,
        unauthenticatedRedirectRoute: unauthenticatedRedirectRoute,
        child: builder(context, state),
      ),
    );
  }

  /// Create an auth route (login/signup) that redirects authenticated users
  static GoRoute authRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<GoRoute> routes = const [],
    String authenticatedRedirectRoute = '/home',
  }) {
    return GoRoute(
      path: path,
      routes: routes,
      builder: (context, state) => AuthGuard(
        isProtected: false,
        authenticatedRedirectRoute: authenticatedRedirectRoute,
        child: builder(context, state),
      ),
    );
  }
}
