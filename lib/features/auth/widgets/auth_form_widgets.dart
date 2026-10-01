import 'package:facepix/core/theme/auth_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.leadingIconAsset,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.helperText,
    this.borderColor,
    this.borderRadius = 12,
    this.fieldHeight = 56,
  });

  final String label;
  final String hint;
  final String leadingIconAsset;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? helperText;
  final Color? borderColor;
  final double borderRadius;
  final double fieldHeight;

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AuthColors.fieldBorder;
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
                obscureText: obscureText,
                keyboardType: keyboardType,
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(
                      color: AuthColors.link,
                      width: 1.2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: border),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              child: SvgPicture.asset(leadingIconAsset, width: 16, height: 16),
            ),
            if (suffix != null) Positioned(right: 16, child: suffix!),
          ],
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText!,
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
  }
}

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
  });

  final String label;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final double borderRadius;
  final double verticalPadding;
  final double fontSize;
  final String? trailingIconAsset;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient ?? AuthColors.buttonGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          if (shadowColor != null)
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
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Center(
              child: Row(
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
                    SvgPicture.asset(trailingIconAsset!, width: 16, height: 16),
                  ],
                ],
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
  final VoidCallback onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
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
          GestureDetector(
            onTap: links[i].onTap,
            child: Text(
              links[i].label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AuthColors.link,
              ).copyWith(color: AuthColors.link.withValues(alpha: 0.8)),
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
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SvgPicture.asset(
          visible ? 'assets/auth/icon_eye.svg' : 'assets/auth/icon_eye_off.svg',
          width: 18,
          height: 14,
        ),
      ),
    );
  }
}
