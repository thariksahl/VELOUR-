import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routes/route_names.dart';
import 'notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _State();
}

class _State extends State<NotificationsScreen> {
  int _selectedFilter = 1; // "Orders"
  int _navIndex = 0; // HOME active

  TextStyle _nr(double s, FontWeight w, Color c, {double ls = 0, bool italic = false}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, letterSpacing: ls, fontStyle: italic ? FontStyle.italic : FontStyle.normal);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
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
                child: Icon(Icons.arrow_back, size: 28, color: theme.iconTheme.color),
              ),
              const SizedBox(width: 16),
              Text(
                'Notifications',
                style: _nr(
                  24,
                  FontWeight.w400,
                  theme.textTheme.headlineMedium?.color ?? theme.colorScheme.onSurface,
                  ls: 2.4,
                  italic: true,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'MARK ALL READ',
              style: _bvp(10, FontWeight.w700, const Color(0xFFC1633A), ls: 1.0),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Filter ────────────────────────────────────────────────────────

  Widget _categoryFilter() {
    final theme = Theme.of(context);
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
                color: active ? const Color(0xFFC1633A) : theme.cardColor,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                e.value,
                style: _bvp(
                  12,
                  FontWeight.w500,
                  active
                      ? Colors.white
                      : (theme.textTheme.bodyMedium?.color ?? const Color(0xFF54433C)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Notification List ──────────────────────────────────────────────────────

  Widget _notificationList() {
    final theme = Theme.of(context);
    final notifications =
        context.watch<NotificationProvider>().notifications;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: notifications.asMap().entries.map((e) {
          final n = e.value;
          final isLast = e.key == notifications.length - 1;
          return Container(
            color: theme.cardColor,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.cardColor,
                  ),
                  child: Icon(n.icon, color: theme.iconTheme.color, size: 24),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(bottom: BorderSide(color: theme.dividerColor)),
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
                                style: _bvp(
                                  14,
                                  n.isFadedText ? FontWeight.w500 : FontWeight.w600,
                                  theme.textTheme.bodyLarge?.color ?? Colors.black,
                                ),
                              ),
                            ),
                            if (n.isUnread)
                              Container(
                                margin: const EdgeInsets.only(top: 4, left: 8),
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFC1633A),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n.subtitle,
                          style: _bvp(
                            12,
                            FontWeight.w400,
                            theme.textTheme.bodyMedium?.color ?? Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          n.time.toUpperCase(),
                          style: _bvp(10, FontWeight.w400, theme.hintColor, ls: 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Recommended Section ────────────────────────────────────────────────────

  Widget _recommendedSection() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 48),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended for You',
            style: _nr(
              30,
              FontWeight.w400,
              theme.textTheme.headlineMedium?.color ?? theme.colorScheme.onSurface,
              italic: true,
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFD9D9D9),
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.65),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.55],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 32,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DRESS TO IMPRESS',
                          style: _bvp(10, FontWeight.w700, Colors.white.withValues(alpha: 0.80), ls: 2.0),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Party Wear',
                          style: _nr(30, FontWeight.w400, Colors.white, italic: true),
                        ),
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
}
