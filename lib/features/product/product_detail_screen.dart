import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route_names.dart';
import '../../data/app_data.dart';
import '../../core/services/firestore_service.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  /// When navigating via the new `/product-detail` route, pass the product directly.
  final Product? product;
  /// Legacy: when navigating via `/products/:id`, pass the string index.
  final String? productId;
  const ProductDetailScreen({super.key, this.product, this.productId});

  @override
  State<ProductDetailScreen> createState() => _State();
}

class _State extends State<ProductDetailScreen> {
  static const Color _bg = Color(0xFFF0EDE6);
  static const Color _dark = Color(0xFF111111);
  static const Color _burntOrange = Color(0xFFC1622A);

  final _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  int _selectedSize = 2; // 'M' by default
  int _selectedColor = 0;

  Product? get _product {
    // Prefer the directly-passed product object (Firestore path).
    if (widget.product != null) return widget.product;
    // Fallback: legacy index-based lookup from local AppData.
    if (widget.productId == null) return null;
    final index = int.tryParse(widget.productId!);
    if (index == null || index < 0 || index >= AppData.products().length) return null;
    return AppData.products()[index];
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.55;

    final product = _product;
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found')),
      );
    }

    String imageUrl = product.imageUrl;
    if (product.colorVariants.isNotEmpty && _selectedColor < product.colorVariants.length) {
      imageUrl = product.colorVariants[_selectedColor].imageUrl;
    }

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Scrollable Content ──────────────────────────────────────────
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 120 + botPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full width Product Image
                SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
                  ),
                ),

                // Info Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name & Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: _dark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product.price,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: _burntOrange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        product.description.isNotEmpty
                            ? product.description
                            : "Premium quality fabric, modern fit. Perfect for everyday wear.",
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Color selector row
                      Text(
                        'COLORS',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(product.colorVariants.length, (i) {
                          final active = i == _selectedColor;
                          final variant = product.colorVariants[i];
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = i),
                            child: Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(right: 14),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: active
                                    ? Border.all(color: _burntOrange, width: 2.0)
                                    : Border.all(color: Colors.grey.shade400, width: 1.0),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: variant.color,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 28),

                      // Size pills selector
                      Text(
                        'SELECT SIZE',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_sizes.length, (i) {
                            final active = i == _selectedSize;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSize = i),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: active ? _burntOrange : Colors.white,
                                  border: active ? null : Border.all(color: Colors.grey.shade300),
                                ),
                                child: Text(
                                  _sizes[i],
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: isActiveFontWeight(active),
                                    color: active ? Colors.white : _dark,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Fixed Top Header ─────────────────────────────────────────────
          Positioned(
            top: topPad + 12,
            left: 16,
            child: GestureDetector(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.home);
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.90),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, size: 20, color: _dark),
              ),
            ),
          ),

          // ── Fixed Bottom Actions ─────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + botPad),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                border: const Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 1.0)),
              ),
              child: _AddToCartButton(
                color: _burntOrange,
                onAdd: () {
                  final colorName = product.colorVariants.isNotEmpty && _selectedColor < product.colorVariants.length
                      ? product.colorVariants[_selectedColor].name
                      : 'Standard';
                  final size = _sizes[_selectedSize];
                  final cartItem = CartItem(
                    product.name,
                    '$colorName • $size',
                    product.price,
                    imageUrl,
                  );
                  // Persist to Firestore — the CartScreen StreamBuilder picks it up instantly
                  FirestoreService.instance.addToCart(cartItem);
                  _showToastThenNavigate();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  FontWeight isActiveFontWeight(bool active) {
    return active ? FontWeight.w800 : FontWeight.w600;
  }

  void _showToastThenNavigate() {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 280),
    );

    entry = OverlayEntry(
      builder: (ctx) => _ToastOverlay(controller: controller),
    );

    overlay.insert(entry);
    controller.forward();

    Future.delayed(const Duration(milliseconds: 600), () async {
      await controller.reverse();
      entry.remove();
      controller.dispose();
      if (mounted) _pushCartScreen();
    });
  }

  void _pushCartScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => const CartScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final primarySlide = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-0.30, 0.0),
          ).animate(CurvedAnimation(
              parent: secondaryAnimation, curve: Curves.easeInOut));

          final cartSlide = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: animation, curve: Curves.easeInOut));

          return Stack(
            children: [
              SlideTransition(
                position: primarySlide,
                child: Container(color: const Color(0xFFF0EDE6)),
              ),
              SlideTransition(
                position: cartSlide,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Add to Cart Button ────────────────────────────────────────────────────────

class _AddToCartButton extends StatefulWidget {
  final Color color;
  final VoidCallback onAdd;
  const _AddToCartButton({required this.color, required this.onAdd});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.98)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
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
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onAdd();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Add to Cart',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Toast Overlay ────────────────────────────────────────────────────────────

class _ToastOverlay extends StatelessWidget {
  final AnimationController controller;
  const _ToastOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: slideAnim,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(top: topPad > 0 ? 8 : 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: const Color(0xFFC1622A).withValues(alpha: 0.60),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.30),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFC1622A),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Added to cart',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
