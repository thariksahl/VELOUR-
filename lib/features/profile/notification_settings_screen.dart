import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newArrivals = false;
  bool _priceDrops = false;
  bool _flashSales = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orderUpdates = prefs.getBool('notif_order_updates') ?? true;
      _promotions = prefs.getBool('notif_promotions') ?? true;
      _newArrivals = prefs.getBool('notif_new_arrivals') ?? false;
      _priceDrops = prefs.getBool('notif_price_drops') ?? false;
      _flashSales = prefs.getBool('notif_flash_sales') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _toggleSetting(String key, bool value, Function(bool) updateState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {
      updateState(value);
    });
  }

  TextStyle _nr(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('NOTIFICATION SETTINGS', style: _nr(16, FontWeight.w700, cs.onSurface, ls: 2.0)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFFC1622A))))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHOOSE WHAT WE NOTIFY YOU ABOUT',
                    style: _bvp(10, FontWeight.w500, cs.onSurfaceVariant.withValues(alpha: 0.6), ls: 2.0),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSwitchRow(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Order Updates',
                          subtitle: 'Tracking status, delivery updates, and receipts',
                          value: _orderUpdates,
                          onChanged: (val) => _toggleSetting('notif_order_updates', val, (v) => _orderUpdates = v),
                          cs: cs,
                        ),
                        _buildDivider(cs),
                        _buildSwitchRow(
                          icon: Icons.local_offer_outlined,
                          title: 'Promotions & Offers',
                          subtitle: 'Coupons, exclusive sales, and holiday events',
                          value: _promotions,
                          onChanged: (val) => _toggleSetting('notif_promotions', val, (v) => _promotions = v),
                          cs: cs,
                        ),
                        _buildDivider(cs),
                        _buildSwitchRow(
                          icon: Icons.fiber_new_outlined,
                          title: 'New Arrivals',
                          subtitle: 'Alerts when your favorite brands launch collections',
                          value: _newArrivals,
                          onChanged: (val) => _toggleSetting('notif_new_arrivals', val, (v) => _newArrivals = v),
                          cs: cs,
                        ),
                        _buildDivider(cs),
                        _buildSwitchRow(
                          icon: Icons.trending_down_outlined,
                          title: 'Price Drop Alerts',
                          subtitle: 'Notifications when saved wishlist items go on sale',
                          value: _priceDrops,
                          onChanged: (val) => _toggleSetting('notif_price_drops', val, (v) => _priceDrops = v),
                          cs: cs,
                        ),
                        _buildDivider(cs),
                        _buildSwitchRow(
                          icon: Icons.bolt_outlined,
                          title: 'Flash Sales',
                          subtitle: 'Limited-time drops and high demand store launches',
                          value: _flashSales,
                          onChanged: (val) => _toggleSetting('notif_flash_sales', val, (v) => _flashSales = v),
                          cs: cs,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ColorScheme cs,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: cs.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _bvp(15, FontWeight.w600, cs.onSurface)),
                const SizedBox(height: 4),
                Text(subtitle, style: _bvp(12, FontWeight.w400, cs.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFFC1622A),
            activeTrackColor: const Color(0xFFC1622A).withValues(alpha: 0.4),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme cs) {
    return Container(
      height: 1,
      color: cs.outlineVariant.withValues(alpha: 0.15),
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
