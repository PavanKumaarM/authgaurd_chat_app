// home.page.dart
import 'package:chat_application/pages/home_body.dart';
import 'package:chat_application/pages/home_header.dart';
import 'package:chat_application/theme.dart';
import 'package:chat_application/user/all_users.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MONOCHROME',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryBlack,
            // image: const DecorationImage(
            //   image: AssetImage('assets/subtle_pattern.png'),
            //   opacity: 0.05,
            //   repeat: ImageRepeat.repeat,
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SizedBox(height: 32),
                const HomeBody(),
                const SizedBox(height: 32),
                Divider(color: AppTheme.lightGrey.withOpacity(0.3)),
                const SizedBox(height: 24),
                Text(
                  'AVAILABLE CONTACTS',
                  style: TextStyle(
                    color: AppTheme.lightGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                const Expanded(child: AllUserss()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
