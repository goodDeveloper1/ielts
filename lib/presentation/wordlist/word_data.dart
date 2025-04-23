import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:just_audio/just_audio.dart';

extension CapitalizeExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class WordPage extends StatefulWidget {
  final String word;

  const WordPage(this.word, {super.key});

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  Map<String, dynamic>? wordData;
  bool loaded = false;
  bool isLoading = true;
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadWordData();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void loadWordData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "https://api.dictionaryapi.dev/api/v2/entries/en/${widget.word}",
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          wordData = (jsonDecode(response.body) as List)[0];
          isLoading = false;
          loaded = true;
        });
      } else {
        // Handle non-200 responses
        setState(() {
          isLoading = false;
        });
        print('Failed to load word data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching word data: $e');
    }
  }

  Future<void> playAudio(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No audio available')));
      return;
    }

    try {
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dictionary',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          !loaded
              ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
              : isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Word heading
                    Text(
                      wordData!['word'].toString().capitalize(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Phonetics
                    if (wordData!['phonetics'] != null &&
                        (wordData!['phonetics'] as List).isNotEmpty)
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: List.generate(
                          (wordData!['phonetics'] as List).length,
                          (index) {
                            final phonetic = wordData!['phonetics'][index];
                            return InkWell(
                              onTap:
                                  phonetic['audio'] != null &&
                                          phonetic['audio'] != ''
                                      ? () => playAudio(phonetic['audio'])
                                      : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (phonetic['text'] != null &&
                                        phonetic['text'].isNotEmpty)
                                      Text(
                                        phonetic['text'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                    if (phonetic['audio'] != null &&
                                        phonetic['audio'].isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.volume_up,
                                        size: 18,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 30),

                    // Meanings
                    if (wordData!['meanings'] != null)
                      ...List.generate((wordData!['meanings'] as List).length, (
                        index,
                      ) {
                        final meaning = wordData!['meanings'][index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Part of speech
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                meaning['partOfSpeech'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),

                            // Definitions
                            if (meaning['definitions'] != null)
                              ...List.generate(
                                (meaning['definitions'] as List).length,
                                (defIndex) {
                                  final definition =
                                      meaning['definitions'][defIndex];
                                  return Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 16,
                                      left: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${defIndex + 1}. ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black.withOpacity(
                                                  0.7,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                definition['definition'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Example if available
                                        if (definition['example'] != null &&
                                            definition['example'].isNotEmpty)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 8,
                                              left: 16,
                                            ),
                                            child: Text(
                                              '"${definition['example']}"',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                                color: Colors.black.withOpacity(
                                                  0.6,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                            // Synonyms
                            if (meaning['synonyms'] != null &&
                                (meaning['synonyms'] as List).isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 12,
                                  top: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Synonyms:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: List.generate(
                                        (meaning['synonyms'] as List).length,
                                        (synIndex) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            meaning['synonyms'][synIndex],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Antonyms
                            if (meaning['antonyms'] != null &&
                                (meaning['antonyms'] as List).isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 12,
                                  top: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Antonyms:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: List.generate(
                                        (meaning['antonyms'] as List).length,
                                        (antIndex) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            meaning['antonyms'][antIndex],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const Divider(height: 40),
                          ],
                        );
                      }),

                    // Source and license info
                    if (wordData!['sourceUrls'] != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Source:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (wordData!['sourceUrls'] as List).join(', '),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),

                            if (wordData!['license'] != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'License: ${wordData!['license']['name']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
