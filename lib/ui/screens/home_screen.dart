import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/providers/authentication_provider.dart';
import 'package:news/ui/screens/authentication_screen.dart';
import 'package:news/ui/widgets/app_snake_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _onLogout, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: Text(
          'welcome ${authProvider.value?.email} ${authProvider.value?.displayName}  ',
        ),
      ),
    );
  }

  void _onLogout() async {
    await ref.read(authenticationProvider.notifier).logout();
    if (!mounted) return;
    AppSnakeBar.show(context: context, message: AppStrings.youLoggedOut);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => AuthenticationScreen()),
      (route) => false,
    );
  }
}
