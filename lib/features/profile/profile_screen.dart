import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route_names.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _State();
}

class _State extends State<ProfileScreen> {
  static const Color _surface = Color(0xFFFAF9F5);
  static const Color _primary = Color(0xFF914722);
  static const Color _onSurface = Color(0xFF1B1C1A);
  static const Color _onSurfaceVariant = Color(0xFF54433C);
  static const Color _surfaceContainerLow = Color(0xFFF4F4F0);
  static const Color _outlineVariant = Color(0xFFDAC1B8);

  int _navIndex = 4; // PROFILE active

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
                  _section('Settings', _settingsItems()),
                  const SizedBox(height: 24),
                  _logoutButton(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(context),
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
                border: Border.all(color: _onSurface.withOpacity(0.10)),
              ),
              child: const Icon(Icons.arrow_back, size: 22, color: _onSurface),
            ),
          ),
          Text('VELOUR', style: _nr(24, FontWeight.w700, _onSurface, ls: 4.8)),
          const SizedBox(width: 40), // spacer for centering
        ],
      ),
    );
  }

  // ── Profile Hero ─────────────────────────────────────────────────────────
  // HTML: w-32 h-32 rounded-full border-4 border-surface-container-low p-1 + edit button

  Widget _profileHero() {
    return Column(
      children: [
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Avatar ring
              Container(
                width: 128, height: 128,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _surfaceContainerLow, width: 4),
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCwUCO1Q2-6GqH78G1ZB_AqPZ1VuIKCLIfs7mwmmIc6qxLhoMiCrSTiONNBcYkTO0dQwkillDLfM9rRWu92pVUtKXPrPLo1SBEZ2xkcsFu2JBVgAK4LCHcirGmszAYP7mYLjSJe1u6OcX18lN1AgamHCbbRTBxIU3b_YuhFw4QEmruyHMw6IuD6KzaSh9LyzZzPLa2eSfh7kAEbeAWxd73c3pZf0CeD8mwu4ivXZx6Yg_tH6itVoINkz-Y9zYiykfwVLKy2a-k66K4',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _surfaceContainerLow,
                      child: const Icon(Icons.person, size: 56, color: _onSurfaceVariant),
                    ),
                  ),
                ),
              ),
              // Edit button — bottom-1 right-1
              Positioned(
                bottom: 4, right: 4,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: _outlineVariant.withOpacity(0.20)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                  ),
                  child: const Icon(Icons.edit_outlined, size: 16, color: _onSurface),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Name — Newsreader bold 30px
        Text('Sarah', style: _nr(30, FontWeight.w700, _onSurface)),
        const SizedBox(height: 4),
        // Email — body sm on-surface-variant
        Text('sarahvelour01@gmail.com',
            style: _bvp(14, FontWeight.w400, _onSurfaceVariant, ls: 0.3)),
      ],
    );
  }

  // ── Section Builder ────────────────────────────────────────────────────────

  Widget _section(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label — text-[10px] tracking-[0.2em] uppercase opacity-60
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 24),
          child: Text(
            title.toUpperCase(),
            style: _bvp(10, FontWeight.w400, _onSurfaceVariant.withOpacity(0.60), ls: 3.2),
          ),
        ),
        // Menu rows with hairline dividers
        Column(
          children: items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return Column(
              children: [
                _menuRow(item),
                if (i < items.length - 1)
                  Container(height: 1, color: _outlineVariant.withOpacity(0.10),
                      margin: const EdgeInsets.symmetric(horizontal: 16)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _menuRow(_MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
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
            const Icon(Icons.chevron_right, size: 20, color: _primary),
          ],
        ),
      ),
    );
  }

  // ── Menu Items ─────────────────────────────────────────────────────────────

  List<_MenuItem> _accountItems(BuildContext context) => [
    _MenuItem(Icons.receipt_long_outlined, 'My Orders', () => context.go(RouteNames.orders)),
    _MenuItem(Icons.person_outline, 'My Details', () {}),
    _MenuItem(Icons.local_shipping_outlined, 'Shipping Address', () {}),
    _MenuItem(Icons.credit_card_outlined, 'Payment Methods', () {}),
  ];

  List<_MenuItem> _settingsItems() => [
    _MenuItem(Icons.notifications_outlined, 'Notifications', () {}),
    _MenuItem(Icons.language_outlined, 'Language', () {}),
    _MenuItem(Icons.gavel_outlined, 'Privacy Policy', () {}),
  ];

  // ── Log Out ────────────────────────────────────────────────────────────────

  Widget _logoutButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.go(RouteNames.login),
        child: Text(
          'LOG OUT',
          style: _bvp(13, FontWeight.w700, _primary, ls: 2.0),
        ),
      ),
    );
  }

  // ── Bottom Nav — PROFILE active ────────────────────────────────────────────

  Widget _bottomNav(BuildContext context) {
    const items = [
      (Icons.home_outlined, Icons.home, 'HOME'),
      (Icons.search, Icons.search, 'EXPLORE'),
      (Icons.favorite_outline, Icons.favorite, 'FAVOURITE'),
      (Icons.shopping_cart_outlined, Icons.shopping_cart, 'CART'),
      (Icons.person_outline, Icons.person, 'PROFILE'),
    ];
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F3F3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == _navIndex;
          final color = active ? Colors.black : _onSurfaceVariant.withOpacity(0.40);
          return GestureDetector(
            onTap: () {
              setState(() => _navIndex = i);
              switch (i) {
                case 0: context.go(RouteNames.home); break;
                case 1: context.go(RouteNames.explore); break;
                case 2: context.go(RouteNames.wishlist); break;
                case 3: context.go(RouteNames.cart); break;
                case 4: break;
              }
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 64,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(active ? items[i].$2 : items[i].$1, size: 28, color: color),
                const SizedBox(height: 4),
                Text(items[i].$3,
                    style: _bvp(10, FontWeight.w700, color, ls: 0.8)),
              ]),
            ),
          );
        }),
      ),
    );
  }
}

// ── Menu Item Model ────────────────────────────────────────────────────────────

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(this.icon, this.label, this.onTap);
}
