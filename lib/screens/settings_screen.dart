import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'topics_page.dart';
import 'mood_page.dart';
import 'time_page.dart';
import 'about_page.dart';
import 'change_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = 'User Name';
  String? avatarPath;
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadTheme();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('profile_name') ?? name;
      avatarPath = prefs.getString('profile_avatar');
    });
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      themeMode = ThemeNotifier.stringToThemeMode(prefs.getString('theme_mode'));
    });
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

  void _onThemeChanged(ThemeMode? mode) async {
    if (mode == null) return;
    setState(() {
      themeMode = mode;
    });
    await themeNotifier.setThemeMode(mode);
    _showMessageDialog(context, 'Theme updated!');
  }

  Future<void> _goToProfile() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
    await _loadProfile();
    if (!mounted) return;
    if (result != null) {
      _showMessageDialog(context, 'Profile updated!');
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        // Clear user data (profile, preferences, etc.)
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                        // Navigate to login
                        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text('Logout', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Profile Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  ListTile(
                    leading: (avatarPath != null && File(avatarPath!).existsSync())
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(avatarPath!)),
                            radius: 22,
                          )
                        : CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              name.isNotEmpty ? name[0] : '?',
                              style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                            ),
                          ),
                    title: const Text('Edit Profile', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Name, avatar, email', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _goToProfile,
                  ),
                  // Preferences Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text('Topics', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const TopicsPage()));
                      if (!mounted) return;
                      if (result != null) {
                        _showMessageDialog(context, 'Topics updated!');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.emoji_emotions),
                    title: const Text('Mood', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodPage()));
                      if (!mounted) return;
                      if (result != null) {
                        _showMessageDialog(context, 'Mood updated!');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Preferred Time', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const TimePage()));
                      if (!mounted) return;
                      if (result != null && result['time'] != null) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('preferred_time', result['time']);
                        _showMessageDialog(context, 'Preferred time updated!');
                      }
                    },
                  ),
                  // App Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Theme', style: TextStyle(fontSize: 14)),
                    trailing: SizedBox(
                      width: 120,
                      child: DropdownButton<ThemeMode>(
                        value: themeMode,
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('System', style: TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Light', style: TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Dark', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                        onChanged: _onThemeChanged,
                        isExpanded: true,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
                  ),
                  // Account Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Change Password', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage())),
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Logout'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 