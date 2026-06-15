import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../routes/route_names.dart';
import '../../features/cart/cart_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? navBg; // optional override; defaults to theme surface

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.navBg,
  });

  static const List<(IconData, IconData, String, String)> _items = [
    (Icons.home_outlined, Icons.home, 'HOME', RouteNames.home),
    (Icons.grid_view_outlined, Icons.grid_view, 'EXPLORE', RouteNames.explore),
    (Icons.favorite_outline, Icons.favorite, 'FAVOURITES', RouteNames.wishlist),
    (Icons.shopping_cart_outlined, Icons.shopping_cart, 'CART', RouteNames.cart),
    (Icons.person_outline, Icons.person, 'PROFILE', RouteNames.profile),
  ];

  /// Returns the GoRouter route path for the given tab [index].
  static String routeForIndex(int index) => _items[index].$4;

  @override
  Widget build(BuildContext context) {
    // Reactively watch CartProvider for the badge count
    final cartCount = context.watch<CartProvider>().itemCount;

    final colorScheme = Theme.of(context).colorScheme;
    final bg = navBg ?? colorScheme.surface;
    const Color active = Color(0xFFC1622A); // terracotta always

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.30),
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
        left: 8,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == currentIndex;
          final isCart = i == 3;
          final iconColor = isActive ? active : colorScheme.onSurfaceVariant;

          return GestureDetector(
            onTap: () {
              if (onTap != null) onTap!(i);
              context.go(item.$4);
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        isActive ? item.$2 : item.$1,
                        size: 24,
                        color: iconColor,
                      ),
                      if (isCart && cartCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$cartCount',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.$3,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 9,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.5,
                      color: iconColor,
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
