// home_header.dart
import 'package:chat_application/theme.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WELCOME TO',
          style: TextStyle(
            color: AppTheme.lightGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'MONOCHROME',
              style: TextStyle(
                color: AppTheme.pureWhite,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'CHAT',
              style: TextStyle(
                color: AppTheme.lightGrey,
                fontSize: 32,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
