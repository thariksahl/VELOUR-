import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/app_data.dart';
import '../../core/services/firestore_service.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routes/route_names.dart';
import '../wishlist/favourites_provider.dart';
import '../cart/cart_provider.dart';

// ─── Accent colour ────────────────────────────────────────────────────────────
const _terracotta = Color(0xFFC1633A);

// ─────────────────────────────────────────────────────────────────────────────
// FILTER DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _FilterGroup {
  final String label;
  final List<String> options;
  final bool multiSelect; // false = single-select
  const _FilterGroup({
    required this.label,
    required this.options,
    this.multiSelect = false,
  });
}

class _FilterConfig {
  final List<_FilterGroup> groups;
  final double maxPrice;
  const _FilterConfig({required this.groups, this.maxPrice = 50000});
}

_FilterConfig _configForTitle(String title) {
  switch (title.toUpperCase()) {
    case 'SHIRTS':
      return const _FilterConfig(groups: [
        _FilterGroup(label: 'Sleeve Type', options: ['Full Sleeve', 'Half Sleeve']),
        _FilterGroup(label: 'Style', options: ['Official', 'Casual']),
        _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'], multiSelect: true),
        _FilterGroup(label: 'Brand', options: ['Zara', 'H&M', "Levi's", 'Nike', 'Adidas', 'Uniqlo'], multiSelect: true),
      ]);
    case 'T-SHIRTS':
      return const _FilterConfig(groups: [
        _FilterGroup(label: 'Sleeve', options: ['Full Sleeve', 'Half Sleeve', 'Sleeveless']),
        _FilterGroup(label: 'Style', options: ['Graphic', 'Plain', 'Oversized']),
        _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'], multiSelect: true),
        _FilterGroup(label: 'Brand', options: ['Zara', 'H&M', 'Nike', 'Adidas', 'Uniqlo'], multiSelect: true),
      ]);
    case 'TROUSERS':
      return const _FilterConfig(groups: [
        _FilterGroup(label: 'Fit', options: ['Slim', 'Regular', 'Wide']),
        _FilterGroup(label: 'Length', options: ['Full', 'Cropped']),
        _FilterGroup(label: 'Size', options: ['28', '30', '32', '34', '36', '38'], multiSelect: true),
        _FilterGroup(label: 'Brand', options: ['Zara', 'H&M', "Levi's", 'Uniqlo'], multiSelect: true),
      ]);
    case 'JACKETS':
      return const _FilterConfig(groups: [
        _FilterGroup(label: 'Type', options: ['Leather', 'Denim', 'Bomber', 'Blazer']),
        _FilterGroup(label: 'Fit', options: ['Slim', 'Regular', 'Oversized']),
        _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'], multiSelect: true),
        _FilterGroup(label: 'Brand', options: ['Zara', 'H&M', 'Adidas', 'Gucci', 'Prada'], multiSelect: true),
      ]);
    case 'SUITS':
      return const _FilterConfig(groups: [
        _FilterGroup(label: 'Fit', options: ['Slim', 'Regular', 'Classic']),
        _FilterGroup(label: 'Pieces', options: ['2 Piece', '3 Piece']),
        _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'], multiSelect: true),
        _FilterGroup(label: 'Brand', options: ['Zara', 'Gucci', 'Prada', 'Uniqlo'], multiSelect: true),
      ]);
    case 'DRESSES':
      return const _FilterConfig(groups: [
        _FilterGroup(label: 'Length', options: ['Mini', 'Midi', 'Maxi']),
        _FilterGroup(label: 'Style', options: ['Casual', 'Party', 'Formal']),
        _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'], multiSelect: true),
        _FilterGroup(label: 'Brand', options: ['Zara', 'H&M', 'Gucci', 'Prada'], multiSelect: true),
      ]);
    case 'SETS':
    case 'TOPS':
      return const _FilterConfig(groups: [
        _FilterGroup(label: 'Style', options: ['Casual', 'Sports', 'Party', 'Formal']),
        _FilterGroup(label: 'Sleeve', options: ['Full Sleeve', 'Half Sleeve', 'Sleeveless']),
        _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'], multiSelect: true),
        _FilterGroup(label: 'Brand', options: ['Zara', 'H&M', 'Nike', 'Uniqlo'], multiSelect: true),
      ]);
    case 'SAREES':
    case 'INNER WEAR':
      return const _FilterConfig(
        groups: [
          _FilterGroup(label: 'Type', options: ['Silk', 'Cotton', 'Georgette', 'Chiffon']),
          _FilterGroup(label: 'Occasion', options: ['Casual', 'Wedding', 'Party', 'Festival']),
          _FilterGroup(label: 'Brand', options: ['Local', 'Premium', 'Designer'], multiSelect: true),
        ],
        maxPrice: 100000,
      );
    case 'GIRLS':
      return const _FilterConfig(
        groups: [
          _FilterGroup(label: 'Age', options: ['2-4Y', '4-6Y', '6-8Y', '8-10Y', '10-12Y']),
          _FilterGroup(label: 'Style', options: ['Casual', 'Party', 'School']),
          _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL'], multiSelect: true),
        ],
        maxPrice: 30000,
      );
    case 'BOYS':
      return const _FilterConfig(
        groups: [
          _FilterGroup(label: 'Age', options: ['2-4Y', '4-6Y', '6-8Y', '8-10Y', '10-12Y']),
          _FilterGroup(label: 'Style', options: ['Casual', 'Sports', 'School']),
          _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL'], multiSelect: true),
        ],
        maxPrice: 30000,
      );
    case 'NEWBORN':
    case 'SHOES':
      return const _FilterConfig(
        groups: [
          _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL'], multiSelect: true),
        ],
        maxPrice: 30000,
      );
    case 'SKINCARE':
      return const _FilterConfig(
        groups: [
          _FilterGroup(label: 'Skin Type', options: ['Oily', 'Dry', 'Combination', 'Sensitive'], multiSelect: true),
          _FilterGroup(label: 'Type', options: ['Moisturizer', 'Serum', 'Toner', 'Sunscreen']),
          _FilterGroup(label: 'Brand', options: ['Cetaphil', 'Neutrogena', 'The Ordinary', 'Nivea'], multiSelect: true),
        ],
        maxPrice: 30000,
      );
    case 'MAKEUP':
      return const _FilterConfig(
        groups: [
          _FilterGroup(label: 'Type', options: ['Lipstick', 'Foundation', 'Mascara', 'Blush']),
          _FilterGroup(label: 'Finish', options: ['Matte', 'Glossy', 'Satin']),
          _FilterGroup(label: 'Brand', options: ['MAC', 'NYX', 'Maybelline', "L'Oreal"], multiSelect: true),
        ],
        maxPrice: 30000,
      );
    default:
      return const _FilterConfig(groups: [
        _FilterGroup(label: 'Size', options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'], multiSelect: true),
        _FilterGroup(label: 'Brand', options: ['Zara', 'H&M', 'Nike', 'Adidas', 'Uniqlo'], multiSelect: true),
      ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class MensCategoryScreen extends StatefulWidget {
  final String? category;
  final String? title;
  const MensCategoryScreen({super.key, this.category, this.title});

  @override
  State<MensCategoryScreen> createState() => _MensCategoryScreenState();
}

class _MensCategoryScreenState extends State<MensCategoryScreen> {
  // HOME tab is index 0 in the bottom nav
  int _navIndex = 0;

  // ── Filter bottom sheet ────────────────────────────────────────────────────

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        title: widget.title ?? widget.category ?? 'Products',
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Container(
            color: cs.surface,
            padding: EdgeInsets.only(
              top: topPad + 10,
              left: 16,
              right: 16,
              bottom: 14,
            ),
            child: Row(
              children: [
                // Back arrow
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RouteNames.home);
                    }
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF3A3A3A)
                            : const Color(0xFFDDDDDD),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: cs.onSurface,
                    ),
                  ),
                ),

                // Title — centred
                Expanded(
                  child: Text(
                    widget.title ?? widget.category ?? 'Products',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      color: cs.onSurface,
                    ),
                  ),
                ),

                // Filter icon
                GestureDetector(
                  onTap: _openFilterSheet,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF3A3A3A)
                            : const Color(0xFFDDDDDD),
                      ),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 18,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 0.5,
            color: isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFEEEEEE),
          ),

          // ── Product Grid — Firestore-powered ───────────────────────────────
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: FirestoreService.instance.productsStream(),
              builder: (context, snap) {
                // Show loader while first fetch is in flight
                if (snap.connectionState == ConnectionState.waiting &&
                    !snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Use Firestore data when available, fall back to local
                final allProducts =
                    (snap.hasData && snap.data!.isNotEmpty)
                        ? snap.data!
                        : AppData.products();

                // Filter by category
                final cat = widget.category;
                final filtered = (cat == null || cat.isEmpty)
                    ? allProducts
                    : allProducts
                        .where((p) =>
                            p.category.toLowerCase() ==
                            cat.toLowerCase())
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No products in this category.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.52,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    return Consumer<FavouritesProvider>(
                      builder: (context, favs, _) {
                        final isFav = favs.isFavourited(p);
                        return GestureDetector(
                          onTap: () => context.push(
                            RouteNames.productDetailExtra,
                            extra: p,
                          ),
                          child: _ProductCard(
                            product: p,
                            isDark: isDark,
                            cs: cs,
                            isFavourited: isFav,
                            onWishlist: () => favs.toggleFavourite(p),
                          ),
                        );
                      },
                    );
                  },
                );
              },
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
}

// ─────────────────────────────────────────────────────────────────────────────
// PRODUCT CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isDark;
  final ColorScheme cs;
  final bool isFavourited;
  final VoidCallback onWishlist;

  const _ProductCard({
    required this.product,
    required this.isDark,
    required this.cs,
    required this.isFavourited,
    required this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF2F2F2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: cardBg),
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: cardBg),
                ),
                // Wishlist
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlist,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavourited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: isFavourited
                            ? _terracotta
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                // Cart — writes directly to Firestore so CartScreen picks it up instantly
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Consumer<CartProvider>(
                    builder: (context, cart, _) {
                      final inCart = cart.isInCart(product.name);
                      return GestureDetector(
                        onTap: () {
                          final item = CartItem(
                            product.name,
                            'M',
                            product.price,
                            product.imageUrl,
                          );
                          // Persist to Firestore (CartScreen StreamBuilder picks it up)
                          FirestoreService.instance.addToCart(item);
                          // Also update local CartProvider so the icon toggles immediately
                          cart.addItem(item);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 15,
                            color: inCart
                                ? _terracotta
                                : const Color(0xFF999999),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          product.price,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _terracotta,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final String title;
  const _FilterSheet({required this.title});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late _FilterConfig _config;

  // chip selections: groupIndex → Set of selected option strings
  late List<Set<String>> _selections;

  // price range
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _config = _configForTitle(widget.title);
    _selections = List.generate(
      _config.groups.length,
      (_) => <String>{},
    );
    _priceRange = RangeValues(0, _config.maxPrice);
  }

  void _clearAll() {
    setState(() {
      for (var s in _selections) {
        s.clear();
      }
      _priceRange = RangeValues(0, _config.maxPrice);
    });
  }

  String _fmtPrice(double v) {
    final k = v >= 1000 ? '${(v / 1000).toStringAsFixed(0)}K' : v.toStringAsFixed(0);
    return 'LKR $k';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final onBg = cs.onSurface;
    final muted = cs.onSurfaceVariant;
    final divCol = cs.outlineVariant.withValues(alpha: 0.4);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: muted.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'FILTER',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: onBg,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 0.5, color: divCol),

          // Scrollable body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chip groups
                  for (int gi = 0; gi < _config.groups.length; gi++) ...[
                    _buildGroup(
                      group: _config.groups[gi],
                      groupIndex: gi,
                      onBg: onBg,
                      muted: muted,
                      divCol: divCol,
                    ),
                    Divider(height: 24, thickness: 0.5, color: divCol),
                  ],

                  // Price range
                  Text(
                    'Price Range',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: onBg,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _terracotta,
                      thumbColor: _terracotta,
                      inactiveTrackColor:
                          muted.withValues(alpha: 0.2),
                      overlayColor: _terracotta.withValues(alpha: 0.15),
                      rangeThumbShape:
                          const RoundRangeSliderThumbShape(
                              enabledThumbRadius: 8),
                    ),
                    child: RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: _config.maxPrice,
                      divisions: 100,
                      onChanged: (v) => setState(() => _priceRange = v),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fmtPrice(_priceRange.start),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: muted,
                        ),
                      ),
                      Text(
                        _fmtPrice(_priceRange.end),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Row(
              children: [
                // Clear All
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearAll,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: onBg,
                      side: BorderSide(
                          color: muted.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Clear All',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Apply Filters
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _terracotta,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroup({
    required _FilterGroup group,
    required int groupIndex,
    required Color onBg,
    required Color muted,
    required Color divCol,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: onBg,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: group.options.map((opt) {
            final selected = _selections[groupIndex].contains(opt);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (group.multiSelect) {
                    if (selected) {
                      _selections[groupIndex].remove(opt);
                    } else {
                      _selections[groupIndex].add(opt);
                    }
                  } else {
                    // single-select: toggle off if already selected
                    if (selected) {
                      _selections[groupIndex].clear();
                    } else {
                      _selections[groupIndex]
                        ..clear()
                        ..add(opt);
                    }
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: selected
                      ? _terracotta
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? _terracotta
                        : muted.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  opt,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: selected ? Colors.white : muted,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
