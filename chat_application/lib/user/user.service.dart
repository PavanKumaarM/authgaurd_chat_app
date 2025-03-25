import 'package:chat_application/model/chat.model.dart';
import 'package:chat_application/model/user.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

class UserService {
  final supabase = Supabase.instance.client;
  final uuid = const Uuid();

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single()
        .withConverter((data) => UserModel.fromJson(data));
    return response;
  }

  // Create a new user
  Future<void> createUser({
    required String id,
    required String name,
    required String email,
  }) async {
    await supabase.from('users').insert({
      'id': id,
      'name': name,
      'email': email,
    });
  }

  // Delete a user
  Future<void> deleteUser({required String userId}) async {
    await supabase.from('users').delete().eq('id', userId);
  }

  // Update user
  Future<void> updateUser({
    required String name,
    required String userId,
  }) async {
    await supabase.from('users').update({
      'name': name,
    }).eq('id', userId);
  }

  // Get user by ID
  Future<UserModel> getUserById({required String userId}) async {
    final response = await supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single()
        .withConverter((data) => UserModel.fromJson(data));
    return response;
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    final response = await supabase
        .from('users')
        .select()
        .withConverter((data) => data.map((e) => UserModel.fromJson(e)).toList());
    return response;
  }

  // Send a message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final messageId = uuid.v4();
    await supabase.from('messages').insert({
      'id': messageId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Get messages between two users - Future version
  Future<List<ChatModel>> getMessagesBetweenUsers({
    required String userId1,
    required String userId2,
  }) async {
    final response = await supabase
        .from('messages')
        .select()
        .or('sender_id.eq.$userId1,receiver_id.eq.$userId2,sender_id.eq.$userId2,receiver_id.eq.$userId1')
        .order('timestamp', ascending: true)
        .withConverter(
            (data) => data.map((e) => ChatModel.fromJson(e)).toList());
    return response;
  }
  
  // Get messages between two users - Stream version
  Stream<List<ChatModel>> getMessagesBetweenUsersStream({
    required String userId1,
    required String userId2,
  }) {
    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .map((data) {
          return data
              .where((message) =>
                  (message['sender_id'] == userId1 && message['receiver_id'] == userId2) ||
                  (message['sender_id'] == userId2 && message['receiver_id'] == userId1))
              .map((e) => ChatModel.fromJson(e))
              .toList();
        });
  }

  // Get all messages for a user
  Future<List<ChatModel>> getAllMessagesForUser({
    required String userId,
  }) async {
    final response = await supabase
        .from('messages')
        .select()
        .or('sender_id.eq.$userId,receiver_id.eq.$userId')
        .order('timestamp', ascending: false)
        .withConverter(
            (data) => data.map((e) => ChatModel.fromJson(e)).toList());
    return response;
  }
}
