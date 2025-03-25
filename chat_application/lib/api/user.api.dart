import 'package:chat_application/model/user.model.dart';
import 'package:chat_application/user/user.service.dart';
import 'package:chat_application/user/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.api.g.dart';

@riverpod
class User extends _$User {
  @override
  UserService build() {
    return UserService(ref);
  }
}

@riverpod
class SingleUser extends _$SingleUser {
  @override
  Future<UserModel> build(String userId) async {
    final userService = ref.read(userProvider);
    return userService.getUserById(userId: userId);
  }
}

@riverpod
class AllUsers extends _$AllUsers {
  @override
  Future<List<UserModel>> build() async {
    final userService = ref.read(userProvider);
    return userService.getAllUsers();
  }
}
