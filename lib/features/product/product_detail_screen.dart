import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route_names.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId;
  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _State();
}

class _State extends State<ProductDetailScreen> {
  // HTML design tokens
  static const Color _bg = Color(0xFFF9F9F7);
  static const Color _primary = Color(0xFF8C4B27);
  static const Color _dark = Color(0xFF1A1A1A);
  static const Color _surfaceVariant = Color(0xFFF2F2F0);
  static const Color _outline = Color(0xFFD1D1D1);

  final _sizes = ['M', 'L', 'XL', 'XXL'];
  int _selectedSize = 0;
  int _selectedColor = 0;

  final _colors = [
    const Color(0xFFA5C7E1), // Light Blue (selected)
    const Color(0xFF1A3A5F), // Dark Blue
    const Color(0xFF222222), // Black
  ];

  TextStyle _nr(double size, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.newsreader(
          fontSize: size, fontWeight: w, color: c, letterSpacing: ls);

  TextStyle _bvp(double size, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(
          fontSize: size, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Scrollable content ──────────────────────────────────────────
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 64 + topPad, bottom: 110 + botPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _productImage(context),
                _productDetails(context),
              ],
            ),
          ),

          // ── Fixed header ────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _header(topPad),
          ),

          // ── Fixed bottom actions ────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _bottomActions(botPad),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  // HTML: fixed, bg-[#F9F9F7]/95 backdrop-blur, flex justify-between, px-5 py-4

  Widget _header(double topPad) {
    return Container(
      padding:
          EdgeInsets.only(top: topPad + 12, left: 20, right: 20, bottom: 12),
      color: _bg.withOpacity(0.95),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteNames.home);
              }
            },
            child: const Icon(Icons.arrow_back, size: 24, color: _dark),
          ),
          // HTML: font-headline tracking-[0.25em] font-medium text-2xl
          Text('VELOUR', style: _nr(24, FontWeight.w500, _dark, ls: 6.0)),
          GestureDetector(
            onTap: () => context.go(RouteNames.cart),
            child:
                const Icon(Icons.shopping_bag_outlined, size: 24, color: _dark),
          ),
        ],
      ),
    );
  }

  // ── Product Image ──────────────────────────────────────────────────────────
  // HTML: aspect-[4/5] bg-[#D9D9D9] rounded-b-[2.5rem] with 3 pagination dots

  Widget _productImage(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = w * (5 / 4);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: SizedBox(
        width: w,
        height: h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: const Color(0xFFD9D9D9)),
            Image.network(
              'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?q=80&w=800&auto=format&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            // Pagination dots — bottom-6 centered
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (i) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == 0
                                ? _primary
                                : Colors.white.withOpacity(0.50),
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Product Details ────────────────────────────────────────────────────────

  Widget _productDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Casual Shirt',
                        style: _nr(28, FontWeight.w700, _dark)),
                    const SizedBox(height: 4),
                    // Stars
                    Row(
                      children: List.generate(
                          5,
                          (_) => const Icon(Icons.star_rounded,
                              size: 18, color: _primary)),
                    ),
                    const SizedBox(height: 4),
                    Text('Rating & Reviews',
                        style: _bvp(11, FontWeight.w500, Colors.grey.shade500)),
                  ],
                ),
              ),
              Text('LKR 5999.99',
                  style: _bvp(22, FontWeight.w700, _dark, ls: -0.5)),
            ],
          ),

          const SizedBox(height: 24),

          // Free delivery badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
                color: _surfaceVariant,
                borderRadius: BorderRadius.circular(9999)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_shipping_outlined,
                    size: 22, color: _primary),
                const SizedBox(width: 12),
                Text('Free delivery', style: _bvp(14, FontWeight.w500, _dark)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            'Discover effortless elegance with our signature piece. Crafted from premium breathable fabrics, this essential combines modern tailoring with timeless comfort for an elevated daily ensemble.',
            style: _bvp(15, FontWeight.w400, Colors.grey.shade600)
                .copyWith(height: 1.6),
          ),

          const SizedBox(height: 28),

          // Colors
          Text('COLORS',
              style: _bvp(12, FontWeight.w700, Colors.grey.shade500, ls: 2.0)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_colors.length, (i) {
              final active = i == _selectedColor;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = i),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // active: border-[1.5px] border-primary p-[3px]
                    border:
                        active ? Border.all(color: _primary, width: 1.5) : null,
                  ),
                  padding: active ? const EdgeInsets.all(3) : EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: _colors[i]),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 28),

          // Size
          Text('SELECT SIZE',
              style: _bvp(12, FontWeight.w700, Colors.grey.shade500, ls: 2.0)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_sizes.length, (i) {
              final active = i == _selectedSize;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = i),
                child: Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? _primary : Colors.white,
                    border: active ? null : Border.all(color: _outline),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _sizes[i],
                    style: _bvp(18, active ? FontWeight.w700 : FontWeight.w500,
                        active ? Colors.white : _dark),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Bottom Actions ─────────────────────────────────────────────────────────
  // HTML: fixed bottom, px-6 py-6 bg-background/80 backdrop-blur-lg
  // — w-16 h-16 circle bag icon + flex-1 h-16 #1A1A1A pill "Add to Cart"

  Widget _bottomActions(double botPad) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + botPad),
      decoration: BoxDecoration(color: _bg.withOpacity(0.80)),
      child: Row(
        children: [
          // Bag circle
          GestureDetector(
            onTap: () => context.go(RouteNames.cart),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: _outline),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: const Icon(Icons.shopping_bag_outlined,
                  size: 24, color: _dark),
            ),
          ),

          const SizedBox(width: 16),

          // Add to Cart pill
          const Expanded(
            child: _AddToCartButton(dark: _dark),
          ),
        ],
      ),
    );
  }
}

// ── Add to Cart Button (with press animation) ─────────────────────────────────

class _AddToCartButton extends StatefulWidget {
  final Color dark;
  const _AddToCartButton({required this.dark});

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
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: widget.dark,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 24, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Add to Cart',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
