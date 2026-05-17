import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text('SubTracker', style: AppTextStyles.headline),
                    const SizedBox(height: 8),
                    const Text('Sign in to your account',
                        style: AppTextStyles.body),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      style: const TextStyle(color: AppColors.textPrimary),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Password'),
                      style: const TextStyle(color: AppColors.textPrimary),
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'Min 6 characters' : null,
                    ),
                    if (auth.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(auth.errorMessage!,
                          style:
                              const TextStyle(color: AppColors.danger)),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final ok = await auth.signIn(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                  if (ok && context.mounted) {
                                    context.go('/dashboard');
                                  }
                                }
                              },
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: AppColors.background,
                                    strokeWidth: 2),
                              )
                            : const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text(
                          "Don't have an account? Sign up",
                          style:
                              TextStyle(color: AppColors.accentLight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
