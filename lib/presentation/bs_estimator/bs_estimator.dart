import 'package:flutter/material.dart';

class BandScoreEstimator extends StatefulWidget {
  const BandScoreEstimator({super.key});

  @override
  State<BandScoreEstimator> createState() => _BandScoreEstimatorState();
}

class _BandScoreEstimatorState extends State<BandScoreEstimator>
    with TickerProviderStateMixin {
  double listeningScore = 6.0;
  double readingScore = 6.0;
  double speakingScore = 6.0;
  double writingScore = 6.0;
  double overallScore = 6.0;

  // Controllers for animations
  late AnimationController _listeningController;
  late AnimationController _readingController;
  late AnimationController _speakingController;
  late AnimationController _writingController;
  late AnimationController _resultController;

  // Animations
  late Animation<double> _listeningAnimation;
  late Animation<double> _readingAnimation;
  late Animation<double> _speakingAnimation;
  late Animation<double> _writingAnimation;
  late Animation<double> _resultAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _listeningController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _readingController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _speakingController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _writingController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Set up animations
    _listeningAnimation = CurvedAnimation(
      parent: _listeningController,
      curve: Curves.easeInOut,
    );

    _readingAnimation = CurvedAnimation(
      parent: _readingController,
      curve: Curves.easeInOut,
    );

    _speakingAnimation = CurvedAnimation(
      parent: _speakingController,
      curve: Curves.easeInOut,
    );

    _writingAnimation = CurvedAnimation(
      parent: _writingController,
      curve: Curves.easeInOut,
    );

    _resultAnimation = CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    );

    // Calculate overall score initially
    calculateOverallScore();

    // Run the result animation once at startup
    _resultController.forward();
  }

  @override
  void dispose() {
    _listeningController.dispose();
    _readingController.dispose();
    _speakingController.dispose();
    _writingController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void calculateOverallScore() {
    // IELTS overall score is the average of the four scores, rounded to the nearest 0.5
    double average =
        (listeningScore + readingScore + speakingScore + writingScore) / 4;

    // Round to nearest 0.5
    overallScore = (average * 2).round() / 2;

    // Animate the result
    _resultController.reset();
    _resultController.forward();
  }

  String getBandDescription(double score) {
    if (score >= 9.0) {
      return "Expert";
    } else if (score >= 8.0) {
      return "Very Good";
    } else if (score >= 7.0) {
      return "Good";
    } else if (score >= 6.0) {
      return "Competent";
    } else if (score >= 5.0) {
      return "Modest";
    } else if (score >= 4.0) {
      return "Limited";
    } else if (score >= 3.0) {
      return "Extremely Limited";
    } else if (score >= 2.0) {
      return "Intermittent";
    } else {
      return "Non User";
    }
  }

  // Get a color based on score
  Color getScoreColor(double score) {
    if (score >= 8.0) {
      return Colors.black;
    } else if (score >= 7.0) {
      return Colors.black.withOpacity(0.8);
    } else if (score >= 6.0) {
      return Colors.black.withOpacity(0.7);
    } else if (score >= 5.0) {
      return Colors.black.withOpacity(0.6);
    } else {
      return Colors.black.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Band Score Estimator',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Added SingleChildScrollView to allow scrolling
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your estimated scores:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Score selectors
                ScoreSelector(
                  title: 'Listening',
                  score: listeningScore,
                  animation: _listeningAnimation,
                  onTap: () {
                    if (_listeningController.status ==
                        AnimationStatus.completed) {
                      _listeningController.reverse();
                    } else {
                      _listeningController.forward();
                      _readingController.reverse();
                      _speakingController.reverse();
                      _writingController.reverse();
                    }
                  },
                  onScoreChanged: (value) {
                    setState(() {
                      listeningScore = value;
                      calculateOverallScore();
                    });
                  },
                ),

                const SizedBox(height: 16),

                ScoreSelector(
                  title: 'Reading',
                  score: readingScore,
                  animation: _readingAnimation,
                  onTap: () {
                    if (_readingController.status ==
                        AnimationStatus.completed) {
                      _readingController.reverse();
                    } else {
                      _readingController.forward();
                      _listeningController.reverse();
                      _speakingController.reverse();
                      _writingController.reverse();
                    }
                  },
                  onScoreChanged: (value) {
                    setState(() {
                      readingScore = value;
                      calculateOverallScore();
                    });
                  },
                ),

                const SizedBox(height: 16),

                ScoreSelector(
                  title: 'Speaking',
                  score: speakingScore,
                  animation: _speakingAnimation,
                  onTap: () {
                    if (_speakingController.status ==
                        AnimationStatus.completed) {
                      _speakingController.reverse();
                    } else {
                      _speakingController.forward();
                      _listeningController.reverse();
                      _readingController.reverse();
                      _writingController.reverse();
                    }
                  },
                  onScoreChanged: (value) {
                    setState(() {
                      speakingScore = value;
                      calculateOverallScore();
                    });
                  },
                ),

                const SizedBox(height: 16),

                ScoreSelector(
                  title: 'Writing',
                  score: writingScore,
                  animation: _writingAnimation,
                  onTap: () {
                    if (_writingController.status ==
                        AnimationStatus.completed) {
                      _writingController.reverse();
                    } else {
                      _writingController.forward();
                      _listeningController.reverse();
                      _readingController.reverse();
                      _speakingController.reverse();
                    }
                  },
                  onScoreChanged: (value) {
                    setState(() {
                      writingScore = value;
                      calculateOverallScore();
                    });
                  },
                ),

                const SizedBox(height: 32), // Additional spacing before result
                // Overall result
                AnimatedBuilder(
                  animation: _resultAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_resultAnimation.value * 0.2),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Estimated Overall Band Score',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  overallScore.toString(),
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: getScoreColor(overallScore),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '/ 9.0',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              getBandDescription(overallScore),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: getScoreColor(overallScore),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Description text
                Text(
                  'Tap on each section to select your score. Your overall band score is the average of the four individual scores, rounded to the nearest 0.5.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.6),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreSelector extends StatefulWidget {
  final String title;
  final double score;
  final Animation<double> animation;
  final VoidCallback onTap;
  final Function(double) onScoreChanged;

  const ScoreSelector({
    super.key,
    required this.title,
    required this.score,
    required this.animation,
    required this.onTap,
    required this.onScoreChanged,
  });

  @override
  _ScoreSelectorState createState() => _ScoreSelectorState();
}

class _ScoreSelectorState extends State<ScoreSelector> {
  List<double> scoreOptions = [
    4.5,
    5.0,
    5.5,
    6.0,
    6.5,
    7.0,
    7.5,
    8.0,
    8.5,
    9.0,
  ];
  double? selectedScore;

  @override
  void initState() {
    super.initState();
    selectedScore = widget.score; // Initialize with the current score
  }

  // Get a color based on score
  Color getScoreColor(double score) {
    if (score >= 8.0) {
      return Colors.black;
    } else if (score >= 7.0) {
      return Colors.black.withOpacity(0.8);
    } else if (score >= 6.0) {
      return Colors.black.withOpacity(0.7);
    } else if (score >= 5.0) {
      return Colors.black.withOpacity(0.6);
    } else {
      return Colors.black.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: getScoreColor(widget.score),
                  ),
                ),
                const Spacer(),
                DropdownButton<double>(
                  value: selectedScore,
                  onChanged: (newScore) {
                    setState(() {
                      selectedScore = newScore;
                      widget.onScoreChanged(
                        newScore!,
                      ); // Notify the parent widget
                    });
                  },
                  items:
                      scoreOptions.map((score) {
                        return DropdownMenuItem<double>(
                          value: score,
                          child: Text(
                            score.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: getScoreColor(score),
                            ),
                          ),
                        );
                      }).toList(),
                  underline:
                      const SizedBox(), // Hide the underline for the dropdown
                  isExpanded:
                      false, // Make sure the dropdown doesn't expand to full width
                ),
                // const Icon(Icons.arrow_drop_down, color: Colors.black54),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
