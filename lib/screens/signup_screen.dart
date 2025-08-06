import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _signup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showMessageDialog(context, 'Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessageDialog(context, 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate signup process
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    // For now, just show success and navigate
    _showMessageDialog(context, 'Account created successfully!');
    await Future.delayed(const Duration(milliseconds: 1700));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _skipSignup() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                'Create your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 32),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
              ),
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

              // Confirm Password Field
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                obscureText: !_confirmPasswordVisible,
              ),
              const SizedBox(height: 24),

              // Signup Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: AppTheme.iosButtonStyle,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Login Link
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Already have an account? Login',
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
                onPressed: _skipSignup,
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