import 'package:news/core/constants/app_strings.dart';

abstract final class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailIsRequired;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.enterValidEmail;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordIsRequired;
    }

    if (value.length < 6) {
      return AppStrings.invalidPasswordLength;
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.nameIsRequired;
    }

    if (value.length < 2) {
      return AppStrings.invalidNameLength;
    }

    return null;
  }
}
