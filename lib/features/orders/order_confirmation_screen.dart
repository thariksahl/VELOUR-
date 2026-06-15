import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_data.dart';
import '../../routes/route_names.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  // HTML tokens
  static const Color _surface = Color(0xFFFAF9F5);
  static const Color _primary = Color(0xFF914722);
  static const Color _primaryContainer = Color(0xFFAF5F38);
  static const Color _tertiary = Color(0xFF745726);
  static const Color _tertiaryContainer = Color(0xFF8F6F3C);
  static const Color _onSurface = Color(0xFF1B1C1A);
  static const Color _onSurfaceVariant = Color(0xFF54433C);
  static const Color _surfaceContainerLow = Color(0xFFF4F4F0);
  static const Color _surfaceContainerHighest = Color(0xFFE3E2DF);
  static const Color _outlineVariant = Color(0xFFDAC1B8);
  static const Color _primaryFixed = Color(0xFFFFDBCC);
  static const Color _onPrimaryFixedVariant = Color(0xFF76330F);

  TextStyle _nr(double s, FontWeight w, Color c, {double ls = 0, bool italic = false}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, letterSpacing: ls,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 48),
          child: Column(
            children: [
              _header(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _successHero(),
                    const SizedBox(height: 48),
                    _orderSummaryCard(),
                    const SizedBox(height: 32),
                    _deliveryCard(),
                    const SizedBox(height: 48),
                    _actionButtons(context),
                    const SizedBox(height: 32),
                    _footerNote(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  // HTML: flex justify-between, close (primary) | VELOUR (primary headline) | spacer

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.go(RouteNames.home),
            child: const Icon(Icons.close, size: 24, color: _primary),
          ),
          // HTML: font-headline tracking-[0.2em] text-primary uppercase text-2xl
          Text('VELOUR', style: _nr(24, FontWeight.w500, _primary, ls: 4.8)),
          const SizedBox(width: 24), // spacer for balance
        ],
      ),
    );
  }

  // ── Success Hero ───────────────────────────────────────────────────────────
  // HTML: w-24 h-24 bg-gradient(tertiary→tertiary-container) rounded-full + check icon
  // "Order Placed!" h2 + italic "Thank you, Sarah! 🥳" + order # badge

  Widget _successHero() {
    return Column(
      children: [
        // Gradient circle with check
        Container(
          width: 96, height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_tertiary, _tertiaryContainer],
            ),
            boxShadow: [BoxShadow(color: _tertiary.withValues(alpha: 0.10), blurRadius: 40, offset: const Offset(0, 8))],
          ),
          child: const Icon(Icons.check_rounded, size: 48, color: Colors.white),
        ),
        const SizedBox(height: 32),
        // "Order Placed!" — Newsreader bold 40px
        Text('Order Placed!', style: _nr(40, FontWeight.w700, _onSurface, ls: -1.0)),
        const SizedBox(height: 12),
        // Italic "Thank you" — Newsreader 20px italic
        Text('Thank you, Sarah! 🥳', style: _nr(20, FontWeight.w400, _onSurfaceVariant, italic: true)),
        const SizedBox(height: 16),
        // Order # badge — bg-primary-fixed text-on-primary-fixed-variant rounded-full
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: _primaryFixed, borderRadius: BorderRadius.circular(9999)),
          child: Text(
            '#VLR-20250413',
            style: _bvp(12, FontWeight.w700, _onPrimaryFixedVariant, ls: 2.0),
          ),
        ),
      ],
    );
  }

  // ── Order Summary Card ─────────────────────────────────────────────────────
  // HTML: bg-surface-container-low p-8 rounded-lg

  Widget _orderSummaryCard() {
    final cartItems = AppData.cartItems();

    // Compute real total from cart item prices (strip 'LKR ' and commas)
    double total = 0;
    for (final item in cartItems) {
      final raw = item.price.replaceAll('LKR', '').replaceAll(',', '').trim();
      final value = double.tryParse(raw) ?? 0;
      total += value * item.qty;
    }
    final totalStr = 'LKR ${total.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

    if (cartItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text('Your cart is empty.', style: _bvp(14, FontWeight.w400, _onSurfaceVariant)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ORDER SUMMARY',
              style: _nr(18, FontWeight.w700, _primary, ls: 2.0)),
          const SizedBox(height: 32),
          ...cartItems.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return Padding(
              padding: EdgeInsets.only(bottom: i < cartItems.length - 1 ? 24 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80, height: 96,
                      color: _surfaceContainerHighest,
                      child: Image.network(item.imageUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: _nr(18, FontWeight.w400, _onSurface).copyWith(height: 1.2)),
                        const SizedBox(height: 4),
                        Text('${item.variant} • Qty ${item.qty}',
                            style: _bvp(14, FontWeight.w500, _onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Text(item.price, style: _bvp(15, FontWeight.w700, _onSurface)),
                ],
              ),
            );
          }),
          const SizedBox(height: 32),
          Divider(color: _outlineVariant.withValues(alpha: 0.30), thickness: 1),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Paid', style: _nr(20, FontWeight.w700, _onSurface)),
              Text(totalStr, style: _nr(24, FontWeight.w700, _primary)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Delivery Card ──────────────────────────────────────────────────────────
  // HTML: bg-surface-container-lowest p-8 rounded-lg border border-outline-variant/10

  Widget _deliveryCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outlineVariant.withValues(alpha: 0.10)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + heading row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // bg-tertiary/10 p-3 rounded-full
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _tertiary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.inventory_2_outlined, size: 24, color: _tertiary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ESTIMATED DELIVERY',
                      style: _nr(16, FontWeight.w700, _onSurface, ls: 1.5)),
                  const SizedBox(height: 4),
                  Text('April 18 - 20, 2025',
                      style: _bvp(18, FontWeight.w700, _primary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Shipping address — indent matches pl-[3.75rem]
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SHIPPING ADDRESS',
                    style: _bvp(11, FontWeight.w700, _onSurfaceVariant, ls: 2.0)),
                const SizedBox(height: 8),
                Text(
                  'Sarah Williams\n42nd Couture Avenue, Atelier District,\nColombo 07',
                  style: _bvp(14, FontWeight.w400, _onSurfaceVariant).copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ─────────────────────────────────────────────────────────
  // HTML: "Track My Order" gradient pill + "Continue Shopping" outlined pill

  Widget _actionButtons(BuildContext context) {
    return Column(
      children: [
        // Track My Order — gradient primary→primary-container
        GestureDetector(
          onTap: () => context.go(RouteNames.orders),
          child: Container(
            width: double.infinity, height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_primary, _primaryContainer]),
              borderRadius: BorderRadius.circular(9999),
              boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.20), blurRadius: 20, offset: const Offset(0, 6))],
            ),
            alignment: Alignment.center,
            child: Text('Track My Order', style: _bvp(18, FontWeight.w700, Colors.white)),
          ),
        ),
        const SizedBox(height: 16),
        // Continue Shopping — border outline-variant, text tertiary
        GestureDetector(
          onTap: () => context.go(RouteNames.home),
          child: Container(
            width: double.infinity, height: 64,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: _outlineVariant),
            ),
            alignment: Alignment.center,
            child: Text('Continue Shopping', style: _bvp(18, FontWeight.w700, _tertiary)),
          ),
        ),
      ],
    );
  }

  // ── Footer Note ─────────────────────────────────────────────────────────────
  // HTML: text-xs tracking-[0.2em] uppercase text-on-surface-variant opacity-60

  Widget _footerNote() {
    return Text(
      'Handcrafted Excellence Since 2012',
      textAlign: TextAlign.center,
      style: _bvp(12, FontWeight.w400, _onSurfaceVariant.withValues(alpha: 0.60), ls: 3.0),
    );
  }
}
