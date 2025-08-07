import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  void _showMessageDialog(BuildContext context, String message, {bool isError = false}) {
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
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  void _savePassword() {
    // Validate inputs
    if (newPasswordController.text != confirmPasswordController.text) {
      _showMessageDialog(context, 'The new passwords do not match. Please try again.', isError: true);
      return;
    }
    if (newPasswordController.text.isEmpty || oldPasswordController.text.isEmpty) {
      _showMessageDialog(context, 'Please fill in all password fields.', isError: true);
      return;
    }

    // Show success message and then navigate back after it disappears
    _showMessageDialog(context, 'Your password has been changed successfully!');
    
    // Navigate back after the success dialog has been dismissed
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  TextField(
                    controller: oldPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      labelStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        icon: Icon(oldPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            oldPasswordVisible = !oldPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    obscureText: !oldPasswordVisible,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        icon: Icon(newPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            newPasswordVisible = !newPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    obscureText: !newPasswordVisible,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      labelStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        icon: Icon(confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            confirmPasswordVisible = !confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    obscureText: !confirmPasswordVisible,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePassword,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.iosButtonStyleDark
                      : AppTheme.iosButtonStyle,
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}