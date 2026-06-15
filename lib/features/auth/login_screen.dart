import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../routes/route_names.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await auth.login(email: email, password: password);

    if (!mounted) return;

    if (success) {
      context.go(RouteNames.home);
    } else if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: const Color(0xFFB3261E),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _FrostedAppBar(onBack: () => context.go(RouteNames.splash)),
      body: Stack(
        children: [
          // ── Decorative blurred glows ────────────────────────────────────
          Positioned(
            top: -96,
            right: -96,
            child: _Glow(size: 384, color: AppColors.primaryContainer.withValues(alpha: 0.10), blur: 120),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: -96,
            child: _Glow(size: 256, color: AppColors.tertiary.withValues(alpha: 0.05), blur: 100),
          ),

          // ── Scrollable content ──────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 80, 32, 48),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      kToolbarHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ─────────────────────────────────────────
                      const SizedBox(height: 8),
                      Text(
                        'Create Account',
                        style: GoogleFonts.newsreader(
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Sign in to continue shopping',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 0.4,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Form ───────────────────────────────────────────
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _GhostField(
                              placeholder: 'Email Address',
                              controller: _emailController,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: AppValidators.email,
                              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                            ),
                            const SizedBox(height: 24),
                            _GhostField(
                              placeholder: 'Password',
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: !_passwordVisible,
                              textInputAction: TextInputAction.done,
                              validator: AppValidators.password,
                              onFieldSubmitted: (_) => _submit(),
                              suffixIcon: GestureDetector(
                                onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                                child: Icon(
                                  _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.60),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.tertiary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Error message ───────────────────────────────────
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          if (auth.errorMessage == null) return const SizedBox.shrink();
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
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

                      // ── CTA Login Button ────────────────────────────────
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) => _GradientButton(
                          label: 'Log In',
                          isLoading: auth.isLoading,
                          onTap: _submit,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── OR Divider ──────────────────────────────────────
                      Row(
                        children: [
                          Expanded(child: Container(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.30))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR CONTINUE WITH',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.60),
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          Expanded(child: Container(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.30))),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // ── Social buttons — side by side ───────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
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
                            child: _SocialButton(
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

                      // ── Footer ─────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.only(top: 48, bottom: 8),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.onSurfaceVariant),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => context.go(RouteNames.signup),
                                    child: Text(
                                      'Sign Up',
                                      style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.tertiary),
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
        ],
      ),
    );
  }
}

// ── Frosted App Bar ───────────────────────────────────────────────────────────

class _FrostedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  const _FrostedAppBar({required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        color: AppColors.surface.withValues(alpha: 0.80),
        child: SafeArea(
          child: SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.30)),
                        ),
                        child: const Icon(Icons.arrow_back, size: 20, color: AppColors.onSurface),
                      ),
                    ),
                  ),
                  Text(
                    'VELOUR',
                    style: GoogleFonts.newsreader(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6D5D3E),
                      letterSpacing: 6.0,
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

// ── Ghost Field ───────────────────────────────────────────────────────────────

class _GhostField extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;

  const _GhostField({
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
      style: GoogleFonts.beVietnamPro(fontSize: 16, color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.beVietnamPro(fontSize: 16, color: AppColors.onSurfaceVariant.withValues(alpha: 0.60)),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        suffixIcon: suffixIcon != null
            ? Padding(padding: const EdgeInsets.only(right: 16), child: suffixIcon)
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}

// ── Gradient Button ───────────────────────────────────────────────────────────

class _GradientButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _GradientButton({required this.label, required this.isLoading, required this.onTap});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF914722), Color(0xFFAF5F38)],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text(widget.label, style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.3)),
        ),
      ),
    );
  }
}

// ── Social Button ─────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _SocialButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.20)),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

// ── Decorative Glow ───────────────────────────────────────────────────────────

class _Glow extends StatelessWidget {
  final double size;
  final Color color;
  final double blur;
  const _Glow({required this.size, required this.color, required this.blur});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.30,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color, blurRadius: blur, spreadRadius: size * 0.3)],
        ),
      ),
    );
  }
}
