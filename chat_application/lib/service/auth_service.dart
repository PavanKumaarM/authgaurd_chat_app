import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:chat_application/model/user.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  final Ref ref;

  AuthService(this.ref);

  // Get the currently authenticated user
  User? get currentAuthUser => supabase.auth.currentUser;

  // Check if user is logged in
  bool get isAuthenticated => currentAuthUser != null;

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  // Get session status stream
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  when(
      {required Widget Function(dynamic state) data,
      required Center Function() loading,
      required Center Function(dynamic error, dynamic stackTrace) error}) {}
}

@riverpod
AuthService auth(ref) {
  return AuthService(ref);
}

@riverpod
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authProvider);
  return authService.authStateChanges;
}

// Provider to check if a user is authenticated
@riverpod
bool isAuthenticated(ref) {
  final authService = ref.watch(authProvider);
  return authService.isAuthenticated;
}
