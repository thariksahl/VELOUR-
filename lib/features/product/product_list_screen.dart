import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_data.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routes/route_names.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class MensCategoryScreen extends StatefulWidget {
  final String? category;
  const MensCategoryScreen({super.key, this.category});

  @override
  State<MensCategoryScreen> createState() => _MensCategoryScreenState();
}

class _MensCategoryScreenState extends State<MensCategoryScreen> {
  late int _selectedCat;
  int _navIndex = 1; // EXPLORE active

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      final index = AppData.categories.indexWhere(
          (c) => c.label.toUpperCase() == widget.category!.toUpperCase());
      _selectedCat = index != -1 ? index : 2;
    } else {
      _selectedCat = 2; // WOMEN active by default per HTML
    }
  }

  // HTML: velour-terracotta #C06C44 / velour-gray #E2E2E2
  static const Color _terracotta = Color(0xFFC06C44);
  static const Color _velourGray = Color(0xFFE2E2E2);
  static const Color _cardBg = Color(0xFFD9D9D9);

  final List<Category> _cats = AppData.categories;

  final List<SubCategory> _subs = AppData.subCategories;

  final List<Product> _products = AppData.products();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // HTML: bg-white
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Sticky Header ──────────────────────────────────────────────
          _buildHeader(context),

          // ── Category Nav ───────────────────────────────────────────────
          _buildCategoryNav(),

          // ── Scrollable Body ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  // Hero Banner
                  _buildHeroBanner(context),

                  // Sub-categories
                  _buildSubCategories(),

                  // Product Grid
                  _buildProductGrid(),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Nav ─────────────────────────────────────────────────────
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button — border circle
          GestureDetector(
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
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
            ),
          ),
          // Logo — Newsreader, bold, tracking-[0.2em]
          Text(
            'Velour',
            style: GoogleFonts.newsreader(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              letterSpacing: 4.8, // 0.2em
              color: Colors.black,
            ),
          ),
          // Notifications button with badge
          GestureDetector(
            onTap: () => context.go(RouteNames.notifications),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF9F9F9),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: const Icon(Icons.notifications_outlined, size: 24, color: Colors.black),
                ),
                // Notification dot — HTML: absolute top-2.5 right-2.5 w-2 h-2 bg-black
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
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

  // ── Category Nav ─────────────────────────────────────────────────────────

  Widget _buildCategoryNav() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final active = i == _selectedCat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCat = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? _terracotta : _velourGray,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        _cats[i].label,
                        style: GoogleFonts.newsreader(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Filter Button
          GestureDetector(
            onTap: () {
              // TODO: Implement filter action
            },
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(Icons.tune, size: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero Banner ──────────────────────────────────────────────────────────

  Widget _buildHeroBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          // HTML: bg-[#97A7D8], min-h-[220px]
          color: const Color(0xFF97A7D8),
          height: 220,
          child: Stack(
            children: [
              // Text block — z-10, pl-6, w-3/5
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, top: 32, bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'VELOUR',
                              style: GoogleFonts.newsreader(
                                fontSize: 24, 
                                fontWeight: FontWeight.w700, 
                                color: const Color(0xFF1B1C1A), 
                                letterSpacing: 4.8,
                              ),
                            ),
                            Text(
                              'Formal Shoe',
                              style: GoogleFonts.newsreader(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Lorem this design this look made by indian designers themetrial was good',
                              style: GoogleFonts.newsreader(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.90),
                                height: 1.4,
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),
                            // HTML: bg-[#2D3E50] text-white text-[10px] font-bold uppercase border border-white/20
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2D3E50),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
                                ),
                                child: Text(
                                  'SHOP NOW',
                                  style: GoogleFonts.newsreader(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(flex: 2, child: SizedBox()),
                  ],
                ),
              ),
              // Model image — absolute right-0 bottom-0 h-full w-[180px]
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                width: 180,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida/ADBb0ujv9JGU3CzVoJ8gj2zyVfDVClEj18TBZ86DJlSuNXI1HsoeiDHMzx_038jqV8bb3aztnjch4s0znnpxA3-F7aifWialdRupjCWLUzdyNbjGiof1er1rMcwTg9icSuwDOwLSLSYvLwGrYZELef2q_Cylt95q38pqn2kJ-LflLZzLnK-qMgUcQkC7mX7azwK1XzbzC25YGcpl6v0T4MUizXXDPZYaZwNinR5BfJht6utf6BbS8kULhPh0wEIL1qtEQFhGkNuDrfUo',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sub-categories ────────────────────────────────────────────────────────

  Widget _buildSubCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: _subs.map((sub) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 64,
              child: Column(
                children: [
                  Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    sub.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined, color: Colors.grey, size: 24),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sub.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.newsreader(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Product> get _filteredProducts {
    final catName = _cats[_selectedCat].label;
    if (catName == 'NEW') return _products;
    return _products.where((p) => p.category == catName).toList();
  }

  // ── Product Grid ──────────────────────────────────────────────────────────

  Widget _buildProductGrid() {
    final filtered = _filteredProducts;
    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Center(
          child: Text(
            'No products available in this category.',
            style: GoogleFonts.newsreader(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.52, // 3/4 image + text below
        ),
        itemCount: filtered.length,
        itemBuilder: (context, i) {
          final p = filtered[i];
          final globalIndex = AppData.products().indexOf(p);
          return GestureDetector(
            onTap: () => context.push('/products/$globalIndex'),
            child: _ProductCard(
              product: p,
              cardBg: _cardBg,
              onWishlist: () => setState(() => p.wishlisted = !p.wishlisted),
              onAddToCart: () {
                AppData.addToCart(CartItem(
                  p.name,
                  'Standard',
                  p.price,
                  p.imageUrl,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart'), duration: Duration(seconds: 1)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Bottom nav is now handled by BottomNavBar
}

// ── Product Card ──────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final Product product;
  final Color cardBg;
  final VoidCallback onWishlist;
  final VoidCallback onAddToCart;

  const _ProductCard({
    required this.product,
    required this.cardBg,
    required this.onWishlist,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image container — rounded-2xl (16px), aspect 3/4
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background color fallback
                Container(color: cardBg),
                // Product image
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: cardBg),
                ),
                // Wishlist — HTML: absolute top-2 right-2 p-1.5 bg-white/80 rounded-full
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlist,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.80),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        product.wishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: product.wishlisted ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Product name — font-bold text-sm
        Text(
          product.name,
          style: GoogleFonts.newsreader(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),

        // Description — text-[9px] text-gray-500
        Text(
          product.description,
          style: GoogleFonts.newsreader(
            fontSize: 9,
            color: Colors.grey.shade500,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),

        // Price + Add to cart — HTML: flex justify-between items-center
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.price,
              style: GoogleFonts.newsreader(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
            // HTML: bg-[#4D4D4D] text-white p-2 rounded-full
            GestureDetector(
              onTap: onAddToCart,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF4D4D4D),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
