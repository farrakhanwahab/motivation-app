import 'package:flutter/material.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  final List<String> topics = [
    'Success', 'Health', 'Relationships', 'Mindfulness', 'Productivity', 'Happiness', 'Confidence', 'Resilience',
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
                  const Text('Select Topics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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