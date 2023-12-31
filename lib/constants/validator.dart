class Validator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email can not be empty.";
    }
    final emailRegex =
        RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
    if (!emailRegex.hasMatch(value)) {
      return "Invalid email format";
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can not be empty.";
    }
    if (value.length < 6) {
      return "Password length should be at least 6.";
    }
    return null;
  }
}
