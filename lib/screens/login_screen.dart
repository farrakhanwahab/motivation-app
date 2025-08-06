import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessageDialog(context, 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate login process
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    // For now, just show success and navigate
    _showMessageDialog(context, 'Login successful!');
    await Future.delayed(const Duration(milliseconds: 1700));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _skipLogin() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Title
              const Text(
                'Motivation',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 48),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                obscureText: !_passwordVisible,
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: AppTheme.iosButtonStyle,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Sign Up Link
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Skip Button
              TextButton(
                onPressed: _skipLogin,
                child: const Text(
                  'Skip for now',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 