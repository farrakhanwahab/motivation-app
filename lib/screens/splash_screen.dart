import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _letterAnim;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _letterAnim = Tween<double>(begin: 0, end: 2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _controller.forward();
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated glowing orb/light effect
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                final double orbOffset = 30 * (_shimmerController.value - 0.5);
                return Stack(
                  children: [
                    // Main glow
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 100 + orbOffset,
                      top: MediaQuery.of(context).size.height / 2 - 120 - orbOffset,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withAlpha(60),
                              Colors.blueAccent.withAlpha(30),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Secondary smaller orb
                    Positioned(
                      right: MediaQuery.of(context).size.width / 2 - 60 - orbOffset,
                      bottom: MediaQuery.of(context).size.height / 2 - 80 + orbOffset,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.purpleAccent.withAlpha(40),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            // Animated text with shimmer
            AnimatedBuilder(
              animation: Listenable.merge([_controller, _shimmerController]),
              builder: (context, child) {
                final shimmerValue = _shimmerController.value;
                return Opacity(
                  opacity: _fadeAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withAlpha((0.7 * 255).toInt()),
                            Colors.white,
                            Colors.white.withAlpha((0.7 * 255).toInt()),
                          ],
                          stops: [
                            (shimmerValue * 0.5).clamp(0.0, 0.7),
                            (0.5 + shimmerValue * 0.3).clamp(0.3, 1.0),
                            1.0,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Text(
                        'Motivation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          letterSpacing: 2 - _letterAnim.value,
                          shadows: [
                            Shadow(
                              color: Colors.white.withAlpha((0.18 * 255).toInt()),
                              blurRadius: 16,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 