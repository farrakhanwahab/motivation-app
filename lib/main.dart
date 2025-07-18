import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/quote_card.dart';
import 'screens/preferences_screen.dart';

void main() {
  runApp(const MotivationAIApp());
}

class MotivationAIApp extends StatelessWidget {
  const MotivationAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivation AI',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedTopics = [];
  String selectedMood = 'Any';

  void _openPreferences() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      ),
    );
    if (result != null && result is Map) {
      setState(() {
        selectedTopics = List<String>.from(result['topics'] ?? []);
        selectedMood = result['mood'] ?? 'Any';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preferences updated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation AI'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openPreferences,
            tooltip: 'Preferences',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuoteCard(
                quote: 'Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.',
                author: 'Christian D. Larson',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {}, // TODO: Hook up to AI later
                  style: AppTheme.iosButtonStyle,
                  child: const Text('New Quote'),
                ),
              ),
              const SizedBox(height: 32),
              if (selectedTopics.isNotEmpty || selectedMood != 'Any')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedTopics.isNotEmpty)
                      Text('Topics: ${selectedTopics.join(", ")}', style: Theme.of(context).textTheme.bodySmall),
                    if (selectedMood != 'Any')
                      Text('Mood: $selectedMood', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
