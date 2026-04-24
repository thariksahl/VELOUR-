import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_data.dart';
import '../../routes/route_names.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _State();
}

class _State extends State<WishlistScreen> {
  // HTML Tokens
  static const Color _surface = Color(0xFFFAF9F5);
  static const Color _onSurface = Color(0xFF1B1C1A);
  static const Color _onSurfaceVariant = Color(0xFF54433C);
  static const Color _surfaceContainerLow = Color(0xFFF4F4F0);
  static const Color _outlineVariant = Color(0xFFDAC1B8);
  static const Color _primary = Color(0xFF914722);
  static const Color _primaryContainer = Color(0xFFAF5F38);

  int _navIndex = 2; // FAVOURITE active

  final List<WishlistItem> _items = AppData.wishlistItems();

  TextStyle _nr(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.newsreader(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 80 + MediaQuery.of(context).padding.bottom),
              child: Column(
                children: [
                  _titleSection(),
                  const SizedBox(height: 32),
                  _productGrid(),
                  _emptyStateSuggestion(context),
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

  Widget _header(BuildContext context) {
    return Container(
      color: _surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24, right: 24, bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.go(RouteNames.home),
            child: const Icon(Icons.arrow_back, size: 24, color: _onSurface),
          ),
          // HTML: style="color: #8B6914;" serif-bold text-2xl tracking-[0.1em]
          Text('VELOUR', style: _nr(24, FontWeight.w700, const Color(0xFF8B6914), ls: 2.4)),
          GestureDetector(
            onTap: () => context.go(RouteNames.cart),
            child: const Icon(Icons.shopping_bag_outlined, size: 24, color: _onSurface),
          ),
        ],
      ),
    );
  }

  // ── Title ──────────────────────────────────────────────────────────────────

  Widget _titleSection() {
    return Column(
      children: [
        Text(
          'CURATED COLLECTION',
          style: _bvp(10, FontWeight.w400, _onSurfaceVariant.withOpacity(0.60), ls: 2.0),
        ),
        const SizedBox(height: 4),
        Text('Your Saved Pieces', style: _nr(24, FontWeight.w400, _onSurface)),
      ],
    );
  }

  // ── Grid ───────────────────────────────────────────────────────────────────

  Widget _productGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 32,
        childAspectRatio: 0.58, // aspect-[3/4] + space for text
      ),
      itemCount: _items.length,
      itemBuilder: (_, i) => _productCard(_items[i]),
    );
  }

  Widget _productCard(WishlistItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image — aspect 3/4
        AspectRatio(
          aspectRatio: 3 / 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: _surfaceContainerLow),
                Image.network(item.imageUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                // Favorite heart — top-2 right-2
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => item.wishlisted = !item.wishlisted),
                    child: Icon(
                      item.wishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: item.wishlisted ? Colors.black : Colors.black,
                    ),
                  ),
                ),
                // Cart button — bottom-2 right-2
                Positioned(
                  bottom: 8, right: 8,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 4)],
                      ),
                      child: const Icon(Icons.shopping_cart_outlined, size: 16, color: Color(0xFF636E72)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Name — serif-regular text-sm
        Text(item.name, style: _nr(14, FontWeight.w400, _onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        // Price — font-body text-xs font-medium text-on-surface-variant
        Text(item.price, style: _bvp(12, FontWeight.w500, _onSurfaceVariant)),
      ],
    );
  }

  // ── Empty State Suggestion ─────────────────────────────────────────────────

  Widget _emptyStateSuggestion(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: const EdgeInsets.only(top: 48),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _outlineVariant.withOpacity(0.20))),
      ),
      child: Column(
        children: [
          Text('Discover more of Velour', style: _nr(20, FontWeight.w400, _onSurface)),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.go(RouteNames.home),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                gradient: const LinearGradient(colors: [_primary, _primaryContainer]),
              ),
              child: Text(
                'CONTINUE SHOPPING',
                style: _bvp(12, FontWeight.w400, Colors.white, ls: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Nav ─────────────────────────────────────────────────────────────

  Widget _bottomNav(BuildContext context) {
    const items = [
      (Icons.home_outlined, Icons.home, 'HOME'),
      (Icons.search, Icons.search, 'EXPLORE'),
      (Icons.favorite_outline, Icons.favorite, 'FAVOURITE'),
      (Icons.shopping_cart_outlined, Icons.shopping_cart, 'CART'),
      (Icons.person_outline, Icons.person, 'PROFILE'),
    ];
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F3F3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == _navIndex;
          final color = active ? Colors.black : _onSurfaceVariant.withOpacity(0.40);
          return GestureDetector(
            onTap: () {
              setState(() => _navIndex = i);
              switch (i) {
                case 0: context.go(RouteNames.home); break;
                case 1: context.go(RouteNames.explore); break;
                case 2: break; // Already here
                case 3: context.go(RouteNames.cart); break;
                case 4: context.go(RouteNames.profile); break;
              }
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 64,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(active ? items[i].$2 : items[i].$1, size: 28, color: color),
                const SizedBox(height: 4),
                Text(items[i].$3,
                    style: _bvp(10, FontWeight.w700, color, ls: 0.8)),
              ]),
            ),
          );
        }),
      ),
    );
  }
}
