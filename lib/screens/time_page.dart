import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  TimeOfDay? selectedTime;

  String get formattedTime {
    final now = DateTime.now();
    final time = selectedTime ?? const TimeOfDay(hour: 6, minute: 0);
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt); // 12-hour format
  }

  void _showCupertinoTimePicker() {
    final now = TimeOfDay.now();
    final initial = selectedTime ?? const TimeOfDay(hour: 6, minute: 0);
    final initialDateTime = DateTime(0, 0, 0, initial.hour, initial.minute);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        DateTime tempPicked = initialDateTime;
        return SafeArea(
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
                  child: const Text('Set Time', style: TextStyle(fontFamily: 'Montserrat')),
                  onPressed: () {
                    setState(() {
                      selectedTime = TimeOfDay(hour: tempPicked.hour, minute: tempPicked.minute);
                    });
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                ),
              ],
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "This is when you'll receive your daily quote.",
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Montserrat'),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 180,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _showCupertinoTimePicker,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Change Time', style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w600, height: 1.2)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final time = selectedTime ?? const TimeOfDay(hour: 6, minute: 0);
                    Navigator.pop(context, {'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}' });
                  },
                  style: AppTheme.iosButtonStyle,
                  child: const Text('Save', style: TextStyle(fontFamily: 'Montserrat')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 