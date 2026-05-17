import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.accentSoft, width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.person_outline,
                      color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Account', style: AppTextStyles.subtitle),
                      const SizedBox(height: 2),
                      Text(
                        auth.user?.email ?? 'Not logged in',
                        style: AppTextStyles.body,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              leading: const Icon(Icons.logout, color: AppColors.danger),
              title: const Text('Sign Out',
                  style: TextStyle(color: AppColors.danger)),
              onTap: () async {
                await context.read<AuthProvider>().signOut();
                if (context.mounted) context.go('/login');
              },
            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text('SubTracker v1.0.0', style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }
}
