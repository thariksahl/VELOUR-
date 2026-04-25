import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _contentFade;
  late Animation<double> _buttonFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onExplore() {
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onSurface,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Full-bleed background editorial photo ───────────────────────
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC0O-yDsY2v_RwXiGz9TUncRXqu1pyBuVtwBD_Uan6XPt8uXkbdBGWKHQ0sJqGZHeCmqnVMv7TudhR6iSXWIXg4F7JPRy03r_05p3XklIp_FhnDWGahUc4TAiFjejswromIAIss1LO2ryWSkekZg3o_7-l-nwKLLuBbfKVlBpwEz9mc0nlFRyqCZ3QZR8brM-h_SkDGr_JIKlsfOQPqrtwIbvzkUdW4EoPoBT4P9ZAN7yD5CbVSdnWS9S2h90P2e7LBMm_M7Whci04',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: const Color(0xFF1B1C1A));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2E1A0E), Color(0xFF1B1C1A)],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Gradient overlay ────────────────────────────────────────────
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                  colors: [
                    Colors.transparent,
                    Color(0x1A1B1C1A),
                    Color(0x661B1C1A),
                  ],
                ),
              ),
            ),
          ),

          // ── Top app bar ─────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ),

          // ── Central brand identity ──────────────────────────────────────
          Center(
            child: FadeTransition(
              opacity: _contentFade,
              child: SlideTransition(
                position: _contentSlide,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'VELOUR',
                        style: GoogleFonts.newsreader(
                          fontSize: 72,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          letterSpacing: -2.0,
                          height: 1.0,
                          shadows: const [
                            Shadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'The Art of Simplicity',
                        style: GoogleFonts.newsreader(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.90),
                          letterSpacing: 1.5,
                          shadows: const [
                            Shadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom CTA button ───────────────────────────────────────────
          Positioned(
            bottom: 64,
            left: 32,
            right: 32,
            child: FadeTransition(
              opacity: _buttonFade,
              child: _ExploreButton(onTap: _onExplore),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ExploreButton({required this.onTap});

  @override
  State<_ExploreButton> createState() => _ExploreButtonState();
}

class _ExploreButtonState extends State<_ExploreButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 448),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFF4F4F0), Color(0xFFFFFFFF)],
            ),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            'EXPLORE NOW',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              letterSpacing: 2.8,
            ),
          ),
        ),
      ),
    );
  }
}
