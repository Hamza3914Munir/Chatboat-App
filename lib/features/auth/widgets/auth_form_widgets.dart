import 'package:facepix/core/theme/auth_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material's minimum touch target, used for standalone controls that have
/// room for it (WCAG 2.5.5 Target Size, AAA).
const double kMinTapTarget = 48;

/// Minimum for links sitting inline in a sentence (WCAG 2.5.8 Target Size
/// Minimum, AA). Growing these to [kMinTapTarget] is not possible without
/// moving the surrounding copy: the gaps above them in the design are only
/// 8px, so a 48px target would push the layout by ~28px.
const double kMinInlineTapTarget = 24;

/// A labelled text field with a leading icon, an optional trailing control and
/// an error line.
///
/// Built on [FormField] rather than [TextFormField] so the error renders
/// *below* the field's [Stack] instead of inside it — the icons are positioned
/// against that stack, and letting the decorator grow for an error message
/// would drag them out of alignment.
class AuthTextField extends FormField<String> {
  AuthTextField({
    super.key,
    required String label,
    required String hint,
    required String leadingIconAsset,
    required TextEditingController controller,
    super.validator,
    super.onSaved,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Iterable<String>? autofillHints,
    FocusNode? focusNode,
    ValueChanged<String>? onSubmitted,
    Widget? suffix,
    String? helperText,
    Color? borderColor,
    double borderRadius = 12,
    double fieldHeight = 56,
  }) : super(
         initialValue: controller.text,
         // Don't shout at someone who hasn't typed yet; validate once they
         // have interacted, then keep the message live as they correct it.
         autovalidateMode: AutovalidateMode.onUserInteraction,
         builder: (field) {
           final resting = borderColor ?? AuthColors.fieldBorder;
           final hasError = field.hasError;
           final outline = hasError ? AuthColors.error : resting;

           OutlineInputBorder border(Color color, [double width = 1]) {
             return OutlineInputBorder(
               borderRadius: BorderRadius.circular(borderRadius),
               borderSide: BorderSide(color: color, width: width),
             );
           }

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 label,
                 style: GoogleFonts.inter(
                   fontSize: 14,
                   fontWeight: FontWeight.w700,
                   height: 20 / 14,
                   color: AuthColors.label,
                 ),
               ),
               const SizedBox(height: 8),
               Stack(
                 alignment: Alignment.centerRight,
                 children: [
                   SizedBox(
                     height: fieldHeight,
                     child: TextField(
                       controller: controller,
                       focusNode: focusNode,
                       obscureText: obscureText,
                       keyboardType: keyboardType,
                       textInputAction: textInputAction,
                       autofillHints: autofillHints,
                       onChanged: field.didChange,
                       onSubmitted: onSubmitted,
                       style: GoogleFonts.inter(
                         fontSize: 16,
                         fontWeight: FontWeight.w400,
                         color: AuthColors.label,
                       ),
                       decoration: InputDecoration(
                         hintText: hint,
                         hintStyle: GoogleFonts.inter(
                           fontSize: 16,
                           fontWeight: FontWeight.w400,
                           color: AuthColors.hint,
                         ),
                         filled: true,
                         fillColor: Colors.white,
                         contentPadding: EdgeInsets.fromLTRB(
                           48,
                           0,
                           suffix != null ? 48 : 16,
                           0,
                         ),
                         enabledBorder: border(outline),
                         focusedBorder: border(
                           hasError ? AuthColors.error : AuthColors.link,
                           1.2,
                         ),
                         border: border(outline),
                       ),
                     ),
                   ),
                   Positioned(
                     left: 16,
                     child: SvgPicture.asset(
                       leadingIconAsset,
                       width: 16,
                       height: 16,
                     ),
                   ),
                   // The trailing control is 48x48 for the touch target, but
                   // its icon is only ~16 wide. Insetting by 4 keeps that icon
                   // on the same pixel it sat on when the box was icon-sized.
                   if (suffix != null) Positioned(right: 4, child: suffix),
                 ],
               ),
               if (hasError) ...[
                 const SizedBox(height: 8),
                 Text(
                   field.errorText!,
                   style: GoogleFonts.inter(
                     fontSize: 12,
                     fontWeight: FontWeight.w500,
                     height: 16 / 12,
                     color: AuthColors.error,
                   ),
                 ),
               ] else if (helperText != null) ...[
                 const SizedBox(height: 8),
                 Text(
                   helperText,
                   style: GoogleFonts.inter(
                     fontSize: 12,
                     fontWeight: FontWeight.w500,
                     height: 16 / 12,
                     color: AuthColors.passwordHint,
                   ),
                 ),
               ],
             ],
           );
         },
       );
}

/// The primary auth action.
///
/// A null [onPressed] renders a genuinely disabled button: no tap, no ripple,
/// and `enabled: false` reported to screen readers. The screens previously
/// faked this with an [Opacity] wrapper and a no-op callback, which still
/// rippled under the finger and still read as actionable to assistive tech.
class GradientAuthButton extends StatelessWidget {
  const GradientAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradient,
    this.borderRadius = 16,
    this.verticalPadding = 17,
    this.fontSize = 14,
    this.trailingIconAsset,
    this.shadowColor,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final double borderRadius;
  final double verticalPadding;
  final double fontSize;
  final String? trailingIconAsset;
  final Color? shadowColor;

  /// Shows a spinner and blocks input while an action is in flight.
  final bool busy;

  bool get _enabled => onPressed != null && !busy;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      child: Opacity(
        opacity: _enabled ? 1 : 0.55,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient ?? AuthColors.buttonGradient,
            borderRadius: radius,
            boxShadow: [
              if (!_enabled)
                const BoxShadow(color: Colors.transparent)
              else if (shadowColor != null)
                BoxShadow(
                  color: shadowColor!,
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                )
              else
                const BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _enabled ? onPressed : null,
              borderRadius: radius,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: verticalPadding),
                child: Center(
                  child: busy
                      ? SizedBox(
                          height: fontSize + 4,
                          width: fontSize + 4,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              style: GoogleFonts.inter(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w700,
                                height: 20 / fontSize,
                                color: Colors.white,
                              ),
                            ),
                            if (trailingIconAsset != null) ...[
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                trailingIconAsset!,
                                width: 16,
                                height: 16,
                              ),
                            ],
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
}

class SecondaryOutlinedButton extends StatelessWidget {
  const SecondaryOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.borderRadius = 12,
  });

  final String label;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: const BorderSide(color: AuthColors.fieldBorder),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 20 / 14,
                    color: AuthColors.label,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FooterPillButton extends StatelessWidget {
  const FooterPillButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AuthColors.footerPillBackground,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: AuthColors.label,
            ),
          ),
        ),
      ),
    );
  }
}

class EmailPill extends StatelessWidget {
  const EmailPill({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AuthColors.emailPillBackground,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: AuthColors.emailPillBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/auth/icon_envelope_small.svg',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                email,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AuthColors.label,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FooterLinkRow extends StatelessWidget {
  const FooterLinkRow({super.key, required this.links});

  final List<FooterLink> links;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < links.length; i++) ...[
          if (i > 0)
            Text(
              '•',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AuthColors.subtitle.withValues(alpha: 0.8),
              ),
            ),
          _MinTapTarget(
            onTap: links[i].onTap,
            child: Text(
              links[i].label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AuthColors.link.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class FooterLink {
  const FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;
}

/// Grows a small control's touch area to [kMinTapTarget] without moving or
/// resizing what is drawn.
class _MinTapTarget extends StatelessWidget {
  const _MinTapTarget({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kMinInlineTapTarget),
        child: Center(widthFactor: 1, child: child),
      ),
    );
  }
}

/// Show/hide control for a password field.
///
/// Sized to [kMinTapTarget] and given its own transparent [Material] so the
/// ripple paints *above* the field's white fill. Previously the ink landed on
/// the Scaffold's material behind the filled TextField, so tapping it produced
/// no visible feedback at all.
class PasswordVisibilityToggle extends StatelessWidget {
  const PasswordVisibilityToggle({
    super.key,
    required this.visible,
    required this.onToggle,
  });

  final bool visible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMinTapTarget,
      height: kMinTapTarget,
      child: Semantics(
        button: true,
        label: visible ? 'Hide password' : 'Show password',
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onToggle,
            customBorder: const CircleBorder(),
            child: Center(
              child: SvgPicture.asset(
                visible
                    ? 'assets/auth/icon_eye.svg'
                    : 'assets/auth/icon_eye_off.svg',
                width: 18,
                height: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
