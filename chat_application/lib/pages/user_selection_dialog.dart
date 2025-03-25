import 'package:chat_application/theme.dart';
import 'package:chat_application/api/user.api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_application/model/user.model.dart';

import 'package:go_router/go_router.dart';

class UserSelectionDialog extends ConsumerWidget {
  final UserModel recipient;

  const UserSelectionDialog({Key? key, required this.recipient})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(allUsersProvider);

    return Dialog(
      backgroundColor: AppTheme.darkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SELECT A USER',
              style: TextStyle(
                color: AppTheme.pureWhite,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose who you want to chat as',
              style: TextStyle(
                color: AppTheme.lightGrey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 2,
              width: 40,
              color: AppTheme.pureWhite,
            ),
            const SizedBox(height: 24),
            allUsers.when(
              data: (users) {
                // Filter out the recipient from the list of selectable users
                final filteredUsers =
                    users.where((user) => user.id != recipient.id).toList();

                if (filteredUsers.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_off,
                          color: AppTheme.lightGrey,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No other users available',
                          style: TextStyle(
                            color: AppTheme.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlack.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.mediumGrey.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredUsers.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppTheme.mediumGrey.withOpacity(0.2),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.pureWhite,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.primaryBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: TextStyle(
                            color: AppTheme.pureWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          user.email,
                          style: TextStyle(
                            color: AppTheme.lightGrey,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          // Close the dialog and return the selected user
                          context.pop(user);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.pureWhite,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading users...',
                      style: TextStyle(
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppTheme.lightGrey,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $error',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.lightGrey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
