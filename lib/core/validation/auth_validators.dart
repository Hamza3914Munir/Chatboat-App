/// Validation rules shared by the auth screens.
///
/// Each validator returns `null` when the value is acceptable, or the message
/// to show beneath the field. The signature matches `FormFieldValidator<String>`
/// so these can be handed straight to [AuthTextField].
abstract final class AuthValidators {
  /// Minimum password length. Kept in one place so the rule and the hint shown
  /// under the password field can never drift apart.
  static const minPasswordLength = 8;

  /// Deliberately permissive: one `@`, a dot-bearing domain, no whitespace.
  /// Stricter patterns reject addresses that are in fact deliverable, and the
  /// real check is the verification email.
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? fullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter your full name.';
    if (name.length < 2) return 'That name looks too short.';
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!_emailPattern.hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Enter a password.';
    if (password.length < minPasswordLength) {
      return 'Use at least $minPasswordLength characters.';
    }
    return null;
  }

  /// Login accepts any non-empty password: the length rule belongs to sign-up,
  /// and rejecting a short password here would only tell the user their
  /// existing account is wrong.
  static String? loginPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Enter your password.';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if ((value ?? '').isEmpty) return 'Re-enter your password.';
      if (value != original()) return 'Passwords do not match.';
      return null;
    };
  }
}
