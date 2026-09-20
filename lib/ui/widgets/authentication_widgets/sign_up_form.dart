import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/constants/app_strings.dart';
import 'package:news/core/helper/validations.dart';
import 'package:news/providers/authentication_provider.dart';
import 'package:news/ui/screens/home_screen.dart';
import 'package:news/ui/widgets/app_snake_bar.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = .new();
    _passwordController = .new();
    _nameController = .new();
    _formKey = .new();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authenticationProvider);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: .min,
        children: [
          TextFormField(
            controller: _nameController,
            validator: Validators.validateName,
            keyboardType: .name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppStrings.name),
              hint: Text(AppStrings.enterYourName),
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            validator: Validators.validateEmail,
            textInputAction: TextInputAction.next,
            keyboardType: .emailAddress,
            decoration: InputDecoration(
              label: Text(AppStrings.email),
              hint: Text(AppStrings.enterYourEmail),
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            validator: Validators.validatePassword,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _onSignUp(),
            decoration: InputDecoration(
              label: Text(AppStrings.password),
              hint: Text(AppStrings.enterYourPassword),
              prefixIcon: Icon(Icons.lock_outline),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 24),

          authProvider.isLoading
              ? CircularProgressIndicator()
              : Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _onSignUp,
                        child: Text(AppStrings.signUp),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void _onSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref
        .read(authenticationProvider.notifier)
        .signUp(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );

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
