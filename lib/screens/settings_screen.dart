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

  void _onThemeChanged(ThemeMode? mode) async {
    if (mode == null) return;
    setState(() {
      themeMode = mode;
    });
    await themeNotifier.setThemeMode(mode);
  }

  Future<void> _goToProfile() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
    await _loadProfile();
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
                    child: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  ListTile(
                    leading: avatarPath != null
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
                    title: const Text('Edit Profile'),
                    subtitle: const Text('Name, avatar, email'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _goToProfile,
                  ),
                  // Preferences Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text('Topics'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TopicsPage())),
                  ),
                  ListTile(
                    leading: const Icon(Icons.emoji_emotions),
                    title: const Text('Mood'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodPage())),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Preferred Time'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimePage())),
                  ),
                  // App Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Theme'),
                    trailing: SizedBox(
                      width: 120,
                      child: DropdownButton<ThemeMode>(
                        value: themeMode,
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('System'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Light'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Dark'),
                          ),
                        ],
                        onChanged: _onThemeChanged,
                        isExpanded: true,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
                  ),
                  // Account Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text('Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Change Password'),
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
                    // TODO: Implement logout logic
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Logout functionality coming soon.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                        ],
                      ),
                    );
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