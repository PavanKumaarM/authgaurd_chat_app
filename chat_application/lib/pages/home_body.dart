// home_body.dart
import 'package:chat_application/theme.dart';
import 'package:chat_application/api/user.api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.darkGrey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CREATE PROFILE',
              style: TextStyle(
                color: AppTheme.pureWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: AppTheme.pureWhite),
              decoration: InputDecoration(
                labelText: 'NAME',
                labelStyle: TextStyle(
                  color: AppTheme.lightGrey,
                  fontSize: 12,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppTheme.lightGrey,
                ),
                fillColor: AppTheme.mediumGrey.withOpacity(0.3),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              style: TextStyle(color: AppTheme.pureWhite),
              decoration: InputDecoration(
                labelText: 'EMAIL',
                labelStyle: TextStyle(
                  color: AppTheme.lightGrey,
                  fontSize: 12,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppTheme.lightGrey,
                ),
                fillColor: AppTheme.mediumGrey.withOpacity(0.3),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.pureWhite,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            final userService = ref.read(userProvider);
                            final uuid = Uuid();
                            final generatedUuidString = uuid.v4();

                            final result = await userService.createUser(
                              id: generatedUuidString,
                              name: _nameController.text,
                              email: _emailController.text,
                            );

                            if (result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Profile created successfully',
                                    style: TextStyle(
                                      color: AppTheme.primaryBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: Colors
                                      .white, // Use a color with good contrast
                                  duration: const Duration(
                                      seconds: 3), // Increase duration
                                  behavior: SnackBarBehavior.floating,
                                  margin:
                                      const EdgeInsets.all(16), // Add margin
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: AppTheme.pureWhite,
                                        width: 1), // Add border
                                  ),
                                ),
                              );

                              _nameController.clear();
                              _emailController.clear();
                              ref.invalidate(allUsersProvider);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Failed to create profile',
                                  ),
                                  backgroundColor: Colors.red[800],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red[800],
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.pureWhite,
                        foregroundColor: AppTheme.primaryBlack,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'CREATE',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
