import 'package:chat_application/model/chat.model.dart';
import 'package:chat_application/api/user.api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message.api.g.dart';

@riverpod
class MessagesBetweenUsers extends _$MessagesBetweenUsers {
  @override
  Future<List<ChatModel>> build(String user1Id, String user2Id) async {
    final userService = ref.read(userProvider);
    return userService.getMessagesBetweenUsers(
      userId1: user1Id,
      userId2: user2Id,
    );
  }

  Future<void> sendMessage(String content) async {
    final userService = ref.read(userProvider);
    await userService.sendMessage(
      senderId: user1Id,
      receiverId: user2Id,
      content: content,
    );
    ref.invalidateSelf();
  }
}

@riverpod
class UserMessages extends _$UserMessages {
  @override
  Future<List<ChatModel>> build(String userId) async {
    final userService = ref.read(userProvider);
    return userService.getAllMessagesForUser(userId: userId);
  }
}
