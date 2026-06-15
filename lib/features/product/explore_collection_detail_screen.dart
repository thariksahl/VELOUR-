import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../data/app_data.dart';
import '../../routes/route_names.dart';
import '../wishlist/favourites_provider.dart';
import '../cart/cart_provider.dart';

// ── Inline collection data ────────────────────────────────────────────────────

class _CI {
  final String title, subtitle, imageUrl, price, description, relatedCategory;
  final double rating;
  final int reviews;
  final List<Color> colors;
  final List<String> colorNames, thumbnails;
  const _CI({
    required this.title, required this.subtitle, required this.imageUrl,
    required this.price, required this.rating, required this.reviews,
    required this.description, required this.relatedCategory,
    required this.colors, required this.colorNames, required this.thumbnails,
  });
}

final _collections = <_CI>[
  const _CI(
    title: 'Denim & Jeans', subtitle: 'HERITAGE INDIGO',
    imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
    price: 'LKR 8,400', rating: 4.2, reviews: 128,
    description: 'Classic denim crafted from premium heritage indigo cotton. '
        'Featuring authentic fading, copper rivets, and timeless silhouettes '
        'that pair effortlessly with any outfit in your wardrobe.',
    relatedCategory: 'Jeans',
    colors: [Color(0xFF2E4DA7), Color(0xFF111111), Color(0xFFB0C4DE), Color(0xFF7D5B3F)],
    colorNames: ['Indigo', 'Black', 'Light Wash', 'Brown'],
    thumbnails: [
      'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400',
      'https://images.unsplash.com/photo-1555689502-c4b22d76c56f?w=400',
    ],
  ),
  const _CI(
    title: 'Tailored Classics', subtitle: 'PRECISION CUTS',
    imageUrl: 'https://images.unsplash.com/photo-1594938298598-70f70f666752?w=800',
    price: 'LKR 15,750', rating: 4.3, reviews: 84,
    description: 'Expertly tailored shirts with precision cuts and premium fabrics. '
        'Polished enough for the office, relaxed enough for the weekend — '
        'the perfect foundation for a modern wardrobe.',
    relatedCategory: 'Shirts',
    colors: [Color(0xFFF5F5F5), Color(0xFF1A2A5A), Color(0xFF87CEEB), Color(0xFF4A4A4A)],
    colorNames: ['White', 'Navy', 'Sky Blue', 'Graphite'],
    thumbnails: [
      'https://images.unsplash.com/photo-1594938298598-70f70f666752?w=400',
      'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=400',
      'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
    ],
  ),
  const _CI(
    title: 'Outerwear', subtitle: 'THE SEASONAL COAT',
    imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800',
    price: 'LKR 28,500', rating: 4.5, reviews: 96,
    description: 'Statement outerwear crafted for every season. From classic '
        'trench coats to tailored blazers — each piece elevates your look '
        'and keeps you comfortable through changing weather.',
    relatedCategory: 'Outerwear',
    colors: [Color(0xFFC19A6B), Color(0xFF111111), Color(0xFF6B7C3D), Color(0xFF1A2A5A)],
    colorNames: ['Camel', 'Black', 'Olive', 'Navy'],
    thumbnails: [
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400',
      'https://images.unsplash.com/photo-1520975954732-35dd22299614?w=400',
    ],
  ),
  const _CI(
    title: 'Summer Edit', subtitle: 'EFFORTLESS ELEGANCE',
    imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800',
    price: 'LKR 12,200', rating: 4.0, reviews: 210,
    description: 'Light, breathable pieces designed for warm days and long evenings. '
        'Our Summer Edit blends effortless silhouettes with natural fabrics '
        'for a look that\'s relaxed yet refined.',
    relatedCategory: 'Summer',
    colors: [Color(0xFFF5F5F5), Color(0xFFFF6B6B), Color(0xFFFFC107), Color(0xFF8FAD88)],
    colorNames: ['White', 'Coral', 'Lemon', 'Sage'],
    thumbnails: [
      'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
      'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=400',
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ExploreCollectionDetailScreen extends StatefulWidget {
  final int collectionIndex;
  const ExploreCollectionDetailScreen({super.key, required this.collectionIndex});

  @override
  State<ExploreCollectionDetailScreen> createState() =>
      _ExploreCollectionDetailScreenState();
}

class _ExploreCollectionDetailScreenState
    extends State<ExploreCollectionDetailScreen> {
  static const _terracotta = Color(0xFFC1633A);

  late _CI _col;
  int _selectedColor = 0;
  int _selectedSize = 2; // M
  int _qty = 1;
  bool _descExpanded = false;
  int _activeThumb = 0;
  int _navIndex = 1; // Explore

  final _sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _col = _collections[widget.collectionIndex.clamp(0, _collections.length - 1)];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F0EB);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textMuted = isDark ? Colors.white54 : const Color(0xFF6B6560);
    final cardBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroImage(context),
                _thumbnailRow(cardBg),
                _productInfo(context, textPrimary, textMuted, cardBg, isDark),
                _colorSection(textPrimary, textMuted),
                _sizeSection(textPrimary, textMuted, cardBg),
                _descSection(textPrimary, textMuted),
                _relatedSection(context, textPrimary, textMuted, cardBg),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(top: 0, left: 0, right: 0,
              child: _topBar(context, isDark, textPrimary)),
          Positioned(bottom: 0, left: 0, right: 0,
              child: _bottomBar(context, botPad, cardBg)),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  // ── Top Bar ─────────────────────────────────────────────────────────────────

  Widget _topBar(BuildContext context, bool isDark, Color textColor) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, topPad + 8, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.35), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          _circleBtn(
            child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
            onTap: () => context.canPop() ? context.pop() : context.go(RouteNames.explore),
          ),
          const Spacer(),
          Text('VELOUR', style: GoogleFonts.newsreader(
            fontSize: 20, fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic, letterSpacing: 4.0, color: Colors.white,
          )),
          const Spacer(),
          Consumer<FavouritesProvider>(builder: (ctx, favs, _) {
            final p = Product(name: _col.title, price: _col.price, imageUrl: _col.imageUrl);
            final isFav = favs.isFavourited(p);
            return _circleBtn(
              child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                  size: 20, color: isFav ? _terracotta : Colors.white),
              onTap: () => favs.toggleFavourite(p),
            );
          }),
        ],
      ),
    );
  }

  Widget _circleBtn({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }

  // ── Hero Image ───────────────────────────────────────────────────────────────

  Widget _heroImage(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.52;
    final imgUrl = _activeThumb < _col.thumbnails.length
        ? _col.thumbnails[_activeThumb]
        : _col.imageUrl;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: SizedBox(
        width: double.infinity, height: h,
        child: Image.network(imgUrl, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300)),
      ),
    );
  }

  // ── Thumbnail Row ────────────────────────────────────────────────────────────

  Widget _thumbnailRow(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: List.generate(_col.thumbnails.length, (i) {
          final active = i == _activeThumb;
          return GestureDetector(
            onTap: () => setState(() => _activeThumb = i),
            child: Container(
              width: 64, height: 64,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: active ? _terracotta : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(_col.thumbnails[i], fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200)),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Product Info ─────────────────────────────────────────────────────────────

  Widget _productInfo(BuildContext context, Color textPrimary, Color textMuted,
      Color cardBg, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Name + Price row
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(_col.title,
              style: GoogleFonts.newsreader(
                  fontSize: 26, fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic, color: textPrimary))),
          const SizedBox(width: 8),
          Text(_col.price, style: GoogleFonts.beVietnamPro(
              fontSize: 22, fontWeight: FontWeight.w800, color: _terracotta)),
        ]),
        const SizedBox(height: 4),
        // Subtitle
        Text(_col.subtitle, style: GoogleFonts.beVietnamPro(
            fontSize: 11, fontWeight: FontWeight.w700,
            letterSpacing: 2.0, color: textMuted)),
        const SizedBox(height: 12),
        // Star rating
        Row(children: [
          ...List.generate(5, (i) => Icon(
            i < _col.rating.floor()
                ? Icons.star_rounded
                : (i < _col.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
            size: 18, color: const Color(0xFFFFC107),
          )),
          const SizedBox(width: 6),
          Text('${_col.rating}', style: GoogleFonts.beVietnamPro(
              fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(width: 4),
          Text('· ${_col.reviews} reviews', style: GoogleFonts.beVietnamPro(
              fontSize: 13, color: textMuted)),
        ]),
      ]),
    );
  }

  // ── Color Section ────────────────────────────────────────────────────────────

  Widget _colorSection(Color textPrimary, Color textMuted) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Color', style: GoogleFonts.beVietnamPro(
              fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(width: 8),
          Text(_col.colorNames[_selectedColor], style: GoogleFonts.beVietnamPro(
              fontSize: 14, color: textMuted)),
        ]),
        const SizedBox(height: 12),
        Row(children: List.generate(_col.colors.length, (i) {
          final active = i == _selectedColor;
          return GestureDetector(
            onTap: () => setState(() => _selectedColor = i),
            child: Container(
              width: 38, height: 38,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? _terracotta : Colors.grey.shade300,
                  width: active ? 2.5 : 1.0,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: _col.colors[i],
                ),
              ),
            ),
          );
        })),
      ]),
    );
  }

  // ── Size Section ─────────────────────────────────────────────────────────────

  Widget _sizeSection(Color textPrimary, Color textMuted, Color cardBg) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Size', style: GoogleFonts.beVietnamPro(
            fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: List.generate(_sizes.length, (i) {
            final active = i == _selectedSize;
            return GestureDetector(
              onTap: () => setState(() => _selectedSize = i),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: active ? _terracotta : cardBg,
                  border: active ? null : Border.all(color: Colors.grey.shade300),
                ),
                child: Text(_sizes[i], style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? Colors.white : textMuted)),
              ),
            );
          })),
        ),
      ]),
    );
  }

  // ── Description Section ──────────────────────────────────────────────────────

  Widget _descSection(Color textPrimary, Color textMuted) {
    const maxChars = 100;
    final isLong = _col.description.length > maxChars;
    final shown = _descExpanded || !isLong
        ? _col.description
        : '${_col.description.substring(0, maxChars)}...';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Description', style: GoogleFonts.beVietnamPro(
            fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
        const SizedBox(height: 10),
        Text(shown, style: GoogleFonts.beVietnamPro(
            fontSize: 14, color: textMuted, height: 1.6)),
        if (isLong) ...[
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _descExpanded = !_descExpanded),
            child: Text(_descExpanded ? 'Read less' : 'Read more',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 13, fontWeight: FontWeight.w700, color: _terracotta)),
          ),
        ],
      ]),
    );
  }

  // ── Related Products ─────────────────────────────────────────────────────────

  Widget _relatedSection(BuildContext context, Color textPrimary,
      Color textMuted, Color cardBg) {
    final related = AppData.products()
        .where((p) => p.category == _col.relatedCategory)
        .take(6)
        .toList();
    if (related.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
        child: Text('You May Also Like', style: GoogleFonts.newsreader(
            fontSize: 20, fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic, color: textPrimary)),
      ),
      SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: related.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (ctx, i) {
            final p = related[i];
            return GestureDetector(
              onTap: () => context.push(RouteNames.productDetailExtra, extra: p),
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                    color: cardBg, borderRadius: BorderRadius.circular(16)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(p.imageUrl,
                        width: 130, height: 130, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(width: 130, height: 130, color: Colors.grey.shade200)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(p.name, maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 11, fontWeight: FontWeight.w700,
                              color: textPrimary)),
                      const SizedBox(height: 2),
                      Text(p.price, style: GoogleFonts.beVietnamPro(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: _terracotta)),
                    ]),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
    ]);
  }

  // ── Bottom Action Bar ────────────────────────────────────────────────────────

  Widget _bottomBar(BuildContext context, double botPad, Color cardBg) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + botPad),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12, offset: const Offset(0, -4)),
        ],
      ),
      child: Row(children: [
        // Quantity selector
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            _qtyBtn(Icons.remove, () {
              if (_qty > 1) setState(() => _qty--);
            }),
            SizedBox(
              width: 36,
              child: Text('$_qty', textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            _qtyBtn(Icons.add, () => setState(() => _qty++)),
          ]),
        ),
        const SizedBox(width: 14),
        // Add to Cart
        Expanded(
          child: Consumer<CartProvider>(builder: (ctx, cart, _) {
            return GestureDetector(
              onTap: () {
                final size = _sizes[_selectedSize];
                final colorName = _col.colorNames[_selectedColor];
                for (var i = 0; i < _qty; i++) {
                  cart.addItem(CartItem(
                    _col.title,
                    '$colorName • $size',
                    _col.price,
                    _col.thumbnails[_activeThumb],
                  ));
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added to cart!',
                      style: GoogleFonts.beVietnamPro(color: Colors.white)),
                  backgroundColor: const Color(0xFF1A1A1A),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ));
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: _terracotta,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(color: _terracotta.withValues(alpha: 0.35),
                        blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const Icon(Icons.shopping_bag_outlined,
                      size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Add to Cart', style: GoogleFonts.beVietnamPro(
                      fontSize: 15, fontWeight: FontWeight.w800,
                      color: Colors.white)),
                ]),
              ),
            );
          }),
        ),
      ]),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 44,
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: const Color(0xFF1A1A1A)),
      ),
    );
  }
}
