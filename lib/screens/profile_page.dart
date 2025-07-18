import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'User Name';
  String email = 'user@email.com';
  String? avatarPath;

  void _pickAvatar() async {
    // Placeholder: Implement image picker logic here
    setState(() {
      avatarPath = avatarPath == null ? 'assets/avatar_placeholder.png' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: avatarPath != null ? AssetImage(avatarPath!) : null,
                        child: avatarPath == null ? Text(name.isNotEmpty ? name[0] : '?', style: const TextStyle(fontSize: 32)) : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: TextEditingController(text: name),
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (val) => setState(() => name = val),
                  ),
                  const SizedBox(height: 16),
                  Text(email, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {'name': name, 'avatar': avatarPath});
                  },
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