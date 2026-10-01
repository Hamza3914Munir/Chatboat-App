import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/core/preferences/registration_preferences.dart';
import 'package:facepix/core/theme/auth_colors.dart';
import 'package:facepix/core/validation/auth_validators.dart';
import 'package:facepix/features/auth/email_verification_screen.dart';
import 'package:facepix/features/auth/login_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:facepix/features/auth/widgets/auth_inline_link_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _termsAccepted = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _submitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _completeRegistration() async {
    // Validate before touching storage. Previously this method ran
    // unconditionally, so an entirely empty form was saved and accepted.
    if (!(_formKey.currentState?.validate() ?? false)) {
      // Put the caret on the first field that failed so the fix is one tap.
      if (AuthValidators.fullName(_fullNameController.text) != null) {
        _fullNameFocus.requestFocus();
      } else if (AuthValidators.email(_emailController.text) != null) {
        _emailFocus.requestFocus();
      } else if (AuthValidators.password(_passwordController.text) != null) {
        _passwordFocus.requestFocus();
      } else {
        _confirmPasswordFocus.requestFocus();
      }
      return;
    }

    setState(() => _submitting = true);
    final email = _emailController.text.trim();
    await AuthFlowPreferences.setSignupEmail(email);
    await AuthFlowPreferences.setFullName(_fullNameController.text.trim());
    await RegistrationPreferences.setCompleted(true);
    if (!mounted) return;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => EmailVerificationScreen(email: email),
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 64),
              child: Column(
                children: [
                  SizedBox(
                    width: 204,
                    height: 144,
                    child: Image.asset(
                      'assets/auth/signup_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 36 / 28,
                      color: AuthColors.title,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Text(
                      'Start creating amazing photos and\nvideos with AI.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                        color: AuthColors.subtitle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    leadingIconAsset: 'assets/auth/icon_user.svg',
                    controller: _fullNameController,
                    focusNode: _fullNameFocus,
                    validator: AuthValidators.fullName,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    onSubmitted: (_) => _emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    leadingIconAsset: 'assets/auth/icon_email.svg',
                    controller: _emailController,
                    focusNode: _emailFocus,
                    validator: AuthValidators.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    label: 'Password',
                    hint: '••••••••',
                    leadingIconAsset: 'assets/auth/icon_lock.svg',
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    validator: AuthValidators.password,
                    obscureText: !_passwordVisible,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                    helperText:
                        'Use at least ${AuthValidators.minPasswordLength} '
                        'characters.',
                    suffix: PasswordVisibilityToggle(
                      visible: _passwordVisible,
                      onToggle: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    label: 'Confirm Password',
                    hint: '••••••••',
                    leadingIconAsset: 'assets/auth/icon_lock.svg',
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    validator: AuthValidators.confirmPassword(
                      () => _passwordController.text,
                    ),
                    obscureText: !_confirmPasswordVisible,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    onSubmitted: (_) => _completeRegistration(),
                    suffix: PasswordVisibilityToggle(
                      visible: _confirmPasswordVisible,
                      onToggle: () => setState(
                        () =>
                            _confirmPasswordVisible = !_confirmPasswordVisible,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _TermsCheckboxRow(
                    value: _termsAccepted,
                    onChanged: (value) =>
                        setState(() => _termsAccepted = value),
                  ),
                  const SizedBox(height: 16),
                  GradientAuthButton(
                    label: 'Create Account',
                    busy: _submitting,
                    // Null, not a no-op: the button is really disabled, so it
                    // cannot ripple and reads as disabled to screen readers.
                    onPressed: _termsAccepted ? _completeRegistration : null,
                  ),
                  const SizedBox(height: 31),
                  AuthInlineLinkText(
                    spans: [
                      const AuthLinkSpan('Already have an account? '),
                      AuthLinkSpan.link('Log In', _goToLogin),
                    ],
                    baseStyle: GoogleFonts.inter(
                      fontSize: 15,
                      height: 22.5 / 15,
                      color: AuthColors.subtitle,
                    ),
                    linkStyle: const TextStyle(color: AuthColors.link),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Terms consent.
///
/// The whole row toggles the checkbox — the bare 20x20 box it used to be is
/// far below the 48px minimum, and the sentence beside it was not a tap target
/// at all. The two embedded links still handle their own taps, because the
/// text's gesture recognizers hit-test ahead of the row behind them.
class _TermsCheckboxRow extends StatelessWidget {
  const _TermsCheckboxRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      label: 'I agree to the Terms of Service and Privacy Policy',
      // Keeps the two links as their own reachable nodes instead of folding
      // them into the checkbox's label.
      explicitChildNodes: true,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual only — the row owns the gesture, so the checkbox must not
            // swallow taps or report a second, competing semantics node.
            ExcludeSemantics(
              child: IgnorePointer(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: value,
                    onChanged: (_) {},
                    activeColor: AuthColors.link,
                    side: const BorderSide(color: AuthColors.fieldBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AuthInlineLinkText(
                textAlign: TextAlign.start,
                spans: [
                  const AuthLinkSpan('I agree to the '),
                  AuthLinkSpan.link('Terms of Service', () {}),
                  const AuthLinkSpan(' and '),
                  AuthLinkSpan.link('Privacy Policy', () {}),
                ],
                baseStyle: GoogleFonts.inter(
                  fontSize: 14,
                  height: 17.5 / 14,
                  color: AuthColors.termsText,
                ),
                linkStyle: const TextStyle(color: AuthColors.link),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
