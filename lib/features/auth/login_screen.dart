import 'package:flutter/material.dart';

import '../../core/exports.dart';
import 'domain/login_controller.dart';

/// The screen widget. Kept Stateful only to create/dispose the ViewModel.
/// UI itself lives in [LoginContent] which is a StatelessWidget that consumes the view model.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = LoginViewModel();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginContent(viewModel: vm);
  }
}

/// Pure UI: stateless and reads state from the view model via ValueListenableBuilder.
/// Spacing uses number.heightBox / number.widthBox to follow your spacing convention.
/// NOTE: I used a mapping so the original `X.h` approximate spacing is preserved:
/// 1.h ≈ 8 px (so 6.h ≈ 48px). If you want percent-driven spacing instead, tell me.
class LoginContent extends StatelessWidget {
  final LoginViewModel viewModel;
  const LoginContent({required this.viewModel, super.key});

  // small spacing helper to keep code compact but still using your widthBox/heightBox approach
  // mapping: hUnits * 8 px
  Widget v(double hUnits) => (hUnits * 8).heightBox;
  Widget h(double wUnits) => (wUnits * 8).widthBox;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                v(6), // approx 6.h
                // Logo Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 96, // approx 24.w in original
                        height: 96,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.local_shipping_outlined,
                            color: theme.colorScheme.onPrimary,
                            size: 48,
                          ),
                        ),
                      ),
                      v(2),
                      Text(
                        'Delivery Partner',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      v(1),
                      Text(
                        'Sign in to start delivering',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                v(6),

                // Error Message
                ValueListenableBuilder<String?>(
                  valueListenable: viewModel.errorMessage,
                  builder: (context, error, _) {
                    if (error == null) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withAlpha(
                          (0.1 * 255).toInt(),
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: theme.colorScheme.error.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          h(2),
                          Expanded(
                            child: Text(
                              error,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Email Field
                TextFormField(
                  controller: viewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: true,
                  // validator: viewModel.validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.person_outline,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                v(2),

                // Password Field
                ValueListenableBuilder<bool>(
                  valueListenable: viewModel.isPasswordVisible,
                  builder: (context, isVisible, _) {
                    return TextFormField(
                      controller: viewModel.passwordController,
                      obscureText: !isVisible,
                      enabled: true,
                      // validator: viewModel.validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.lock_outline,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () =>
                              viewModel.isPasswordVisible.value = !isVisible,
                        ),
                      ),
                    );
                  },
                ),

                v(1),

                // Remember Me & Forgot Password Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: viewModel.rememberMe,
                          builder: (context, remember, _) {
                            return SizedBox(
                              width: 48,
                              height: 48,
                              child: Checkbox(
                                value: remember,
                                onChanged: (value) =>
                                    viewModel.rememberMe.value = value ?? false,
                              ),
                            );
                          },
                        ),
                        h(2),
                        Text(
                          'Remember me',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Forgot Password'),
                            content: const Text(
                              'Please contact your delivery service administrator to reset your password.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                v(4),

                // Login Button (uses ValueListenable to toggle loading)
                ValueListenableBuilder<bool>(
                  valueListenable: viewModel.isLoading,
                  builder: (context, loading, _) {
                    return ElevatedButton(
                      onPressed: loading
                          ? null
                          : () => viewModel.handleLogin(context),
                      child: loading
                          ? SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : const Text('Login'),
                    );
                  },
                ),

                v(3),

                // Biometric Login Option
                OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            Icon(
                              Icons.fingerprint,
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                            h(2),
                            const Text('Biometric Login'),
                          ],
                        ),
                        content: const Text(
                          'Biometric authentication will be available after your first successful login.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.fingerprint,
                    color: theme.colorScheme.primary,
                  ),
                  label: const Text('Login with Biometrics'),
                ),

                v(6),

                // Register Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('New Driver Registration'),
                          content: const Text(
                            'Driver registration is handled through your employer\'s onboarding system. Please contact your delivery service administrator for registration assistance.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'New Driver? ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                v(2),

                // Help Text
                Center(
                  child: Text(
                    'Need help? Contact support',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                v(2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
