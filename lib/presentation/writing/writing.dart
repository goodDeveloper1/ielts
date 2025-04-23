import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:url_launcher/url_launcher_string.dart';

class WritingReviewPage extends StatefulWidget {
  const WritingReviewPage({super.key});

  @override
  State<WritingReviewPage> createState() => _WritingReviewPageState();
}

class _WritingReviewPageState extends State<WritingReviewPage> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _essayController = TextEditingController();
  final String url = "https://basil-ielts.alwaysdata.net/evaluate";
  bool _isLoading = false;
  bool _hasResult = false;
  String _score = "";
  String _explanation = "";

  Future<void> _launchURL() async {
    const url = 'https://t.me/shukhrats_ielts';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _submitEssay() async {
    if (_promptController.text.isEmpty || _essayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both prompt and essay'),
          backgroundColor: Colors.black54,
        ),
      );
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
      _hasResult = false;
    });

    var response = await http.get(
      Uri.https("basil-ielts.alwaysdata.net", "/evaluate", {
        "essay": _essayController.text,
        "essay_prompt": _promptController.text,
      }),
    );
    setState(() {
      _isLoading = false;
      _hasResult = true;
      _score = jsonDecode(response.body)["potential_score"];
      _explanation = jsonDecode(response.body)["detailed_explanation"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'IELTS Writing Review',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.headset, color: Colors.black),
            onPressed: _launchURL,
            tooltip: 'Customer Support',
          ),
        ],
      ),
      body: _hasResult ? _buildResultView() : _buildInputView(),
    );
  }

  Widget _buildInputView() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'IELTS Writing Assessment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your essay prompt and response for AI evaluation',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Essay Prompt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _promptController,
                decoration: InputDecoration(
                  hintText: 'Enter the essay question/prompt',
                  fillColor: Colors.black.withOpacity(0.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Text(
                'Your Essay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _essayController,
                decoration: InputDecoration(
                  hintText:
                      'Write your complete essay here (250+ words recommended)',
                  fillColor: Colors.black.withOpacity(0.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 12,
                textAlignVertical: TextAlignVertical.top,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitEssay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Analyze My Essay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Our AI will evaluate your essay based on the official IELTS criteria',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Analyzing your essay...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Evaluating against IELTS criteria',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultView() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Your IELTS Writing Score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.black.withOpacity(0.1),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _score,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Band Score',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Detailed Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withOpacity(0.1)),
                  ),
                  child: SingleChildScrollView(
                    child: Html(
                      data: _explanation, // This should be valid HTML content
                      style: {
                        "body": Style(
                          fontSize: FontSize(14),
                          color: Colors.black.withOpacity(0.7),
                        ),
                        "h1": Style(
                          fontSize: FontSize(20),
                          color: Colors.black.withOpacity(0.9),
                        ),
                        "h2": Style(
                          fontSize: FontSize(18),
                          color: Colors.black.withOpacity(0.85),
                        ),
                        "h3": Style(
                          fontSize: FontSize(16),
                          color: Colors.black.withOpacity(0.8),
                        ),
                        "strong": Style(
                          color: Colors.black.withOpacity(0.9),
                        ),
                        "li": Style(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasResult = false;
                    _score = "";
                    _explanation = "";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Another Essay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

  @override
  void dispose() {
    _promptController.dispose();
    _essayController.dispose();
    super.dispose();
  }
}
