import 'package:chat_application/model/chat.model.dart';
import 'package:chat_application/model/user.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService(ref));

class UserService {
  final supabase = Supabase.instance.client;
  final Ref ref;

  UserService(this.ref);

  Future<UserModel> getCurrentUser() async {
    // This is a simplified example - you would need to
    // fetch the current user ID from storage

    // For now, just return the first user
    final users = await getAllUsers();
    if (users.isEmpty) {
      throw Exception('No users found. Create a profile first.');
    }
    return users.first;
  }

  // Create a new user
  Future<bool> createUser({
    required String id,
    required String name,
    required String email,
  }) async {
    try {
      // Validate UUID format
      if (id == "anonymous" || id.isEmpty) {
        print("Invalid UUID format: $id");
        return false;
      }

      print("Attempting to create user with ID: $id");

      final UserModel user = UserModel(
        id: id,
        name: name,
        email: email,
      );

      // Print the JSON to verify what we're sending
      print('User JSON being sent: ${user.toJson()}');

      // Make direct raw insert attempt to see specific error
      await supabase.from('users').insert(user.toJson());

      print('User created successfully');
      return true;
    } catch (e) {
      print('Exception in createUser: $e');
      return false;
    }
  }

  // Delete a user
  Future<void> deleteUser({required String userId}) async {
    await supabase.from('users').delete().eq('id', userId);
  }

  // Update a user
  Future<void> updateUser({
    required String name,
    required String userId,
  }) async {
    await supabase.from('users').update({'name': name}).eq('id', userId);
  }

  // Read a user
  Future<UserModel> getUserById({required String userId}) async {
    final response = await supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single()
        .withConverter(UserModel.fromJson);
    return response;
  }

  // get all users
  Future<List<UserModel>> getAllUsers() async {
    final response = await supabase.from('users').select().withConverter(
        (data) => data.map((e) => UserModel.fromJson(e)).toList());
    return response;
  }

  // NEW MESSAGE METHODS

  // Send a message
  Future<bool> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    try {
      final uuid = Uuid();
      final message = {
        'id': uuid.v4(),
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await supabase.from('messages').insert(message);
      //ref.invalidateSelf();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Get messages between two users - Future version
  Future<List<ChatModel>> getMessagesBetweenUsers({
    required String userId1,
    required String userId2,
  }) async {
    final response = await supabase
        .from('messages')
        .select()
        .or(
            'and(sender_id.eq.$userId1,receiver_id.eq.$userId2),and(sender_id.eq.$userId2,receiver_id.eq.$userId1)')
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
    return supabase.from('messages').stream(primaryKey: ['id']).map((data) {
      return data
          .where((message) =>
              (message['sender_id'] == userId1 &&
                  message['receiver_id'] == userId2) ||
              (message['sender_id'] == userId2 &&
                  message['receiver_id'] == userId1))
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
