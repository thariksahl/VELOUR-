import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../data/app_data.dart';
import '../../routes/route_names.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 1; // MEN selected by default
  int _navIndex = 0;

  final List<Category> _categories = AppData.categories;

  final List<SubCategory> _subCategories = AppData.subCategories;

  final List<Product> _products = AppData.products();

  List<Product> get _filteredProducts {
    final catName = _categories[_selectedCategory].label;
    if (catName == 'NEW IN') return _products;
    return _products.where((p) => p.category == catName).toList();
  }

  // ── Colors matching HTML ───────────────────────────────────────────────────
  static const Color _primary = Color(0xFFC06C44);   // HTML: #C06C44
  static const Color _navBg = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ── Sticky Header ────────────────────────────────────────────────
          _StickyHeader(),

          // ── Scrollable Body ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chips
                  _CategoryChips(
                    categories: _categories,
                    selected: _selectedCategory,
                    primaryColor: _primary,
                    onTap: (i) => setState(() => _selectedCategory = i),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Banner
                        const _HeroBanner(primaryColor: _primary),

                        const SizedBox(height: 32),

                        // Sub-categories circular
                        _SubCategoryRow(subCategories: _subCategories),

                        const SizedBox(height: 32),

                        // Product Grid
                        _ProductGrid(
                          products: _filteredProducts,
                          onWishlist: (i) {
                            final p = _filteredProducts[i];
                            setState(() => p.wishlisted = !p.wishlisted);
                          },
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

      // ── Bottom Nav ─────────────────────────────────────────────────────
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        navBg: _navBg,
        onTap: (i) {
          setState(() => _navIndex = i);
          switch (i) {
            case 0: break; // home
            case 1: context.go(RouteNames.explore); break;
            case 2: context.go(RouteNames.wishlist); break;
            case 3: context.go(RouteNames.cart); break;
            case 4: context.go(RouteNames.profile); break;
          }
        },
      ),
    );
  }
}

// ── Sticky Header ─────────────────────────────────────────────────────────────

class _StickyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface.withOpacity(0.95),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back circle button
          _CircleIconBtn(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          // VELOUR — Be Vietnam Pro, black, font-black, tracking-tighter
          Text(
            'VELOUR',
            style: GoogleFonts.newsreader(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              letterSpacing: 4.8, // 0.2em
              color: Colors.black,
            ),
          ),
          // Notifications circle button
          _CircleIconBtn(
            icon: Icons.notifications_outlined,
            onTap: () => context.go(RouteNames.notifications),
          ),
        ],
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}

// ── Category Chips ────────────────────────────────────────────────────────────

class _CategoryChips extends StatelessWidget {
  final List<Category> categories;
  final int selected;
  final Color primaryColor;
  final void Function(int) onTap;

  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final isSelected = i == selected;
                  return GestureDetector(
                    onTap: () => onTap(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        categories[i].label,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: isSelected ? Colors.white : AppColors.onSurface.withOpacity(0.80),
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
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
              ),
              child: const Icon(Icons.tune, size: 20, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero Banner ───────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final Color primaryColor;
  const _HeroBanner({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 224,
        color: const Color(0xFFE3EEF4),
        child: Row(
          children: [
            // Text side
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VELOUR COLLECTION OF WEDDING',
                      style: GoogleFonts.newsreader(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'SHOP NOW',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Image side — overflows slightly (h-[105%])
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.38,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    top: -11, // ~105% height
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCsypGQ5zoyNlus7VIXvOaXgTj5CKzUSYHvnKTvRW-wfi3wlCwHH3sxcXpuak1mKNSirk2hTqv_GXtb7bzeWsZ0RGLIOzCjYm4il7arsGaWXjuZZWLdo4dZBkJ8SwO5WIkASDz7yi519ULpv8bFf8mFc78RyFatlsZY9hVvdc8mPqpWlIr5sMU2F21pEU_LQk7Xgb4MetW80OUyFR2BeQZWQUCDj8zp9CpD4j2Ogh2Ppy5xJCWLmE4uKMXp85OV4vVySapZeOy5i54',
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-category Circles ──────────────────────────────────────────────────────

class _SubCategoryRow extends StatelessWidget {
  final List<SubCategory> subCategories;
  const _SubCategoryRow({required this.subCategories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: subCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final sub = subCategories[i];
          return Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(color: AppColors.outlineVariant.withOpacity(0.20)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  sub.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sub.label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface.withOpacity(0.80),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Product Grid ──────────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final List<Product> products;
  final void Function(int) onWishlist;
  const _ProductGrid({required this.products, required this.onWishlist});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No products available in this category.',
            style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.onSurface.withOpacity(0.6)),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 40,
        childAspectRatio: 3 / 4,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) => GestureDetector(
        onTap: () => context.push('/products/$i'),
        child: _ProductCard(
          product: products[i],
          onWishlist: () => onWishlist(i),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onWishlist;
  const _ProductCard({required this.product, required this.onWishlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image container — aspect 3/4, rounded-[2rem]
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Product image
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerLow),
                ),
                // Wishlist button — top right
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onWishlist,
                    child: Icon(
                      product.wishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 22,
                      color: product.wishlisted ? Colors.red : Colors.black,
                    ),
                  ),
                ),
                // Add to cart button — bottom right
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.40),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Product name
        Text(
          product.name,
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            letterSpacing: 0.6,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        // Price
        Text(
          product.price,
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface.withOpacity(0.60),
          ),
        ),
      ],
    );
  }
}

// ── Bottom Nav Bar ────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final Color navBg;
  final void Function(int) onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.navBg,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'HOME'),
    _NavItem(icon: Icons.search, activeIcon: Icons.search, label: 'EXPLORE'),
    _NavItem(icon: Icons.favorite_outline, activeIcon: Icons.favorite, label: 'FAVOURITE'),
    _NavItem(icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart, label: 'CART'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: navBg,
        border: const Border(top: BorderSide(color: Color(0xFFF3F3F3))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.only(
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
        left: 8,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? item.activeIcon : item.icon,
                    size: 28,
                    color: isActive ? Colors.black : AppColors.onSurfaceVariant.withOpacity(0.40),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isActive ? Colors.black : AppColors.onSurfaceVariant.withOpacity(0.40),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
