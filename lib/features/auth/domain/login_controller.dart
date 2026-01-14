import 'package:flickbee_delivery_partner/features/store_selection/store_selection.dart';
import 'package:flutter/cupertino.dart';
import '../../splash/navigation_logic.dart';

class LoginViewModel {
  // controllers
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // state via ValueNotifiers (no setState)
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> rememberMe = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  // mock credentials (kept as in your original file)
  final Map<String, String> mockCredentials = {
    'driver@delivery.com': 'Driver@123',
    'john.doe@delivery.com': 'John@456',
    'admin@delivery.com': 'Admin@789',
    '': '',
  };

  // validate functions (copied from original)
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> handleLogin(BuildContext context) async {
    // simple flow preserved from your original file (you can re-enable validation and network logic)
    // if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    // simulate delay
    await Future.delayed(const Duration(milliseconds: 800));

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (mockCredentials.containsKey(email) &&
        mockCredentials[email] == password) {
      // success
      isLoading.value = false;
      // navigate (use root navigator like originally)
      await DriverSession.setLoggedIn(true);

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
    CupertinoPageRoute(builder: (context) => StoreSelectionScreen()),

        (_) => false,
      );
    } else {
      // failure
      isLoading.value = false;
      errorMessage.value = 'Invalid email or password. Please try again.';
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
    isLoading.dispose();
    rememberMe.dispose();
    errorMessage.dispose();
  }
}
