import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../cards/auth/support_bottomsheet.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text.trim());

      final authState = ref.read(authProvider);

      if (authState.hasError) {
        if (!mounted) return;
        AppTheme.showPremiumSnackBar(
          context: context,
          message: authState.error.toString(),
          isError: true,
        );
      } else if (authState.value != null) {
        if (!mounted) return;
        AppTheme.showPremiumSnackBar(
          context: context,
          message: 'Welcome back, ${authState.value!.name}!',
        );
        context.go(AppRouter.profile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppGaps.screenPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppGaps.extraLargeV,
                AppGaps.extraLargeV,
                // Header
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    'Welcome Back.',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      height: 1.1,
                    ),
                  ),
                ),
                AppGaps.mediumV,
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'Sign in with your email and password provided to access the admin portal and track your medical representatives.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                AppGaps.extraLargeV,

                // Email Field
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.black),
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      prefixIcon: Icon(Iconsax.sms, color: AppColors.darkGrey),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                AppGaps.largeV,

                // Password Field
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.black),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Iconsax.lock,
                        color: AppColors.darkGrey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Iconsax.eye : Iconsax.eye_slash,
                          color: AppColors.darkGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                AppGaps.largeV,

                // Trouble signing in
                FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: 'Having trouble signing in? ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.darkGrey,
                          letterSpacing: 0,
                        ),
                        children: [
                          TextSpan(
                            text: 'Get Help',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                SupportBottomSheet.show(context);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppGaps.extraLargeV,

                // Sign in Button
                FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Sign In'),
                  ),
                ),

                AppGaps.extraLargeV,

                // Terms & Conditions
                FadeIn(
                  duration: const Duration(milliseconds: 1500),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By signing in, you agree to our ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.darkGrey,
                          letterSpacing: 0,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  letterSpacing: 0,
                                ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Conditions',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  letterSpacing: 0,
                                ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppGaps.largeV,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
