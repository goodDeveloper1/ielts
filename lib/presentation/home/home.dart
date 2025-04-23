import 'package:flutter/material.dart';
import 'package:myapp/presentation/bs_estimator/bs_estimator.dart';
import 'package:myapp/presentation/coming_soon/coming_soon.dart';
import 'package:myapp/presentation/speaking/speaking.dart';
import 'package:myapp/presentation/translator/translator.dart';
import 'package:myapp/presentation/wordlist/ac_wordlist.dart';
import 'package:myapp/presentation/writing/writing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/components/row_example.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  _redirect(BuildContext context, Widget widget) {
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
    };
  }

  Future<void> _launchURL() async {
    const url = 'https://t.me/shukhrats_ielts';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'IELTS',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomRowWidget(
              'B',
              'Band score estimator',
              'Check your proficiency',
              Colors.black,
              _redirect(context, BandScoreEstimator()),
            ),
            CustomRowWidget(
              'A',
              'Academic Wordlist',
              'Comprehensive Dictionary',
              Colors.black,
              _redirect(context, DictionaryPage()),
            ),
            CustomRowWidget(
              'S',
              'Speaking Practice',
              'Check out common questions',
              Colors.black,
              _redirect(context, SpeakingPage()),
            ),
            CustomRowWidget(
              'I',
              'Insight Accelerator',
              'Coming soon',
              Colors.black26,
              _redirect(context, ComingSoonPage()),
            ),
            CustomRowWidget(
              'L',
              'Listening Practice',
              'Coming soon',
              Colors.black26,
              _redirect(context, ComingSoonPage()),
            ),
            CustomRowWidget(
              "W",
              "Writing reviewer",
              "Use AI to check how well you have written",
              Colors.black87,
              _redirect(context, WritingReviewPage()),
            ),
            CustomRowWidget(
              "UE",
              "Uzbek-English Translator",
              "Simple, Fast, Easy to use",
              Colors.black87,
              _redirect(context, TranslationPage()),
            ),
          ],
        ),
      ),
    );
  }
}
