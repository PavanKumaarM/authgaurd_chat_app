import 'package:chat_application/theme.dart';
import 'package:chat_application/api/user.api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import the new dialog and theme
import 'user_selection_dialog.dart';

class AllUserss extends ConsumerWidget {
  const AllUserss({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(allUsersProvider);

    if (allUsers.isLoading) {
      return Expanded(
        child: Center(
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
      );
    }

    if (allUsers.hasError) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppTheme.lightGrey,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading users',
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                allUsers.error.toString(),
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

    if (allUsers.value!.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 48,
                color: AppTheme.lightGrey,
              ),
              const SizedBox(height: 16),
              Text(
                'No users found',
                style: TextStyle(
                  color: AppTheme.lightGrey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a profile above to get started',
                style: TextStyle(
                  color: AppTheme.lightGrey.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: allUsers.value!.length,
        itemBuilder: (context, index) {
          final user = allUsers.value![index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.darkGrey,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.primaryBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                user.email,
                style: TextStyle(
                  color: AppTheme.lightGrey,
                  fontSize: 14,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Show the user selection dialog
                      final selectedUser = await showDialog(
                        context: context,
                        builder: (context) =>
                            UserSelectionDialog(recipient: user),
                      );

                      // If a user was selected, navigate to the chat screen
                      if (selectedUser != null) {
                        context.go(
                          '/chat',
                          extra: {
                            'currentUser': selectedUser,
                            'recipient': user,
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.pureWhite,
                      foregroundColor: AppTheme.primaryBlack,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'CHAT',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      final userService = ref.read(userProvider);
                      await userService.deleteUser(userId: user.id);
                      ref.invalidate(allUsersProvider);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
