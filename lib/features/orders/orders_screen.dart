import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/services/firestore_service.dart';
import '../../routes/route_names.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  TextStyle _nr(double s, FontWeight w, Color c,
          {bool italic = false, double ls = 0}) =>
      GoogleFonts.newsreader(
        fontSize: s,
        fontWeight: w,
        color: c,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        letterSpacing: ls,
      );

  TextStyle _bvp(double s, FontWeight w, Color c, {double ls = 0}) =>
      GoogleFonts.beVietnamPro(
          fontSize: s, fontWeight: w, color: c, letterSpacing: ls);

  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(RouteNames.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          // ── Premium Header ──────────────────────────────────────────────────
          Container(
            color: cs.surface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _goBack(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cardBg,
                      border: Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Icon(Icons.arrow_back,
                        size: 18, color: cs.onSurface),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'My Orders',
                  style: _nr(24, FontWeight.w600, cs.onSurface,
                      italic: true, ls: -0.5),
                ),
              ],
            ),
          ),
          Container(
              height: 1,
              color: cs.outlineVariant.withValues(alpha: 0.15)),

          // ── Firestore Orders Stream ─────────────────────────────────────────
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService.instance.ordersStream(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snap.data ?? [];

                if (orders.isEmpty) {
                  return _emptyState(context, cs, isDark);
                }

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                      24, 24, 24, 24 + MediaQuery.of(context).padding.bottom),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _orderCard(
                        context, order, cs, isDark, cardBg, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────
  Widget _emptyState(BuildContext context, ColorScheme cs, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 72,
              color: isDark
                  ? cs.onSurfaceVariant.withValues(alpha: 0.4)
                  : const Color(0xFFC8C2BA),
            ),
            const SizedBox(height: 20),
            Text(
              'No Orders Placed',
              style: GoogleFonts.newsreader(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You haven't placed any orders yet.\nStart shopping to see your orders here.",
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC1622A),
                minimumSize: const Size(160, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              onPressed: () => context.go(RouteNames.home),
              child: Text(
                'Shop Now',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Order Card ───────────────────────────────────────────────────────────────
  Widget _orderCard(
    BuildContext context,
    Map<String, dynamic> order,
    ColorScheme cs,
    bool isDark,
    Color cardBg,
    int index,
  ) {
    final items = (order['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final total = (order['total'] as num?)?.toDouble() ?? 0.0;
    final status = order['status'] as String? ?? 'Confirmed';
    final placedAt = order['placedAt'] as Timestamp?;
    final dateStr = placedAt != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(placedAt.toDate())
        : '—';

    // status color
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'delivered':
        statusColor = const Color(0xFF22A06B);
        break;
      case 'shipped':
        statusColor = const Color(0xFF1D6FA4);
        break;
      case 'cancelled':
        statusColor = const Color(0xFFD93025);
        break;
      default:
        statusColor = const Color(0xFFC1622A);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Order header row ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${(index + 1).toString().padLeft(4, '0')}',
                style: _nr(17, FontWeight.w600, cs.onSurface),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: _bvp(11, FontWeight.w600, statusColor, ls: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(dateStr,
              style: _bvp(12, FontWeight.w400, cs.onSurfaceVariant)),
          const SizedBox(height: 16),

          // ── Items preview ─────────────────────────────────────────────────
          ...items.take(3).map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: 52,
                      height: 64,
                      child: Image.network(
                        item['imageUrl'] as String? ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            color: isDark
                                ? const Color(0xFF3A3A3A)
                                : const Color(0xFFF2F2F2)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String? ?? '',
                          style: _bvp(13, FontWeight.w500, cs.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item['variant'] ?? ''} · Qty ${item['qty'] ?? 1}',
                          style: _bvp(
                              11, FontWeight.w400, cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item['price'] as String? ?? '',
                    style: _bvp(13, FontWeight.w600, cs.primary),
                  ),
                ],
              ),
            );
          }),

          if (items.length > 3) ...[
            const SizedBox(height: 4),
            Text(
              '+ ${items.length - 3} more item${items.length - 3 > 1 ? 's' : ''}',
              style: _bvp(12, FontWeight.w400, cs.onSurfaceVariant),
            ),
          ],

          const SizedBox(height: 16),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.15)),
          const SizedBox(height: 12),

          // ── Total row ─────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: _bvp(13, FontWeight.w400, cs.onSurfaceVariant)),
              Text(
                _formatLKR(total),
                style: _bvp(16, FontWeight.w700, cs.tertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLKR(double val) {
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return 'LKR ${val.round().toString().replaceAll(reg, ',')}';
  }
}
