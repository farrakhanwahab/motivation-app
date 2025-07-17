import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/quote_card.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation AI'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const QuoteCard(
                quote:
                    'Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.',
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
            ],
          ),
        ),
      ),
    );
  }
}
