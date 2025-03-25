import 'package:chat_application/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_application/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import other necessary files

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tncolzavvvgospszlrro.supabase.co',
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRuY29semF2dnZnb3Nwc3pscnJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIwMzc4MjksImV4cCI6MjA1NzYxMzgyOX0.0Z_DUnghT_q2NTVj61JPWCLnwcqNasqZGTbf0fsoFj4",
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Monochrome Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      routerConfig: router,
    );
  }
}
