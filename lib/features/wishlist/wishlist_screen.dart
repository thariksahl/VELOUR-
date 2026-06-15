import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/services/firestore_service.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../data/app_data.dart';
import '../../routes/route_names.dart';
import '../../core/theme/theme_notifier.dart';
import 'favourites_provider.dart';
import '../cart/cart_provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _State();
}

class _State extends State<WishlistScreen> {
  final int _navIndex = 2; // FAVOURITES active

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeNotifier>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          _header(context),
          Expanded(
            // Real-time stream: emits Set<String> of wishlisted doc keys.
            // Cross-reference with Firestore products stream so cards reflect
            // live data. Falls back to local AppData while Firestore loads.
            child: StreamBuilder<Set<String>>(
              stream: FirestoreService.instance.wishlistStream(),
              builder: (context, wishSnap) {
                return StreamBuilder<List<Product>>(
                  stream: FirestoreService.instance.productsStream(),
                  builder: (context, prodSnap) {
                    // Show loader only while both streams are waiting
                    if (wishSnap.connectionState == ConnectionState.waiting &&
                        !wishSnap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final wishlistKeys = wishSnap.data ?? {};

                    // Build cross-referenced product list
                    final allProducts = (prodSnap.hasData && prodSnap.data!.isNotEmpty)
                        ? prodSnap.data!
                        : AppData.products();

                    final favouritedProducts = allProducts
                        .where((p) =>
                            wishlistKeys.contains(p.id.isNotEmpty ? p.id : _sanitise(p.name)))
                        .toList();

                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                          16, 24, 16, 80 + MediaQuery.of(context).padding.bottom),
                      child: Column(
                        children: [
                          _titleSection(),
                          const SizedBox(height: 32),
                          if (favouritedProducts.isEmpty)
                            _buildEmptyState()
                          else
                            _productGrid(favouritedProducts),
                          _emptyStateSuggestion(context),
                        ],
                      ),
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
        onTap: (i) => setState(() {}),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _sanitise(String name) => name.replaceAll(RegExp(r'[^\w]'), '_');

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24, right: 24, bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.go(RouteNames.home),
            child: Icon(Icons.arrow_back, size: 24, color: theme.iconTheme.color),
          ),
          Text(
            'VELOUR',
            style: GoogleFonts.beVietnamPro(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 4.8,
              color: theme.textTheme.headlineLarge?.color ?? const Color(0xFF111111),
            ),
          ),
          GestureDetector(
            onTap: () => context.go(RouteNames.cart),
            child: Icon(Icons.shopping_bag_outlined, size: 24, color: theme.iconTheme.color),
          ),
        ],
      ),
    );
  }

  // ── Title ────────────────────────────────────────────────────────────────────

  Widget _titleSection() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'CURATED COLLECTION',
          style: _bvp(10, FontWeight.w800,
              theme.textTheme.bodyMedium?.color ?? Colors.grey.shade600, ls: 2.0),
        ),
        const SizedBox(height: 4),
        Text(
          'Your Saved Pieces',
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.headlineLarge?.color ?? const Color(0xFF111111),
          ),
        ),
      ],
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 48, color: theme.hintColor),
          const SizedBox(height: 16),
          Text(
            'No saved pieces yet',
            style: _bvp(16, FontWeight.w600, theme.hintColor),
          ),
        ],
      ),
    );
  }

  // ── Grid ─────────────────────────────────────────────────────────────────────

  Widget _productGrid(List<Product> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 32,
        childAspectRatio: 0.58,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _productCard(items[i]),
    );
  }

  Widget _productCard(Product item) {
    final theme = Theme.of(context);
    final favs = context.read<FavouritesProvider>();

    return GestureDetector(
      onTap: () => context.push(RouteNames.productDetailExtra, extra: item),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image — aspect 3/4
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: theme.cardColor),
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: theme.dividerColor),
                  ),
                  // Favourite heart — tapping removes from wishlist
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => favs.removeFavourite(item),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 20,
                          color: Color(0xFFC1633A),
                        ),
                      ),
                    ),
                  ),
                  // Cart button
                  Positioned(
                    bottom: 8, right: 8,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, _) {
                        final inCart = cart.isInCart(item.name);
                        return GestureDetector(
                          onTap: () {
                            final cartItem = CartItem(
                              item.name, 'M', item.price, item.imageUrl,
                            );
                            FirestoreService.instance.addToCart(cartItem);
                            cart.addItem(cartItem);
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
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
                              size: 16,
                              color: inCart ? const Color(0xFFC1633A) : theme.hintColor,
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
          const SizedBox(height: 12),
          Text(
            item.name,
            style: _bvp(14, FontWeight.w700,
                theme.textTheme.bodyLarge?.color ?? Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.price,
            style: _bvp(12, FontWeight.w600, const Color(0xFFC1633A)),
          ),
        ],
      ),
    );
  }

  // ── Empty State Suggestion ───────────────────────────────────────────────────

  Widget _emptyStateSuggestion(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: const EdgeInsets.only(top: 48),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1.0)),
      ),
      child: Column(
        children: [
          Text(
            'Discover more of Velour',
            style: GoogleFonts.beVietnamPro(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.textTheme.headlineMedium?.color ?? const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.go(RouteNames.home),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: const Color(0xFFC1633A),
              ),
              child: Text(
                'CONTINUE SHOPPING',
                style: _bvp(12, FontWeight.w700, Colors.white, ls: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
