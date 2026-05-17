import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/subscription_card.dart';
import '../../widgets/total_spend_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _categories = [
    'streaming',
    'gym',
    'saas',
    'utility',
    'other'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
                child: CircularProgressIndicator(
                    color: AppColors.accent)),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                title: const Text('SubTracker', style: AppTextStyles.title),
                floating: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh,
                        color: AppColors.textSecondary),
                    onPressed: provider.loadAll,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: TotalSpendCard(
                  monthlyTotal: provider.monthlyTotal,
                  currency: 'USD',
                  activeCount: provider.activeCount,
                ),
              ),
              if (provider.all.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text('By Category',
                        style: AppTextStyles.title),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _CategoryBreakdown(
                      subscriptions: provider.all,
                      categories: _categories),
                ),
              ],
              if (provider.upcomingRenewals.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child:
                        Text('Renewing Soon', style: AppTextStyles.title),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final sub = provider.upcomingRenewals[i];
                      return SubscriptionCard(
                        subscription: sub,
                        onTap: () =>
                            context.go('/subscriptions/${sub.id}'),
                        onDelete: () => context
                            .read<SubscriptionProvider>()
                            .delete(sub.id),
                      );
                    },
                    childCount: provider.upcomingRenewals.length,
                  ),
                ),
              ],
              if (provider.all.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.subscriptions_outlined,
                            size: 64, color: AppColors.textMuted),
                        SizedBox(height: 16),
                        Text('No subscriptions yet',
                            style: AppTextStyles.subtitle),
                        SizedBox(height: 8),
                        Text('Go to Subscriptions tab to add one',
                            style: AppTextStyles.body),
                      ],
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  final List subscriptions;
  final List<String> categories;

  const _CategoryBreakdown(
      {required this.subscriptions, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          final count =
              subscriptions.where((s) => s.category == cat).length;
          if (count == 0) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppColors.accentSoft, width: 0.5),
              ),
              child: Text(
                '${cat[0].toUpperCase()}${cat.substring(1)}: $count',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        },
      ),
    );
  }
}
