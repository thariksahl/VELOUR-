import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_data.dart';
import '../../routes/route_names.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _State();
}

class _State extends State<CartScreen> {
  // HTML tokens
  static const Color _surface = Color(0xFFFAF9F5);
  static const Color _primary = Color(0xFF914722);
  static const Color _tertiary = Color(0xFF745726);
  static const Color _onSurface = Color(0xFF1B1C1A);
  static const Color _onSurfaceVariant = Color(0xFF54433C);
  static const Color _surfaceContainerLow = Color(0xFFF4F4F0);
  static const Color _outlineVariant = Color(0xFFDAC1B8);

  final _promoController = TextEditingController();
  int _navIndex = 3; // CART active

  final List<CartItem> _items = AppData.cartItems();
  bool _isEditing = false;

  TextStyle _nr(double s, FontWeight w, Color c, {bool italic = false, double ls = 0}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, fontStyle: italic ? FontStyle.italic : FontStyle.normal, letterSpacing: ls);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  double _parsePrice(String priceStr) {
    final numStr = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numStr) ?? 0.0;
  }

  String _formatPrice(double val) {
    final parts = val.toStringAsFixed(2).split('.');
    String intPart = parts[0];
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    intPart = intPart.replaceAll(reg, ',');
    return 'LKR $intPart.${parts[1]}';
  }

  @override
  void dispose() { _promoController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Column(
        children: [
          _header(context),
          // Divider
          Container(height: 1, color: _surfaceContainerLow),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 40, 24, 80 + MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cartItems(),
                  const SizedBox(height: 32),
                  _promoCode(),
                  const SizedBox(height: 32),
                  _orderSummary(),
                  const SizedBox(height: 16),
                  _checkoutButton(context),
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
  // HTML: sticky, bg-[#faf9f5], flex justify-between, px-8 py-6
  // Left: back circle + "My Cart" italic Newsreader | Right: "Edit" primary text

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
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go(RouteNames.home),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                  ),
                  child: const Icon(Icons.arrow_back, size: 18, color: Colors.black),
                ),
              ),
              const SizedBox(width: 16),
              // HTML: font-serif italic text-2xl tracking-tight
              Text('My Cart', style: _nr(24, FontWeight.w600, _onSurface, italic: true, ls: -0.5)),
            ],
          ),
          // HTML: text-[#914722] font-semibold
          GestureDetector(
            onTap: () => setState(() => _isEditing = !_isEditing),
            child: Text(_isEditing ? 'Done' : 'Edit', style: _bvp(16, FontWeight.w600, _primary)),
          ),
        ],
      ),
    );
  }

  // ── Cart Items ─────────────────────────────────────────────────────────────
  // HTML: bg-surface-container-lowest rounded-lg p-5 flex gap-5 items-center border

  Widget _cartItems() {
    return Column(
      children: _items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return Container(
          margin: EdgeInsets.only(bottom: i < _items.length - 1 ? 16 : 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _outlineVariant.withOpacity(0.10)),
            boxShadow: [BoxShadow(color: const Color(0xFF1B1C1A).withOpacity(0.02), blurRadius: 24, offset: const Offset(0, 4))],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product image — w-24 h-28 rounded-md
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 96, height: 112,
                  child: Image.network(item.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200)),
                ),
              ),
              const SizedBox(width: 20),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: _nr(18, FontWeight.w600, _onSurface)),
                    const SizedBox(height: 2),
                    Text(item.variant, style: _bvp(14, FontWeight.w400, _onSurfaceVariant)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatPrice(_parsePrice(item.price) * item.qty), style: _bvp(15, FontWeight.w600, _primary)),
                        // Qty stepper — bg-surface-container-low px-3 py-1 rounded-full
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: _surfaceContainerLow, borderRadius: BorderRadius.circular(9999)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() { if (item.qty > 1) item.qty--; }),
                                child: const Icon(Icons.remove, size: 16, color: _tertiary),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('${item.qty}', style: _bvp(14, FontWeight.w700, _onSurface)),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => item.qty++),
                                child: const Icon(Icons.add, size: 16, color: _tertiary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isEditing)
                GestureDetector(
                  onTap: () => setState(() => _items.removeAt(i)),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(Icons.delete_outline, color: Color.fromARGB(255, 29, 29, 28)),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Promo Code ─────────────────────────────────────────────────────────────

  Widget _promoCode() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _promoController,
            style: _bvp(15, FontWeight.w400, _onSurface),
            decoration: InputDecoration(
              hintText: 'Enter promo code',
              hintStyle: _bvp(15, FontWeight.w400, _onSurfaceVariant),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _outlineVariant.withOpacity(0.20))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _outlineVariant.withOpacity(0.20))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.center,
          child: Text('Apply', style: _bvp(15, FontWeight.w600, Colors.white)),
        ),
      ],
    );
  }

  // ── Order Summary ──────────────────────────────────────────────────────────

  Widget _orderSummary() {
    final subtotal = _items.fold(0.0, (sum, item) => sum + _parsePrice(item.price) * item.qty);
    final total = subtotal; // discount and delivery are 0
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outlineVariant.withOpacity(0.10)),
        boxShadow: [BoxShadow(color: const Color(0xFF1B1C1A).withOpacity(0.03), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: _nr(24, FontWeight.w400, _onSurface)),
          const SizedBox(height: 24),
          _summaryRow('Subtotal', _formatPrice(subtotal)),
          const SizedBox(height: 16),
          _summaryRow('Discount', '-LKR 0.00', valueColor: _primary),
          const SizedBox(height: 16),
          _summaryRow('Delivery', 'LKR 0.00'),
          const SizedBox(height: 24),
          Divider(color: _outlineVariant.withOpacity(0.20), thickness: 1),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: _bvp(18, FontWeight.w600, _onSurface)),
              Text(_formatPrice(total), style: _bvp(24, FontWeight.w700, _tertiary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: _bvp(15, FontWeight.w400, _onSurfaceVariant)),
      Text(value, style: _bvp(15, FontWeight.w400, valueColor ?? _onSurfaceVariant)),
    ],
  );

  // ── Checkout Button ─────────────────────────────────────────────────────────
  // HTML: btn-primary-gradient = linear-gradient(to right, #914722, #af5f38) rounded-full py-5

  Widget _checkoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.orderConfirmation),
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF914722), Color(0xFFAF5F38)]),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [BoxShadow(color: const Color(0xFF914722).withOpacity(0.20), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        alignment: Alignment.center,
        child: Text('Proceed to Checkout', style: _bvp(18, FontWeight.w600, Colors.white, ls: 0.3)),
      ),
    );
  }

  // ── Bottom Nav — CART active ────────────────────────────────────────────────

  Widget _bottomNav(BuildContext context) {
    const items = [
      (Icons.home_outlined, Icons.home, 'HOME'),
      (Icons.search, Icons.search, 'EXPLORE'),
      (Icons.favorite_outline, Icons.favorite, 'FAVOURITE'),
      (Icons.shopping_cart_outlined, Icons.shopping_cart, 'CART'),
      (Icons.person_outline, Icons.person, 'PROFILE'),
    ];
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F3F3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == _navIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _navIndex = i);
              switch (i) {
                case 0: context.go(RouteNames.home); break;
                case 1: context.go(RouteNames.explore); break;
                case 2: context.go(RouteNames.wishlist); break;
                case 3: break;
                case 4: context.go(RouteNames.profile); break;
              }
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 64,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(active ? items[i].$2 : items[i].$1, size: 24,
                    color: active ? Colors.black : Colors.grey.shade400),
                const SizedBox(height: 4),
                Text(items[i].$3,
                    style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.w700,
                        color: active ? Colors.black : Colors.grey.shade400, letterSpacing: 0.8)),
              ]),
            ),
          );
        }),
      ),
    );
  }
}
