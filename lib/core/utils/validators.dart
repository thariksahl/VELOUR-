import '../constants/app_strings.dart';

/// VELOUR — Form Validators
abstract class AppValidators {
  /// Validates an email address
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  /// Validates a password (min 8 chars)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 8) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  /// Validates that passwords match
  static String? Function(String?) confirmPassword(String original) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return AppStrings.passwordRequired;
      }
      if (value != original) {
        return AppStrings.passwordsDoNotMatch;
      }
      return null;
    };
  }

  /// Validates a required text field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? 'Please enter your $fieldName.'
          : AppStrings.fieldRequired;
    }
    return null;
  }

  /// Validates a first name
  static String? firstName(String? value) =>
      required(value, fieldName: 'first name');

  /// Validates a last name
  static String? lastName(String? value) =>
      required(value, fieldName: 'last name');

  /// Validates a phone number (basic)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number.';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }
}
