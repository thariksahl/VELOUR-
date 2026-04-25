import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../../routes/route_names.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color navBg;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.navBg = Colors.white,
  });

  static const List<(IconData, IconData, String, String)> _items = [
    (Icons.home_outlined, Icons.home, 'HOME', RouteNames.home),
    (Icons.search, Icons.search, 'EXPLORE', RouteNames.explore),
    (Icons.favorite_outline, Icons.favorite, 'FAVOURITE', RouteNames.wishlist),
    (Icons.shopping_cart_outlined, Icons.shopping_cart, 'CART', RouteNames.cart),
    (Icons.person_outline, Icons.person, 'PROFILE', RouteNames.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: navBg,
        border: const Border(top: BorderSide(color: Color(0xFFF3F3F3))),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
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
            onTap: () {
              if (onTap != null) onTap!(i);
              context.go(item.$4);
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? item.$2 : item.$1,
                    size: 28,
                    color: isActive
                        ? Colors.black
                        : AppColors.onSurfaceVariant.withValues(alpha: 0.40),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.$3,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isActive
                          ? Colors.black
                          : AppColors.onSurfaceVariant.withValues(alpha: 0.40),
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
