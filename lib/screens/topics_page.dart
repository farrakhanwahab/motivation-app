import 'package:flutter/material.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  final List<String> topics = [
    'Success', 'Health', 'Relationships', 'Mindfulness', 'Productivity', 'Happiness', 'Confidence', 'Resilience',
    'Gratitude', 'Growth', 'Leadership', 'Creativity', 'Focus', 'Courage', 'Wellness', 'Balance', 'Purpose',
    'Discipline', 'Optimism', 'Self-Love', 'Perseverance', 'Kindness', 'Learning', 'Motivation', 'Peace',
  ];
  Set<String> selectedTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topics'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'Select Your Topics',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose the topics you want to receive quotes about.',
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: topics.map((topic) => ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (selectedTopics.contains(topic))
                              const Icon(Icons.check, color: Colors.white, size: 18),
                            if (selectedTopics.contains(topic)) const SizedBox(width: 6),
                            Text(
                              topic,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: selectedTopics.contains(topic) ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      selected: selectedTopics.contains(topic),
                      showCheckmark: false,
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
                    Navigator.pop(context, {'topics': selectedTopics.toList()});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
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