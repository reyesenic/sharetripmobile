import 'package:flutter/material.dart';

enum NotificationType { ride, completed, safety, feature }

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String timeAgo;
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timeAgo,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _primary = Color(0xFF6258D6);

  // Sample data. Replace with your real notifications source.
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      type: NotificationType.ride,
      title: 'Ride Available',
      message:
          'Ramon Dela Rosa just posted a ride: Bitin → CMDI Main Campus at 6:30 AM',
      timeAgo: '5m ago',
    ),
    AppNotification(
      id: '2',
      type: NotificationType.completed,
      title: 'Your Ride Completed',
      message: "Great ride with Ligaya Reyes! Don't forget to leave a rating.",
      timeAgo: '2h ago',
    ),
    AppNotification(
      id: '3',
      type: NotificationType.safety,
      title: 'Safety Reminder',
      message: "Always verify your driver's ID before boarding.",
      timeAgo: '1d ago',
      isRead: true,
    ),
    AppNotification(
      id: '4',
      type: NotificationType.feature,
      title: 'New Feature',
      message: 'ShareTrip now shows departure times on all ride cards!',
      timeAgo: '2d ago',
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(AppNotification n) {
    if (n.isRead) return;
    setState(() => n.isRead = true);
  }

  void _dismiss(AppNotification n) {
    setState(() => _notifications.removeWhere((e) => e.id == n.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _notifications.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final n = _notifications[index];
                        return _NotificationCard(
                          notification: n,
                          onTap: () => _markRead(n),
                          onDismiss: () => _dismiss(n),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            customBorder: const CircleBorder(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F2F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_unreadCount unread',
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              style: TextButton.styleFrom(
                foregroundColor: _primary,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Mark all read',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  ({Color fg, Color bg}) get _colors {
    switch (notification.type) {
      case NotificationType.ride:
        return (fg: const Color(0xFF6258D6), bg: const Color(0xFFEEF0FB));
      case NotificationType.completed:
        return (fg: const Color(0xFF10B981), bg: const Color(0xFFE6F8F0));
      case NotificationType.safety:
        return (fg: const Color(0xFFF59E0B), bg: const Color(0xFFFEF5DC));
      case NotificationType.feature:
        return (fg: const Color(0xFF6258D6), bg: const Color(0xFFEEF0FB));
    }
  }

  @override
  Widget build(BuildContext context) {
    final read = notification.isRead;
    final colors = _colors;

    return Opacity(
      opacity: read ? 0.65 : 1,
      child: Material(
        color: read ? const Color(0xFFFAFAFD) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: read ? const Color(0xFFF0F1F5) : const Color(0xFFE3E5F0),
              ),
              boxShadow: read
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.notifications_none_rounded,
                      size: 18, color: colors.fg),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              notification.title,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          if (!read) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6258D6),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onDismiss,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F2F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 12, color: Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 40, color: Color(0xFF9CA3AF)),
          SizedBox(height: 10),
          Text('No notifications',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151))),
          SizedBox(height: 4),
          Text("You're all caught up.",
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}