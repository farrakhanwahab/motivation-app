import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PreferencesScreen extends StatefulWidget {
  final List<String>? initialTopics;
  final String? initialMood;
  final String? initialTime;
  const PreferencesScreen({super.key, this.initialTopics, this.initialMood, this.initialTime});

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
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTopics = Set<String>.from(widget.initialTopics ?? []);
    selectedMood = widget.initialMood ?? 'Any';
    if (widget.initialTime != null) {
      final parts = widget.initialTime!.split(":");
      if (parts.length == 2) {
        selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }
  }

  String get formattedTime => selectedTime != null ? selectedTime!.format(context) : 'Not set';

  void _showCupertinoTimePicker() {
    final now = TimeOfDay.now();
    final initial = selectedTime ?? now;
    final initialDateTime = DateTime(0, 0, 0, initial.hour, initial.minute);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        DateTime tempPicked = initialDateTime;
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: 270,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: initialDateTime,
                      use24hFormat: false,
                      onDateTimeChanged: (DateTime newDateTime) {
                        tempPicked = newDateTime;
                      },
                    ),
                  ),
                  CupertinoButton(
                    child: const Text('Set Time'),
                    onPressed: () {
                      setState(() {
                        selectedTime = TimeOfDay(hour: tempPicked.hour, minute: tempPicked.minute);
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
            const SizedBox(height: 32),
            const Text(
              'Preferred Time',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(formattedTime, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14)),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _showCupertinoTimePicker,
                    child: const Text('Pick Time'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save preferences and time
                  Navigator.pop(context, {
                    'topics': selectedTopics.toList(),
                    'mood': selectedMood,
                    'time': selectedTime != null ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}' : null,
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