import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/subscription_model.dart';
import '../../providers/subscription_provider.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  final String subscriptionId;

  const SubscriptionDetailScreen({super.key, required this.subscriptionId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();
    final sub = provider.findById(subscriptionId);

    if (sub == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.background),
        body: const Center(
          child: Text('Subscription not found', style: AppTextStyles.body),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(sub.name, style: AppTextStyles.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: AppColors.textSecondary),
            onPressed: () =>
                context.push('/subscriptions/${sub.id}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () => _confirmDelete(context, sub),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroSection(sub: sub),
            const SizedBox(height: 20),
            _DetailSection(sub: sub),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Subscription sub) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Subscription?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Remove "${sub.name}" permanently?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SubscriptionProvider>().delete(sub.id);
              context.go('/subscriptions');
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final Subscription sub;

  const _HeroSection({required this.sub});

  @override
  Widget build(BuildContext context) {
    final days = sub.daysUntilRenewal;
    final urgency = days <= 3
        ? AppColors.danger
        : days <= 7
            ? AppColors.warning
            : AppColors.success;
    final label = days == 0
        ? 'Today!'
        : days < 0
            ? '${days.abs()}d overdue'
            : 'in ${days}d';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentSoft, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CategoryIcon(category: sub.category),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sub.name, style: AppTextStyles.title),
                    const SizedBox(height: 2),
                    Text(sub.category, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: urgency.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: urgency.withValues(alpha: 0.4), width: 0.5),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                      color: urgency,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${sub.currency} ${sub.price.toStringAsFixed(2)}',
            style: AppTextStyles.price.copyWith(fontSize: 36),
          ),
          Text('per ${sub.billingCycle}', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final Subscription sub;

  const _DetailSection({required this.sub});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, yyyy');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentSoft, width: 0.5),
      ),
      child: Column(
        children: [
          _DetailRow(
              label: 'Start Date', value: fmt.format(sub.startDate)),
          const Divider(color: AppColors.accentSoft, height: 24),
          _DetailRow(
              label: 'Next Billing',
              value: fmt.format(sub.nextBillingDate)),
          const Divider(color: AppColors.accentSoft, height: 24),
          _DetailRow(
              label: 'Billing Cycle',
              value: '${sub.billingCycle[0].toUpperCase()}${sub.billingCycle.substring(1)}'),
          const Divider(color: AppColors.accentSoft, height: 24),
          _DetailRow(
            label: 'Monthly Cost',
            value:
                '${sub.currency} ${sub.monthlyPrice.toStringAsFixed(2)}',
          ),
          if (sub.notes != null && sub.notes!.isNotEmpty) ...[
            const Divider(color: AppColors.accentSoft, height: 24),
            _DetailRow(label: 'Notes', value: sub.notes!),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body),
        const SizedBox(width: 16),
        Flexible(
          child: Text(value,
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.end),
        ),
      ],
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
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icons[category] ?? Icons.label_outline,
          color: AppColors.textSecondary, size: 24),
    );
  }
}
