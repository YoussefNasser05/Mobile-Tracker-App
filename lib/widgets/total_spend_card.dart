import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

class TotalSpendCard extends StatelessWidget {
  final double monthlyTotal;
  final String currency;
  final int activeCount;

  const TotalSpendCard({
    super.key,
    required this.monthlyTotal,
    required this.currency,
    required this.activeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentSoft, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Spend', style: AppTextStyles.body),
          const SizedBox(height: 8),
          Text(
            '$currency ${monthlyTotal.toStringAsFixed(2)}',
            style: AppTextStyles.price.copyWith(fontSize: 36),
          ),
          const SizedBox(height: 12),
          Text(
            '$activeCount active subscription${activeCount == 1 ? '' : 's'}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
