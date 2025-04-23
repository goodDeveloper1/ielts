import 'package:flutter/material.dart';
import 'package:myapp/presentation/wordlist/word_data.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _dictionaryItems = [
    {
      'word': 'Ameliorate',
      'definition': 'Make something bad better',
      'example':
          'The new policy should ameliorate the current economic situation.',
      'type': 'verb',
    },
    {
      'word': 'Benevolent',
      'definition': 'Kind and generous',
      'example': 'The benevolent donor gave millions to charity.',
      'type': 'adjective',
    },
    {
      'word': 'Cacophony',
      'definition': 'A harsh mixture of sounds',
      'example':
          'The cacophony of the busy street made it difficult to concentrate.',
      'type': 'noun',
    },
    {
      'word': 'Diligent',
      'definition': 'Working hard and carefully',
      'example': 'She was diligent in her preparation for the IELTS exam.',
      'type': 'adjective',
    },
    {
      'word': 'Eloquent',
      'definition': 'Fluent and persuasive in speaking or writing',
      'example': 'His eloquent speech convinced everyone in the room.',
      'type': 'adjective',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_searchQuery.isEmpty) {
      return _dictionaryItems;
    }
    return _dictionaryItems
        .where(
          (item) =>
              item['word'].toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
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
          'IELTS Dictionary',
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
          // Search input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for words',
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black54),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
                fillColor: Colors.black.withOpacity(0.05),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
            ),
          ),

          // Dictionary items list
          Expanded(
            child:
                _filteredItems.isEmpty
                    ? Center(
                      child: Text(
                        'No words found matching "$_searchQuery"',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final opacity = 1.0;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WordPage(item['word']),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['word'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(
                                          opacity,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        item['type'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(
                                            opacity,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['definition'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(
                                      opacity * 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Example: "${item['example']}"',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black.withOpacity(
                                      opacity * 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
