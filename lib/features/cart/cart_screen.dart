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
  // Design tokens
  static const Color _surface = Color(0xFFFAF9F5);
  static const Color _primary = Color(0xFF914722);
  static const Color _tertiary = Color(0xFF745726);
  static const Color _onSurface = Color(0xFF1B1C1A);
  static const Color _onSurfaceVariant = Color(0xFF54433C);
  static const Color _surfaceContainerLow = Color(0xFFF4F4F0);
  static const Color _outlineVariant = Color(0xFFDAC1B8);

  final _promoController = TextEditingController();

  late List<CartItem> _items;
  bool _isEditing = false;

  TextStyle _nr(double s, FontWeight w, Color c,
          {bool italic = false, double ls = 0}) =>
      GoogleFonts.newsreader(
          fontSize: s,
          fontWeight: w,
          color: c,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: ls);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(
          fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

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
  void initState() {
    super.initState();
    // Take a live reference so qty changes reflect globally
    _items = AppData.cartItems();
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  // ── Back navigation — pop if pushed, else GoRouter ─────────────────────────
  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Column(
        children: [
          _header(context),
          Container(height: 1, color: _surfaceContainerLow),
          Expanded(
            child: _items.isEmpty ? _emptyCart() : _cartList(context),
          ),
        ],
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────
  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text('Your cart is empty',
              style: _nr(22, FontWeight.w500, Colors.grey.shade500,
                  italic: true)),
          const SizedBox(height: 8),
          Text('Add items to get started',
              style: _bvp(14, FontWeight.w400, Colors.grey.shade400)),
        ],
      ),
    );
  }

  // ── Scrollable cart list ────────────────────────────────────────────────────
  Widget _cartList(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          24, 32, 24, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cartItems(),
          const SizedBox(height: 32),
          _promoCode(),
          const SizedBox(height: 32),
          _orderSummary(),
          const SizedBox(height: 24),
          _checkoutButton(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _header(BuildContext context) {
    return Container(
      color: _surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 32,
        right: 32,
        bottom: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _goBack(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4)
                    ],
                  ),
                  child: const Icon(Icons.arrow_back,
                      size: 18, color: Colors.black),
                ),
              ),
              const SizedBox(width: 16),
              Text('My Cart',
                  style: _nr(24, FontWeight.w600, _onSurface,
                      italic: true, ls: -0.5)),
            ],
          ),
          GestureDetector(
            onTap: () => setState(() => _isEditing = !_isEditing),
            child: Text(_isEditing ? 'Done' : 'Edit',
                style: _bvp(16, FontWeight.w600, _primary)),
          ),
        ],
      ),
    );
  }

  // ── Cart Items ─────────────────────────────────────────────────────────────
  Widget _cartItems() {
    return Column(
      children: _items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(bottom: i < _items.length - 1 ? 16 : 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: _outlineVariant.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF1B1C1A).withValues(alpha: 0.02),
                  blurRadius: 24,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 96,
                  height: 112,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey.shade200),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: _nr(17, FontWeight.w600, _onSurface),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text(item.variant,
                        style:
                            _bvp(13, FontWeight.w400, _onSurfaceVariant)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatPrice(
                              _parsePrice(item.price) * item.qty),
                          style: _bvp(15, FontWeight.w600, _primary),
                        ),
                        // Quantity stepper
                        _quantityStepper(item),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isEditing)
                GestureDetector(
                  onTap: () =>
                      setState(() => AppData.cartItems().removeAt(i)),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(Icons.delete_outline,
                        color: Color(0xFF1D1D1C)),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _quantityStepper(CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperButton(
            icon: Icons.remove,
            onTap: () {
              if (item.qty > 1) setState(() => item.qty--);
            },
          ),
          SizedBox(
            width: 32,
            child: Center(
              child: Text('${item.qty}',
                  style: _bvp(14, FontWeight.w700, _onSurface)),
            ),
          ),
          _stepperButton(
            icon: Icons.add,
            onTap: () => setState(() => item.qty++),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 1))
          ],
        ),
        child: Icon(icon, size: 14, color: _tertiary),
      ),
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
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: _outlineVariant.withValues(alpha: 0.20))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: _outlineVariant.withValues(alpha: 0.20))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primary)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
              color: _primary, borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.center,
          child:
              Text('Apply', style: _bvp(15, FontWeight.w600, Colors.white)),
        ),
      ],
    );
  }

  // ── Order Summary ──────────────────────────────────────────────────────────
  Widget _orderSummary() {
    final subtotal = _items.fold(
        0.0, (sum, item) => sum + _parsePrice(item.price) * item.qty);
    const shippingThreshold = 5000.0;
    final shipping =
        subtotal >= shippingThreshold ? 0.0 : 350.0; // Free over 5000
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outlineVariant.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1B1C1A).withValues(alpha: 0.03),
              blurRadius: 32,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary',
              style: _nr(22, FontWeight.w400, _onSurface)),
          const SizedBox(height: 24),
          _summaryRow('Subtotal', _formatPrice(subtotal)),
          const SizedBox(height: 14),
          _summaryRow(
            'Shipping',
            shipping == 0.0 ? 'FREE' : _formatPrice(shipping),
            valueColor: shipping == 0.0 ? const Color(0xFF22A06B) : null,
          ),
          if (shipping != 0.0) ...[
            const SizedBox(height: 6),
            Text(
              'Free shipping on orders over ${_formatPrice(shippingThreshold)}',
              style: _bvp(11, FontWeight.w400, Colors.grey.shade400),
            ),
          ],
          const SizedBox(height: 20),
          Divider(
              color: _outlineVariant.withValues(alpha: 0.25), thickness: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: _bvp(18, FontWeight.w600, _onSurface)),
              Text(_formatPrice(total),
                  style: _bvp(22, FontWeight.w700, _tertiary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: _bvp(14, FontWeight.w400, _onSurfaceVariant)),
          Text(value,
              style: _bvp(14, FontWeight.w500,
                  valueColor ?? _onSurfaceVariant)),
        ],
      );

  // ── Checkout Button ─────────────────────────────────────────────────────────
  Widget _checkoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.orderConfirmation),
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF914722), Color(0xFFAF5F38)]),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF914722).withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Proceed to Checkout',
                style: _bvp(17, FontWeight.w600, Colors.white, ls: 0.3)),
          ],
        ),
      ),
    );
  }
}
