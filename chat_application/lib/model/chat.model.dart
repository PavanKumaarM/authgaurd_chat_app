import 'package:json_annotation/json_annotation.dart';

part 'chat.model.g.dart';

@JsonSerializable()
class ChatModel {
  final String id;

  @JsonKey(name: 'sender_id')
  final String senderId;

  @JsonKey(name: 'receiver_id')
  final String receiverId;

  final String content;
  final DateTime timestamp;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  // From Json and To Json method
  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
