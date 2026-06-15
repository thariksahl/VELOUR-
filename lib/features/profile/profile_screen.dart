import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/theme_notifier.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routes/route_names.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _State();
}

class _State extends State<ProfileScreen> {
  int _navIndex = 4; // PROFILE active

  // ── Theme-aware color helpers ─────────────────────────────────────────────
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _onSurface => Theme.of(context).colorScheme.onSurface;
  Color get _onSurfaceVariant => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _outlineVariant => Theme.of(context).colorScheme.outlineVariant;

  TextStyle _nr(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 24,
                bottom: 80 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileHero(),
                  const SizedBox(height: 48),
                  _section('Account', _accountItems(context)),
                  const SizedBox(height: 40),
                  _section('Settings', _settingsItems(context)),
                  const SizedBox(height: 24),
                  _logoutButton(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _header(BuildContext context) {
    return Container(
      color: _surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 32, right: 32, bottom: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.go(RouteNames.home),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _onSurface.withValues(alpha: 0.10)),
              ),
              child: Icon(Icons.arrow_back, size: 22, color: _onSurface),
            ),
          ),
          Text('VELOUR', style: _nr(24, FontWeight.w700, _onSurface, ls: 4.8)),
          const SizedBox(width: 40), // spacer for centering
        ],
      ),
    );
  }

  // ── Profile Hero ──────────────────────────────────────────────────────────

  Widget _profileHero() {
    final authUser = fb_auth.FirebaseAuth.instance.currentUser;

    return StreamBuilder<Map<String, dynamic>?>(
      stream: FirestoreService.instance.userProfileStream(),
      builder: (context, snap) {
        final profile = snap.data;

        // Resolve display name: Firestore > Auth.displayName > email prefix
        String displayName;
        if (profile != null &&
            (profile['firstName'] != null || profile['lastName'] != null)) {
          final first = profile['firstName'] as String? ?? '';
          final last = profile['lastName'] as String? ?? '';
          displayName = '$first $last'.trim();
        } else if (authUser?.displayName != null &&
            authUser!.displayName!.isNotEmpty) {
          displayName = authUser.displayName!;
        } else if (authUser?.email != null) {
          displayName = authUser!.email!.split('@').first;
        } else {
          displayName = 'Guest';
        }

        final email =
            profile?['email'] as String? ?? authUser?.email ?? '';

        final photoUrl =
            profile?['photoUrl'] as String? ?? authUser?.photoURL;

        return Column(
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Avatar ring
                  Container(
                    width: 128,
                    height: 128,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        width: 4,
                      ),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: ClipOval(
                      child: photoUrl != null
                          ? Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                            )
                          : _avatarPlaceholder(),
                    ),
                  ),
                  // Edit button — bottom-1 right-1
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                            color: _outlineVariant.withValues(alpha: 0.20)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8)
                        ],
                      ),
                      child: Icon(Icons.edit_outlined,
                          size: 16, color: _onSurface),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(displayName,
                style: _nr(30, FontWeight.w700, _onSurface)),
            const SizedBox(height: 4),
            Text(email,
                style: _bvp(14, FontWeight.w400, _onSurfaceVariant,
                    ls: 0.3)),
          ],
        );
      },
    );
  }

  Widget _avatarPlaceholder() => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(Icons.person, size: 56, color: _onSurfaceVariant),
      );

  // ── Section Builder ────────────────────────────────────────────────────────

  Widget _section(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 24),
          child: Text(
            title.toUpperCase(),
            style: _bvp(10, FontWeight.w400, _onSurfaceVariant.withValues(alpha: 0.60), ls: 3.2),
          ),
        ),
        Column(
          children: items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return Column(
              children: [
                _menuRow(item),
                if (i < items.length - 1)
                  Container(
                    height: 1,
                    color: _outlineVariant.withValues(alpha: 0.10),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _menuRow(_MenuItem item) {
    return GestureDetector(
      onTap: item.trailing == null ? item.onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 24, color: _onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(child: Text(item.label, style: _bvp(15, FontWeight.w400, _onSurface))),
            item.trailing ??
                Icon(Icons.chevron_right, size: 20, color: _primary),
          ],
        ),
      ),
    );
  }

  // ── Menu Items ─────────────────────────────────────────────────────────────

  List<_MenuItem> _accountItems(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    return [
      _MenuItem(Icons.receipt_long_outlined, 'My Orders', () => context.go(RouteNames.orders)),
      _MenuItem(Icons.person_outline, 'My Details', () {}),
      _MenuItem(Icons.local_shipping_outlined, 'Shipping Address', () => context.push(RouteNames.shippingAddress)),
      // ── Dark Mode toggle ───────────────────────────────────────────────────
      _MenuItem(
        Icons.dark_mode_outlined,
        'Dark Mode',
        () {},
        trailing: Switch(
          value: themeNotifier.isDark,
          activeThumbColor: const Color(0xFFC1622A),
          activeTrackColor: const Color(0xFFC1622A).withValues(alpha: 0.40),
          onChanged: (v) => themeNotifier.toggle(v),
        ),
      ),
      _MenuItem(Icons.credit_card_outlined, 'Payment Methods', () => context.push(RouteNames.paymentMethods)),
    ];
  }

  List<_MenuItem> _settingsItems(BuildContext context) => [
    _MenuItem(Icons.notifications_outlined, 'Notifications', () => context.push(RouteNames.notificationSettings)),
    _MenuItem(Icons.language_outlined, 'Language', () => context.push(RouteNames.language)),
    _MenuItem(Icons.gavel_outlined, 'Privacy Policy', () => context.push(RouteNames.privacyPolicy)),
  ];

  // ── Log Out ────────────────────────────────────────────────────────────────

  Widget _logoutButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          await context.read<AuthProvider>().logout();
          if (context.mounted) context.go(RouteNames.login);
        },
        child: Text(
          'LOG OUT',
          style: _bvp(13, FontWeight.w700, _primary, ls: 2.0),
        ),
      ),
    );
  }
}

// ── Menu Item Model ────────────────────────────────────────────────────────────

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  const _MenuItem(this.icon, this.label, this.onTap, {this.trailing});
}
