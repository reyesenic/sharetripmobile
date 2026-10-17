import 'dart:async';

import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import '../widgets/settings_widget.dart';
import 'notification_details_screen.dart';
import 'notification_models.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
    this.notifications,
    this.loadNotifications,
  }) : assert(notifications == null || loadNotifications == null);

  final List<AppNotification>? notifications;
  final Future<List<AppNotification>> Function()? loadNotifications;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _pageSize = 10;
  static const _skeletonCount = 3;

  late List<AppNotification> _items = List.of(
    widget.notifications ??
        (widget.loadNotifications == null ? sampleNotifications() : const []),
  );
  bool _isLoading = false;
  bool _isLoadingMore = false;
  Object? _loadError;
  int _loadGeneration = 0;
  int _visibleLimit = _pageSize;
  final ScrollController _listController = ScrollController();

  NotificationCategory? _filter;

  static final _options = <NotificationCategory?>[
    null,
    ...NotificationCategory.values,
  ];
  final _chipKeys = List.generate(_options.length, (_) => GlobalKey());

  int get _unread =>
      _items.where((notification) => !notification.isRead).length;

  int _count(NotificationCategory? category) => category == null
      ? _items.length
      : _items
          .where((notification) => notification.category == category)
          .length;

  List<AppNotification> get _visible => _filter == null
      ? _items
      : _items
          .where((notification) => notification.category == _filter)
          .toList(growable: false);

  int get _visibleItemCount =>
      _visible.length.clamp(0, _visibleLimit).toInt();

  @override
  void initState() {
    super.initState();
    _listController.addListener(_onListScroll);
    if (widget.loadNotifications != null) {
      unawaited(_loadNotifications());
    }
  }

  @override
  void dispose() {
    _listController
      ..removeListener(_onListScroll)
      ..dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NotificationsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadNotifications != widget.loadNotifications) {
      _loadGeneration++;
      if (widget.loadNotifications != null) {
        unawaited(_loadNotifications());
      } else {
        setState(() {
          _items = List.of(widget.notifications ?? sampleNotifications());
          _isLoading = false;
          _isLoadingMore = false;
          _visibleLimit = _pageSize;
          _loadError = null;
        });
      }
    } else if (widget.loadNotifications == null &&
        oldWidget.notifications != widget.notifications) {
      setState(() {
        _items = List.of(widget.notifications ?? sampleNotifications());
        _visibleLimit = _pageSize;
      });
    }
  }

  Future<void> _loadNotifications() async {
    final loadNotifications = widget.loadNotifications;
    if (loadNotifications == null) return;

    final generation = ++_loadGeneration;
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final notifications = await loadNotifications();
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _items = List.of(notifications);
        _isLoading = false;
        _visibleLimit = _pageSize;
      });
    } catch (error) {
      debugPrint('Unable to load notifications: $error');
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  void _select(int index) {
    setState(() {
      _filter = _options[index];
      _visibleLimit = _pageSize;
      _isLoadingMore = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chipContext = _chipKeys[index].currentContext;
      if (chipContext != null) {
        Scrollable.ensureVisible(
          chipContext,
          alignment: 0.5,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onListScroll() {
    if (!_listController.hasClients || _isLoading || _isLoadingMore) return;
    if (_listController.position.extentAfter <= 240 &&
        _visibleItemCount < _visible.length) {
      unawaited(_loadNextBatch());
    }
  }

  Future<void> _loadNextBatch() async {
    if (_isLoadingMore || _visibleItemCount >= _visible.length) return;
    setState(() => _isLoadingMore = true);

    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    setState(() {
      _visibleLimit =
          (_visibleLimit + _pageSize).clamp(0, _visible.length).toInt();
      _isLoadingMore = false;
    });
  }

  void _markAllRead() {
    setState(() {
      for (var i = 0; i < _items.length; i++) {
        _items[i] = _items[i].copyWith(isRead: true);
      }
    });
  }

  Future<void> _open(AppNotification notification) async {
    final index = _items.indexWhere((item) => item.id == notification.id);
    if (index == -1) return;

    var selectedNotification = _items[index];
    if (!selectedNotification.isRead) {
      selectedNotification = selectedNotification.copyWith(isRead: true);
      setState(() => _items[index] = selectedNotification);
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            NotificationDetailsScreen(notification: selectedNotification),
      ),
    );
  }

  void _dismiss(AppNotification notification) {
    final index = _items.indexWhere((item) => item.id == notification.id);
    if (index == -1) return;
    final removed = _items[index];
    setState(() => _items.removeAt(index));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Notification dismissed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              if (!mounted) return;
              setState(
                () => _items.insert(
                  index.clamp(0, _items.length).toInt(),
                  removed,
                ),
              );
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.st;
    final primary = Theme.of(context).colorScheme.primary;
    final visible = _visible;

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    child: Row(
                      children: [
                        Material(
                          color: colors.iconButtonBg,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => Navigator.maybePop(context),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: colors.text.withAlpha(190),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _isLoading
                                    ? 'Loading notifications...'
                                    : _unread == 0
                                        ? 'All caught up'
                                        : '$_unread unread',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed:
                              _isLoading || _unread == 0 ? null : _markAllRead,
                          child: Text(
                            'Mark all read',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color:
                                  _unread == 0 ? colors.sectionLabel : primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Row(
                      children: [
                        for (var i = 0; i < _options.length; i++)
                          Padding(
                            key: _chipKeys[i],
                            padding: const EdgeInsets.only(right: 10),
                            child: _FilterChip(
                              label: _options[i]?.label ?? 'All',
                              count: _count(_options[i]),
                              selected: _filter == _options[i],
                              onTap: () => _select(i),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const _NotificationSkeletonList()
                : _loadError != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Unable to load notifications.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors.mutedText,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () =>
                                    unawaited(_loadNotifications()),
                                child: const Text('Try again'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : visible.isEmpty
                        ? Center(
                            child: Text(
                              'No notifications',
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.mutedText,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _listController,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            itemCount: _visibleItemCount +
                                (_isLoadingMore ? _skeletonCount : 0),
                            itemBuilder: (_, index) {
                              if (index >= _visibleItemCount) {
                                return _NotificationSkeletonCard(index: index);
                              }
                              final notification = visible[index];
                              return _NotificationCard(
                                key: ValueKey(notification.id),
                                notification: notification,
                                onTap: () => _open(notification),
                                onDismiss: () => _dismiss(notification),
                              );
                            },
                          ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: buildShareTripBottomNav(context),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.st;
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? primary : colors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? primary : colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : colors.text,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: const BoxConstraints(minWidth: 26),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withAlpha(60)
                    : colors.danger.withAlpha(30),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : colors.danger,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.st;
    final primary = Theme.of(context).colorScheme.primary;
    final unread = !notification.isRead;
    final accent = notification.category.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: unread ? colors.card : colors.card.withAlpha(130),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: unread ? colors.border : colors.divider),
        boxShadow: unread
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(14),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: unread ? 1 : 0.75,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: accent.withAlpha(36),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: accent,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    unread ? FontWeight.w800 : FontWeight.w700,
                                color: unread ? colors.text : colors.mutedText,
                              ),
                            ),
                          ),
                          if (unread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: colors.mutedText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.timeLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.sectionLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onDismiss,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.iconButtonBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 15, color: colors.mutedText),
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

class _NotificationSkeletonList extends StatefulWidget {
  const _NotificationSkeletonList();

  @override
  State<_NotificationSkeletonList> createState() =>
      _NotificationSkeletonListState();
}

class _NotificationSkeletonListState extends State<_NotificationSkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.st;
    return Semantics(
      label: 'Loading notifications',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Opacity(
          opacity: 0.45 + (_controller.value * 0.4),
          child: child,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: 5,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBlock(
                  width: 46,
                  height: 46,
                  color: colors.iconButtonBg,
                  radius: 14,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBlock(
                        width: index.isEven ? 180 : 140,
                        height: 16,
                        color: colors.iconButtonBg,
                        radius: 8,
                      ),
                      const SizedBox(height: 10),
                      _SkeletonBlock(
                        width: double.infinity,
                        height: 12,
                        color: colors.divider,
                        radius: 6,
                      ),
                      const SizedBox(height: 6),
                      _SkeletonBlock(
                        width: 125,
                        height: 12,
                        color: colors.divider,
                        radius: 6,
                      ),
                      const SizedBox(height: 10),
                      _SkeletonBlock(
                        width: 64,
                        height: 10,
                        color: colors.divider,
                        radius: 5,
                      ),
                    ],
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

class _NotificationSkeletonCard extends StatelessWidget {
  const _NotificationSkeletonCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.st;
    return Semantics(
      label: 'Loading more notifications',
      child: Opacity(
        opacity: 0.65 + (index.isEven ? 0.2 : 0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBlock(
                width: 46,
                height: 46,
                color: colors.iconButtonBg,
                radius: 14,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBlock(
                      width: index.isEven ? 180 : 140,
                      height: 16,
                      color: colors.iconButtonBg,
                      radius: 8,
                    ),
                    const SizedBox(height: 10),
                    _SkeletonBlock(
                      width: double.infinity,
                      height: 12,
                      color: colors.divider,
                      radius: 6,
                    ),
                    const SizedBox(height: 6),
                    _SkeletonBlock(
                      width: 125,
                      height: 12,
                      color: colors.divider,
                      radius: 6,
                    ),
                    const SizedBox(height: 10),
                    _SkeletonBlock(
                      width: 64,
                      height: 10,
                      color: colors.divider,
                      radius: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.width,
    required this.height,
    required this.color,
    required this.radius,
  });

  final double width;
  final double height;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
