import 'package:laundry_mobile/app/utils/constants/text_strings.dart';

class TValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value!.isEmpty) {
      return TTexts.tNameCannotEmpty;
    }

    if (value.length < 3 || value.length > 30) {
      return TTexts.tEmailCharacters;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return TTexts.tEmailCannotEmpty;
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return TTexts.tInvalidEmailFormat;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return TTexts.tPasswordCannotEmpty;
    }

    // Check for minimum password length
    if (value.length < 6) {
      return TTexts.tPasswordCharacters;
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return TTexts.tPasswordCheckUppercase;
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return TTexts.tPasswordChecknumbers;
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return TTexts.tPasswordCheckSpecialCharacters;
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return TTexts.tPhoneCannotEmpty;
    }

    return null;
  }
}
