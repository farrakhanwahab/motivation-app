import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  TimeOfDay? selectedTime;

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
      appBar: AppBar(title: const Text('Preferred Time'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text('Select Preferred Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(formattedTime, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14)),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 120,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _showCupertinoTimePicker,
                          child: const Text('Pick Time'),
                        ),
                      ),
                    ],
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
                    Navigator.pop(context, {'time': selectedTime != null ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}' : null});
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