import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/subscription_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    runApp(_UnsupportedPlatformApp(error: e.toString()));
    return;
  }
  runApp(const SubTrackerApp());
}

class _UnsupportedPlatformApp extends StatelessWidget {
  final String error;
  const _UnsupportedPlatformApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone_android,
                    size: 64, color: Color(0xFFAAAAAA)),
                const SizedBox(height: 24),
                const Text(
                  'SubTracker',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please run on Android or iOS.\nThis app requires Firebase which is\nnot configured for this platform.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubTrackerApp extends StatelessWidget {
  const SubTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, SubscriptionProvider>(
          create: (_) => SubscriptionProvider(),
          update: (_, auth, subs) =>
              subs!..onAuthChanged(auth.user?.uid),
        ),
      ],
      child: Builder(
        builder: (context) {
          final auth = context.read<AuthProvider>();
          return MaterialApp.router(
            title: 'SubTracker',
            theme: _buildTheme(),
            routerConfig: buildRouter(auth),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

ThemeData _buildTheme() => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.accent,
        secondary: AppColors.accentLight,
        tertiary: AppColors.accentSoft,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: AppTextStyles.title,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accentSoft,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ),
    );
