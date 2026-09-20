import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/theme/app_theme.dart';
import 'package:news/providers/authentication_provider.dart';
import 'package:news/ui/screens/authentication_screen.dart';
import 'package:news/ui/screens/home_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'news',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ref.watch(authenticationProvider).value == null
          ? const AuthenticationScreen()
          : const HomeScreen(),
    );
  }
}
