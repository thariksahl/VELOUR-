import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_data.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routes/route_names.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _State();
}

class _State extends State<NotificationsScreen> {
  // HTML Tokens
  static const Color _surface = Color(0xFFFAF9F5);
  static const Color _onSurface = Color(0xFF1B1C1A);
  static const Color _onSurfaceVariant = Color(0xFF54433C);
  static const Color _surfaceContainerLow = Color(0xFFF4F4F0);
  static const Color _outlineVariant = Color(0xFFDAC1B8);
  static const Color _outline = Color(0xFF87736B);
  static const Color _primary = Color(0xFF914722);

  int _selectedFilter = 1; // "Orders"
  int _navIndex = 0; // HOME active

  TextStyle _nr(double s, FontWeight w, Color c, {double ls = 0, bool italic = false}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, letterSpacing: ls, fontStyle: italic ? FontStyle.italic : FontStyle.normal);

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
                left: 24, right: 24, top: 16,
                bottom: 80 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _categoryFilter(),
                  const SizedBox(height: 32),
                  _notificationList(),
                  const SizedBox(height: 32),
                  _recommendedSection(),
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
        left: 24, right: 24, bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(RouteNames.home);
                  }
                },
                child: const Icon(Icons.arrow_back, size: 28, color: _onSurface),
              ),
              const SizedBox(width: 16),
              // HTML: text-2xl font-newsreader italic tracking-widest text-[#1b1c1a]
              Text('Notifications', style: _nr(24, FontWeight.w400, _onSurface, ls: 2.4, italic: true)),
            ],
          ),
          // HTML: text-[#C06C44] text-[10px] font-bold tracking-widest uppercase
          GestureDetector(
            onTap: () {},
            child: Text(
              'MARK ALL READ',
              style: _bvp(10, FontWeight.w700, const Color(0xFFC06C44), ls: 1.0),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Filter ────────────────────────────────────────────────────────

  Widget _categoryFilter() {
    final filters = ['All', 'Orders', 'Offers', 'New Arrivals'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.asMap().entries.map((e) {
          final i = e.key;
          final active = i == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: Container(
              margin: EdgeInsets.only(right: i < filters.length - 1 ? 12 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: active ? _primary : _surfaceContainerLow,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                e.value,
                style: _bvp(12, FontWeight.w500, active ? Colors.white : _onSurfaceVariant),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Notification List ──────────────────────────────────────────────────────

  Widget _notificationList() {
    final notifications = AppData.notifications();

    return Column(
      children: notifications.asMap().entries.map((e) {
        final n = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(shape: BoxShape.circle, color: n.bgColor),
                child: Icon(n.icon, color: n.iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: _outlineVariant.withValues(alpha: 0.10))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: _bvp(14, n.isFadedText ? FontWeight.w500 : FontWeight.w600, n.isFadedText ? _onSurface.withValues(alpha: 0.80) : _onSurface),
                            ),
                          ),
                          if (n.isUnread)
                            Container(
                              margin: const EdgeInsets.only(top: 4, left: 8),
                              width: 8, height: 8,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: _primary),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n.subtitle,
                        style: _bvp(12, FontWeight.w400, n.isFadedText ? _onSurfaceVariant.withValues(alpha: 0.70) : _onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        n.time.toUpperCase(),
                        style: _bvp(10, FontWeight.w400, _outline, ls: 1.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Recommended Section ────────────────────────────────────────────────────

  Widget _recommendedSection() {
    return Container(
      padding: const EdgeInsets.only(top: 48),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _outlineVariant.withValues(alpha: 0.10))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recommended for You', style: _nr(30, FontWeight.w400, _onSurface, italic: true)),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://lh3.googleusercontent.com/aida/ADBb0ujUHpHWWX9qoA_oexBa6lfoi_EZfkyyXm2wn9DSR3oSQ_9PD0jx3OEwbgbIL3tFgeuczRnX8QXTIkKWO3WBqG3vFQCG-x_q8JuXwZpkhmP0d-mcUBbuNBbgo2TvumUHy1G9pY3DwQN9AxAEerCrXgIACFbtQ6bnR4wcAE5pjrIk9zX2_EOsvlkyLz5fcan4b5sPMJi4Mw3MC55veYWE7zk5RSxP_U8zLUNpEHdyvx1gw5-uyUXVa9hYM0WqbL2mShxFf7lH8UuiGw',
                    fit: BoxFit.cover,
                  ),
                  // Gradient bottom
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.50), Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 32, left: 32, right: 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('THE SUMMER EDIT', style: _bvp(10, FontWeight.w500, Colors.white.withValues(alpha: 0.80), ls: 2.0)),
                        const SizedBox(height: 8),
                        Text('Effortless Elegance', style: _nr(30, FontWeight.w400, Colors.white, italic: true)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: Text('SHOP NOW', style: _bvp(10, FontWeight.w700, Colors.black, ls: 2.0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom nav is now handled by BottomNavBar
}

