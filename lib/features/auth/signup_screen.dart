import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../routes/route_names.dart';
import 'auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _passwordVisible = false;

  static const Color _brandDark = Color(0xFF5D4925);
  static const Color _onSurfaceVariant = Color(0xFF716E64);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    // Split "Full Name" into firstName / lastName for the repository
    final parts = _nameController.text.trim().split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final success = await auth.signup(
      firstName: firstName,
      lastName: lastName,
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  64,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Inline Header ───────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.go(RouteNames.login),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.onSurface.withValues(alpha: 0.10),
                            ),
                          ),
                          child: const Icon(Icons.arrow_back, size: 18, color: AppColors.onSurface),
                        ),
                      ),
                      Text(
                        'VELOUR',
                        style: GoogleFonts.newsreader(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: _brandDark,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(width: 32),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // ── Centered Headline ───────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.newsreader(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: _brandDark,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Join us and start your style journey',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 15,
                            color: _onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Form ────────────────────────────────────────────────
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _SignupField(
                          placeholder: 'Full Name',
                          controller: _nameController,
                          focusNode: _nameFocus,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                        ),
                        const SizedBox(height: 16),
                        _SignupField(
                          placeholder: 'Email Address',
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: AppValidators.email,
                          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                        ),
                        const SizedBox(height: 16),
                        _SignupField(
                          placeholder: 'Password',
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: !_passwordVisible,
                          textInputAction: TextInputAction.next,
                          validator: AppValidators.password,
                          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmFocus),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                            child: Icon(
                              _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 20,
                              color: _onSurfaceVariant.withValues(alpha: 0.60),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SignupField(
                          placeholder: 'Confirm Password',
                          controller: _confirmPasswordController,
                          focusNode: _confirmFocus,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please confirm password';
                            if (v != _passwordController.text) return 'Passwords do not match';
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(),
                        ),

                        const SizedBox(height: 16),

                        // Error message
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) {
                            if (auth.errorMessage == null) return const SizedBox.shrink();
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: AppColors.error, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      auth.errorMessage!,
                                      style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.error),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 4),

                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => _SignupButton(
                            isLoading: auth.isLoading,
                            onTap: _submit,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── OR Divider ──────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: AppColors.onSurface.withValues(alpha: 0.05))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _onSurfaceVariant,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: AppColors.onSurface.withValues(alpha: 0.05))),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Social Buttons ──────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _SocialBtn(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.g_mobiledata_rounded, size: 22, color: Color(0xFF4285F4)),
                              const SizedBox(width: 10),
                              Text('Google', style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SocialBtn(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.apple, size: 20, color: AppColors.onSurface),
                              const SizedBox(width: 10),
                              Text('Apple', style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // ── Footer ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(top: 48, bottom: 8),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w500, color: _onSurfaceVariant.withValues(alpha: 0.70)),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => context.go(RouteNames.login),
                                child: Text(
                                  'Log In',
                                  style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w700, color: _brandDark),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

// ── Field ─────────────────────────────────────────────────────────────────────

class _SignupField extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;

  const _SignupField({
    required this.placeholder,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: GoogleFonts.beVietnamPro(fontSize: 15, color: const Color(0xFF231F14)),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.beVietnamPro(fontSize: 15, color: const Color(0xFF716E64).withValues(alpha: 0.70)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon != null
            ? Padding(padding: const EdgeInsets.only(right: 14), child: suffixIcon)
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE9E4))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE9E4))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFC56E42), width: 1.0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
      ),
    );
  }
}

// ── Gradient Button ───────────────────────────────────────────────────────────

class _SignupButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _SignupButton({required this.isLoading, required this.onTap});

  @override
  State<_SignupButton> createState() => _SignupButtonState();
}

class _SignupButtonState extends State<_SignupButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.98).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); if (!widget.isLoading) widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFC56E42), Color(0xFFBD926E)],
            ),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [BoxShadow(color: const Color(0xFFC56E42).withValues(alpha: 0.20), blurRadius: 20, offset: const Offset(0, 6))],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text('Sign Up', style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ),
    );
  }
}

// ── Social Button ─────────────────────────────────────────────────────────────

class _SocialBtn extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _SocialBtn({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEBE9E4)),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
