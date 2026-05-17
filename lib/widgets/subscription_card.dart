import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final days = subscription.daysUntilRenewal;
    final urgency = days <= 3
        ? AppColors.danger
        : days <= 7
            ? AppColors.warning
            : AppColors.success;

    return Dismissible(
      key: Key(subscription.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.danger.withValues(alpha: 0.2),
        child: const Icon(Icons.delete_outline, color: AppColors.danger),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text('Delete?',
                style: TextStyle(color: AppColors.textPrimary)),
            content: Text('Remove ${subscription.name}?',
                style: const TextStyle(color: AppColors.textSecondary)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete',
                    style: TextStyle(color: AppColors.danger)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentSoft, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _CategoryIcon(category: subscription.category),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subscription.name, style: AppTextStyles.subtitle),
                      const SizedBox(height: 2),
                      Text(subscription.category,
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${subscription.currency} ${subscription.price.toStringAsFixed(2)}',
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: 4),
                    _CountdownBadge(days: days, color: urgency),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownBadge extends StatelessWidget {
  final int days;
  final Color color;

  const _CountdownBadge({required this.days, required this.color});

  @override
  Widget build(BuildContext context) {
    final label = days == 0
        ? 'Today!'
        : days < 0
            ? '${days.abs()}d overdue'
            : 'in ${days}d';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String category;

  const _CategoryIcon({required this.category});

  @override
  Widget build(BuildContext context) {
    const icons = {
      'streaming': Icons.play_circle_outline,
      'gym': Icons.fitness_center,
      'saas': Icons.computer,
      'utility': Icons.bolt,
      'other': Icons.label_outline,
    };
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icons[category] ?? Icons.label_outline,
          color: AppColors.textSecondary, size: 22),
    );
  }
}
