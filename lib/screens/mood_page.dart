import 'package:flutter/material.dart';

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
                  const Text('Select Mood', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: selectedMood,
                    items: moods.map((mood) => DropdownMenuItem(
                      value: mood,
                      child: Text(mood, style: const TextStyle(fontFamily: 'Montserrat')),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMood = value;
                        });
                      }
                    },
                    isExpanded: true,
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