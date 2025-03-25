import 'package:chat_application/api/message.api.dart';
import 'package:chat_application/model/chat.model.dart';
import 'package:chat_application/model/user.model.dart';
import 'package:chat_application/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chat_application/user/user.service.dart';


class ChatScreen extends ConsumerStatefulWidget {
  final UserModel currentUser;
  final UserModel recipient;

  const ChatScreen({
    Key? key,
    required this.currentUser,
    required this.recipient,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesBetweenUsersProvider(
      widget.currentUser.id,
      widget.recipient.id,
    ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home'); // Use GoRouter to navigate to home route
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.offWhite,
              child: Text(
                widget.recipient.name[0].toUpperCase(),
                style: TextStyle(
                  color: AppTheme.primaryBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.recipient.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: AppTheme.lightGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryBlack,
          // image: const DecorationImage(
          //   image: AssetImage('assets/subtle_pattern.png'),
          //   opacity: 0.05,
          //   repeat: ImageRepeat.repeat,
          // ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatModel>>(
                stream: ref.read(userServiceProvider).getMessagesBetweenUsersStream(
                  userId1: widget.currentUser.id,
                  userId2: widget.recipient.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.pureWhite,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppTheme.lightGrey,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading messages',
                              style: TextStyle(
                                color: AppTheme.pureWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.lightGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final messagesList = snapshot.data ?? [];

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      final message = messagesList[index];
                      final bool isMe = message.senderId == widget.currentUser.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          mainAxisAlignment:
                              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isMe) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppTheme.offWhite,
                                child: Text(
                                  widget.recipient.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: AppTheme.primaryBlack,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe ? AppTheme.offWhite : AppTheme.darkGrey,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  message.content,
                                  style: TextStyle(
                                    color:
                                        isMe ? AppTheme.primaryBlack : AppTheme.offWhite,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppTheme.pureWhite,
                                child: Text(
                                  widget.currentUser.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: AppTheme.primaryBlack,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.darkGrey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    color: AppTheme.pureWhite,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.mediumGrey,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: AppTheme.pureWhite),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: AppTheme.lightGrey),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.pureWhite,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: AppTheme.primaryBlack,
                      ),
                      onPressed: () async {
                        if (_messageController.text.trim().isNotEmpty) {
                          final messagesNotifier = ref.read(
                            messagesBetweenUsersProvider(
                              widget.currentUser.id,
                              widget.recipient.id,
                            ).notifier,
                          );
                          await messagesNotifier
                              .sendMessage(_messageController.text);
                          _messageController.clear();

                          // Scroll to bottom after message is sent and list is updated
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_scrollController.hasClients) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
