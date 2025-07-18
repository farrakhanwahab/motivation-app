import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final List<String> topics = [
    'Success', 'Health', 'Relationships', 'Mindfulness', 'Productivity', 'Happiness', 'Confidence', 'Resilience',
  ];
  final List<String> moods = [
    'Any', 'Happy', 'Sad', 'Stressed', 'Motivated', 'Tired',
  ];

  Set<String> selectedTopics = {};
  String selectedMood = 'Any';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Topics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: topics.map((topic) => ChoiceChip(
                label: Text(topic),
                selected: selectedTopics.contains(topic),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedTopics.add(topic);
                    } else {
                      selectedTopics.remove(topic);
                    }
                  });
                },
                selectedColor: Colors.black,
                labelStyle: TextStyle(
                  color: selectedTopics.contains(topic) ? Colors.white : Colors.black,
                  fontFamily: 'Montserrat',
                ),
                backgroundColor: Colors.grey[200],
              )).toList(),
            ),
            const SizedBox(height: 32),
            const Text(
              'Select Mood',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save preferences
                  Navigator.pop(context, {
                    'topics': selectedTopics.toList(),
                    'mood': selectedMood,
                  });
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 