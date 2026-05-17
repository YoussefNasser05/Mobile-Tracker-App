import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold(
      {super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        selectedIndex: currentIndex,
        indicatorColor: AppColors.accentSoft,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined,
                color: AppColors.textMuted),
            selectedIcon:
                Icon(Icons.dashboard, color: AppColors.textPrimary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.list, color: AppColors.textPrimary),
            label: 'Subscriptions',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined,
                color: AppColors.textMuted),
            selectedIcon:
                Icon(Icons.settings, color: AppColors.textPrimary),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/subscriptions');
              break;
            case 2:
              context.go('/settings');
              break;
          }
        },
      ),
      floatingActionButton: currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => context.go('/subscriptions/add'),
              backgroundColor: AppColors.textPrimary,
              child: const Icon(Icons.add, color: AppColors.background),
            )
          : null,
    );
  }
}
