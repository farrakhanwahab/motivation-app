import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated vertical lines
            SizedBox(
              height: 60,
              width: 120,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final lineCount = 7;
                  final lineWidth = 6.0;
                  final spacing = 12.0;
                  final lines = List.generate(lineCount, (i) {
                    final t = (_controller.value + i * 0.13) % 1.0;
                    final height = 20 + 30 * (0.5 + 0.5 * (1 - (2 * t - 1).abs()));
                    return Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: i * (lineWidth + spacing)),
                        child: Container(
                          width: lineWidth,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  });
                  return Stack(children: lines);
                },
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Motivation',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 