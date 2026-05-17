import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/subscription_card.dart';

class SubscriptionListScreen extends StatelessWidget {
  const SubscriptionListScreen({super.key});

  static const _categories = [
    'all',
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
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Subscriptions'),
            backgroundColor: AppColors.background,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh,
                    color: AppColors.textSecondary),
                onPressed: provider.loadAll,
              ),
            ],
          ),
          body: Column(
            children: [
              _CategoryFilter(
                selectedCategory: provider.selectedCategory,
                onCategorySelected: provider.setCategory,
                categories: _categories,
              ),
              Expanded(child: _buildBody(context, provider)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SubscriptionProvider provider) {
    if (provider.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.accent));
    }
    if (provider.subscriptions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.subscriptions_outlined,
                size: 64, color: AppColors.textMuted),
            SizedBox(height: 16),
            Text('No subscriptions yet', style: AppTextStyles.subtitle),
            SizedBox(height: 8),
            Text('Tap + to add your first one', style: AppTextStyles.body),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: provider.subscriptions.length,
      itemBuilder: (context, i) {
        final sub = provider.subscriptions[i];
        return SubscriptionCard(
          subscription: sub,
          onTap: () => context.go('/subscriptions/${sub.id}'),
          onDelete: () => provider.delete(sub.id),
        );
      },
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final List<String> categories;

  const _CategoryFilter({
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isSelected = cat == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onCategorySelected(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.accentSoft,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '${cat[0].toUpperCase()}${cat.substring(1)}',
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.background
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
