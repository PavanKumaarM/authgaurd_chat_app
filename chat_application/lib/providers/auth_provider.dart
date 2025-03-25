import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final _supabase = Supabase.instance.client;
  @override
  Stream<AuthState?> build() {
    return _supabase.auth.onAuthStateChange.map((event) => event);
  }
}
