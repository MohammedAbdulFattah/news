import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news/core/constants/app_icons.dart';
import 'package:news/core/constants/app_paddings.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/core/extensions/context_extension.dart';
import 'package:news/providers/authentication_provider.dart';
import 'package:news/ui/screens/home_screen.dart';
import 'package:news/ui/widgets/app_snake_bar.dart';
import 'package:news/ui/widgets/authentication_widgets/login_form.dart';
import 'package:news/ui/widgets/authentication_widgets/sign_up_form.dart';
import 'package:news/ui/widgets/centered_widget.dart';
import 'package:news/ui/widgets/pill_tap_bar.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = .new(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref
            .read(authenticationTabIndexProvider.notifier)
            .set(_tabController.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int tabIndex = ref.watch(authenticationTabIndexProvider);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: context.isLargeScreen
                      ? AppPaddings.largePagePadding
                      : AppPaddings.smallPagePadding,
                  child: Column(
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        AppStrings.appTitle,
                        style: context.textTheme.headlineLarge,
                      ),
                      Text(
                        AppStrings.appDescription,
                        style: context.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      PillTabBar(
                        controller: _tabController,
                        tabs: [AppStrings.login, AppStrings.signUp],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _onSignInWithGoogle,
                              label: Text(AppStrings.continueWithGoogle),
                              icon: SvgPicture.asset(
                                AppIcons.google,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      CenteredDivider(
                        child: Text(
                          AppStrings.orContinueWithEmail,
                          style: TextStyle(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (tabIndex == 0) LoginForm() else SignUpForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSignInWithGoogle() async {
    await ref.read(authenticationProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    final state = ref.read(authenticationProvider);
    if (state.hasError) {
      AppSnakeBar.show(
        context: context,
        message: state.error.toString(),
        isError: true,
      );
      return;
    }
    AppSnakeBar.show(
      context: context,
      message: AppStrings.youSignUpSuccessfully,
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomeScreen()),
      (route) => false,
    );
  }
}
