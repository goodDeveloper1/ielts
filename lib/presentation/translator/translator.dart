import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _inputController = TextEditingController();
  String _outputText = '';
  bool _isLoading = false;
  final String url = "https://basil-ielts.alwaysdata.net/translate";
  bool _isUzbekToEnglish = true; // true: UZ->EN, false: EN->UZ

  // Example history items

  // Mock translation function
  void _translateText() async {
    if (_inputController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var response = await http.get(
      Uri.https("basil-ielts.alwaysdata.net", "/translate", {
        "text": _inputController.text,
        "source": _isUzbekToEnglish ? "uz_Uz" : "en_US",
        "target": _isUzbekToEnglish ? "en_US" : "uz_Uz",
      }),
    );

    setState(() {
      _outputText = jsonDecode(response.body)["text"];
      _isLoading = false;
    });
  }

  void _swapLanguages() {
    setState(() {
      _isUzbekToEnglish = !_isUzbekToEnglish;
      // Clear the input/output when swapping
      _inputController.clear();
      _outputText = '';
    });
  }

  Future<void> _launchURL() async {
    const url = 'https://t.me/shukhrats_ielts';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
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
          'Translator',
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
      body: Column(
        children: [
          // Language selection header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _isUzbekToEnglish ? 'Uzbek' : 'English',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Source',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.swap_horiz,
                    color: Colors.black.withOpacity(0.7),
                    size: 28,
                  ),
                  onPressed: _swapLanguages,
                  tooltip: 'Swap languages',
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _isUzbekToEnglish ? 'English' : 'Uzbek',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Target',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.02)),
            child: Column(
              children: [
                TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    hintText:
                        _isUzbekToEnglish
                            ? 'Enter text in Uzbek'
                            : 'Enter text in English',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          onPressed: () {
                            _inputController.clear();
                            setState(() {
                              _outputText = '';
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          onPressed: _translateText,
                        ),
                      ],
                    ),
                  ),
                  maxLines: 4,
                  onChanged: (_) {
                    if (_inputController.text.isNotEmpty) {
                      _translateText();
                    } else {
                      setState(() {
                        _outputText = '';
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // Output area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isUzbekToEnglish
                          ? 'English Translation'
                          : 'Uzbek Translation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    if (_outputText.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.content_copy,
                          color: Colors.black.withOpacity(0.6),
                          size: 20,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _outputText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Translation copied to clipboard'),
                              backgroundColor: Colors.black54,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        tooltip: 'Copy translation',
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  constraints: const BoxConstraints(minHeight: 100),
                  child:
                      _isLoading
                          ? Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black.withOpacity(0.5),
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                          : Text(
                            _outputText.isEmpty
                                ? _isUzbekToEnglish
                                    ? 'Enter Uzbek text to translate to English'
                                    : 'Enter English text to translate to Uzbek'
                                : _outputText,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  _outputText.isEmpty
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.8),
                            ),
                          ),
                ),
              ],
            ),
          ),

          // Translation history
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
