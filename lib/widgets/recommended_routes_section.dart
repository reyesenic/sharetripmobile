import 'package:flutter/material.dart';

class RecommendedRoute {
  final String from;
  final String to;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const RecommendedRoute({
    required this.from,
    required this.to,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}

class RecommendedRoutesSection extends StatelessWidget {
  final List<RecommendedRoute> routes;
  final ValueChanged<RecommendedRoute>? onRouteTap;

  const RecommendedRoutesSection({
    super.key,
    required this.routes,
    this.onRouteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECOMMENDED ROUTES',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B7280),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < routes.length; i++) ...[
                _RouteTile(
                  route: routes[i],
                  isFirst: i == 0,
                  isLast: i == routes.length - 1,
                  onTap:
                      onRouteTap == null ? null : () => onRouteTap!(routes[i]),
                ),
                if (i != routes.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF3F4F6),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteTile extends StatelessWidget {
  final RecommendedRoute route;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  const _RouteTile({
    required this.route,
    required this.isFirst,
    required this.isLast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.vertical(
      top: Radius.circular(isFirst ? 16 : 0),
      bottom: Radius.circular(isLast ? 16 : 0),
    );

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: route.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(route.icon, color: route.iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${route.from} → ${route.to}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      route.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFD1D5DB),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
