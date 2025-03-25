import 'package:chat_application/model/user.model.dart';
import 'package:chat_application/api/user.api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final currentUserProvider = FutureProvider<UserModel>((ref) async {
  // Get the userService
  final userService = ref.read(userProvider);

  // Fetch the current user (you would need to implement this method in UserService)
  // This could use shared preferences, secure storage, or other methods to get the current user ID
  return await userService.getCurrentUser();
});
