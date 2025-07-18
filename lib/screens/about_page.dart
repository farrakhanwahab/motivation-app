import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text('Motivation AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          SizedBox(height: 8),
          Text('Version 1.0.0'),
          SizedBox(height: 24),
          Text('An AI-powered motivational quotes app.'),
          SizedBox(height: 24),
          Text('Developed by Farrakhan Wahab'),
        ],
      ),
    );
  }
} 