import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myapp/presentation/home/home.dart';

class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({super.key});

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage>
    with SingleTickerProviderStateMixin {
  // Countdown timer values
  int days = 14;
  int hours = 23;
  int minutes = 59;
  int seconds = 59;
  late Timer _timer;

  // Animation controller for the CTA button
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Set up the timer
    _startTimer();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 40),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_animationController);

    // Start the animation and repeat it
    _animationController.repeat();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          seconds = 59;
          if (minutes > 0) {
            minutes--;
          } else {
            minutes = 59;
            if (hours > 0) {
              hours--;
            } else {
              hours = 23;
              if (days > 0) {
                days--;
              } else {
                // Timer completed
                timer.cancel();
              }
            }
          }
        }
      });
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    // In a real app, this would navigate to your home page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigating to home page...',
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Simulate navigation after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      // For this demo, we'll just reset the state to simulate going to a new page
      setState(() {
        days = 14;
        hours = 23;
        minutes = 59;
        seconds = 59;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.9),
                ),
                child: Center(
                  child: Text(
                    "IELTS",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Coming Soon text
              Text(
                "COMING SOON",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "We're working hard to bring you something amazing. Stay tuned for updates.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Countdown timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeBlock(days.toString().padLeft(2, '0'), "DAYS"),
                  _buildTimeSeparator(),
                  _buildTimeBlock(hours.toString().padLeft(2, '0'), "HOURS"),
                  _buildTimeSeparator(),
                  _buildTimeBlock(
                    minutes.toString().padLeft(2, '0'),
                    "MINUTES",
                  ),
                  _buildTimeSeparator(),
                  _buildTimeBlock(
                    seconds.toString().padLeft(2, '0'),
                    "SECONDS",
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // Email subscription field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your email for updates",
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.arrow_forward,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // CTA Button with animation
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: GestureDetector(
                        onTap: _navigateToHome,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            "GO TO HOME",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // Footer
              Text(
                "© 2025 Shukhrat's TEAM. All rights reserved.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBlock(String value, String label) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }
}
