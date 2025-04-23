import 'package:flutter/material.dart';
import 'package:myapp/presentation/speaking/card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/components/row_example.dart';

class SpeakingPage extends StatelessWidget {
  const SpeakingPage({super.key});

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
          'IELTS Speaking',
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
              "1",
              "Part One",
              "Sample part one questions",
              Colors.black87,
              _redirect(context, SpeakingTestPage(partNumber: 1)),
            ),
            CustomRowWidget(
              "2",
              "Part Two",
              "Sample part two questions",
              Colors.black87,
              _redirect(context, SpeakingTestPage(partNumber: 2)),
            ),
            CustomRowWidget(
              "3",
              "Part three",
              "Sample part three questions",
              Colors.black87,
              _redirect(context, SpeakingTestPage(partNumber: 3)),
            ),
          ],
        ),
      ),
    );
  }
}
