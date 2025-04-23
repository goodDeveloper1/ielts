import 'package:flutter/material.dart';
import 'package:myapp/services/speaking/speaking_data.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SpeakingTestPage extends StatefulWidget {
  final String partNumber;
  const SpeakingTestPage({super.key, required this.partNumber});

  @override
  State<SpeakingTestPage> createState() => _SpeakingTestPageState();
}

class _SpeakingTestPageState extends State<SpeakingTestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTopicIndex = 0;
  List _speakingTopics = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  void _loadData() async {
    var data = await JsonCacheManager.getJsonWithCache(
      "part_${widget.partNumber}",
      widget.partNumber,
    );
    setState(() {
      _speakingTopics = data;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    final selectedTopic = _speakingTopics[_selectedTopicIndex];

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
      body: Column(
        children: [
          // Topic selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _speakingTopics.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedTopicIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTopicIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.black.withOpacity(0.8)
                              : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _speakingTopics[index]['name'],
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.7),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Topic title and questions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.topic_outlined,
                      size: 24,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedTopic['title'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Questions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  selectedTopic['questions'].length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            selectedTopic['questions'][index],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.5),
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Vocabulary'),
                Tab(text: 'Ideas'),
                Tab(text: 'Answers'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Vocabulary tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Useful Vocabulary for ${selectedTopic['title']}:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        selectedTopic['vocabulary'].length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    children: _formatVocabularyItem(
                                      selectedTopic['vocabulary'][index],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Ideas tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Ideas for ${selectedTopic['title']}:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        selectedTopic['ideas'].length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  selectedTopic['ideas'][index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 18,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Speaking Tip',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try to develop each idea with personal examples or experiences. This shows the examiner you can elaborate on topics and express complex thoughts.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Answers tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sample Answers:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        selectedTopic['answers'].length,
                        (index) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Q: ${selectedTopic['questions'][index]}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedTopic['answers'][index],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.mic_outlined,
                                  size: 18,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Practice Makes Perfect',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Remember that these are sample answers. Try to adapt them using your own ideas and experiences. Record yourself speaking to improve your fluency and pronunciation.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _formatVocabularyItem(String text) {
    // Split the vocabulary item into word and definition
    final parts = text.split(' - ');
    if (parts.length != 2) {
      return [TextSpan(text: text)];
    }

    // Extract word and type (in parentheses)
    final wordParts = parts[0].split(' ');
    final lastPart = wordParts.last;

    if (lastPart.startsWith('(') && lastPart.endsWith(')')) {
      // Format with word type
      return [
        TextSpan(
          text: '${wordParts.sublist(0, wordParts.length - 1).join(' ')} ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: '$lastPart - ',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        TextSpan(text: parts[1]),
      ];
    } else {
      // Format without word type
      return [
        TextSpan(
          text: '${parts[0]} - ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: parts[1]),
      ];
    }
  }
}
