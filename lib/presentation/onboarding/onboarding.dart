import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:myapp/presentation/home/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<String> _typingTexts = [
    "Ace IELTS Like a Pro",
    "IELTS Mastery in Your Pocket",
    "Nail IELTS, Every Time",
  ];
  int _currentTextIndex = 0;
  String _currentDisplayText = "";
  int _currentCharIndex = 0;
  bool _isDeleting = false;
  bool _isPaused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for gradient
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Start typewriter effect
    _startTypewriter();
  }

  void _startTypewriter() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_isPaused) {
          return;
        }

        if (_isDeleting) {
          if (_currentCharIndex > 0) {
            _currentCharIndex--;
            _currentDisplayText = _typingTexts[_currentTextIndex].substring(
              0,
              _currentCharIndex,
            );
          } else {
            _isDeleting = false;
            _currentTextIndex = (_currentTextIndex + 1) % _typingTexts.length;
            _isPaused = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  _isPaused = false;
                });
              }
            });
          }
        } else {
          if (_currentCharIndex < _typingTexts[_currentTextIndex].length) {
            _currentCharIndex++;
            _currentDisplayText = _typingTexts[_currentTextIndex].substring(
              0,
              _currentCharIndex,
            );
          } else {
            _isPaused = true;
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                setState(() {
                  _isPaused = false;
                  _isDeleting = true;
                });
              }
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HSLColor.fromAHSL(
                    1.0,
                    (_animationController.value * 360).toDouble(),
                    0.8,
                    0.2,
                  ).toColor(),
                  HSLColor.fromAHSL(
                    1.0,
                    ((_animationController.value * 360) + 60) % 360,
                    0.8,
                    0.3,
                  ).toColor(),
                  HSLColor.fromAHSL(
                    1.0,
                    ((_animationController.value * 360) + 120) % 360,
                    0.9,
                    0.2,
                  ).toColor(),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Neon typewriter text
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      _currentDisplayText,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          // Neon effect using multiple shadows
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: Colors.blue.withOpacity(0.8),
                            blurRadius: 20,
                          ),
                          Shadow(
                            color: Colors.purpleAccent.withOpacity(0.6),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Black Get Started button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement saving onboard = DOne in shared preferances
                      // Redirect user
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      shadowColor: Colors.purple.withOpacity(0.5),
                    ),
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Footer with Telegram link
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: RichText(
                      text: TextSpan(
                        text: 'Powered by ',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Shukhratʼs TEAM LC',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () async {
                                    final Uri url = Uri.parse(
                                      'https://t.me/shukhrats_ielts',
                                    );
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
