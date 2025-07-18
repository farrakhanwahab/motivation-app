import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final List<String> moods = [
    'Any', 'Happy', 'Sad', 'Stressed', 'Motivated', 'Tired',
  ];
  String selectedMood = 'Any';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'Select Your Mood',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose the mood you want your quotes to match.',
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: moods.map((mood) => ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          mood,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: selectedMood == mood ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      selected: selectedMood == mood,
                      showCheckmark: false,
                      onSelected: (selected) {
                        setState(() {
                          selectedMood = mood;
                        });
                      },
                      selectedColor: Colors.black,
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide.none,
                    )).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {'mood': selectedMood});
                  },
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