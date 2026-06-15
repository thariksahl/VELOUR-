import 'package:flutter/material.dart';
import '../../data/models.dart';

/// Global notification state. Seeded with static notifications and supports
/// dynamic order-placed notifications from any screen.
class NotificationProvider extends ChangeNotifier {
  int _orderCounter = 7734; // next auto-assigned order number

  final List<NotificationItem> _notifications = [
    // ── Static seed (newest → oldest) ────────────────────────────────────────
    const NotificationItem(
      icon: Icons.description_outlined,
      iconColor: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
      title: 'Your order has been shipped!',
      subtitle: 'Your order #7732 is on its way to you.',
      time: '2 hours ago',
      isUnread: true,
      isFadedText: false,
    ),
    const NotificationItem(
      icon: Icons.shopping_bag_outlined,
      iconColor: Color(0xFFc1633a),
      bgColor: Color(0xFFFFF0E8),
      title: 'Order Confirmed!',
      subtitle: 'Your order #7733 has been confirmed. We\'re getting it ready.',
      time: '1 day ago',
      isUnread: true,
      isFadedText: false,
    ),
    const NotificationItem(
      icon: Icons.celebration_outlined,
      iconColor: Color(0xFF7C3AED),
      bgColor: Color(0xFFF5F3FF),
      title: 'Welcome to Velour!',
      subtitle: 'Thanks for joining us. Explore our latest collections.',
      time: '2 days ago',
      isUnread: false,
      isFadedText: true,
    ),
    const NotificationItem(
      icon: Icons.credit_card_outlined,
      iconColor: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
      title: 'Payment Successful',
      subtitle: 'Payment of LKR 4,500 received for order #7732.',
      time: '2 days ago',
      isUnread: false,
      isFadedText: true,
    ),
    const NotificationItem(
      icon: Icons.local_fire_department_outlined,
      iconColor: Color(0xFFDC2626),
      bgColor: Color(0xFFFEF2F2),
      title: 'Flash Sale — 50% Off!',
      subtitle: 'Hurry! Limited time offer on selected items. Shop now.',
      time: '3 days ago',
      isUnread: false,
      isFadedText: true,
    ),
    const NotificationItem(
      icon: Icons.inventory_2_outlined,
      iconColor: Color(0xFFc1633a),
      bgColor: Color(0xFFFFF0E8),
      title: 'Order Delivered',
      subtitle: 'Your order #7730 has been delivered. Enjoy your purchase!',
      time: '5 days ago',
      isUnread: false,
      isFadedText: true,
    ),
    const NotificationItem(
      icon: Icons.star_outline,
      iconColor: Color(0xFFF59E0B),
      bgColor: Color(0xFFFFFBEB),
      title: 'Rate Your Purchase',
      subtitle: 'How was your order #7730? Tap to leave a review.',
      time: '5 days ago',
      isUnread: false,
      isFadedText: true,
    ),
  ];

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => n.isUnread).length;

  /// Inserts a new "Order Placed" notification at the top of the list.
  /// Called whenever the user completes checkout.
  void addOrderNotification() {
    final orderNumber = _orderCounter++;
    _notifications.insert(
      0,
      NotificationItem(
        icon: Icons.check_circle_outline,
        iconColor: const Color(0xFF059669),
        bgColor: const Color(0xFFECFDF5),
        title: 'Order Placed Successfully!',
        subtitle:
            'Your order #$orderNumber has been placed. We\'ll confirm it shortly.',
        time: 'Just now',
        isUnread: true,
        isFadedText: false,
      ),
    );
    notifyListeners();
  }
}
