import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpeakingTestPage extends StatefulWidget {
  final int partNumber;

  const SpeakingTestPage({super.key, required this.partNumber});

  @override
  State<SpeakingTestPage> createState() => _SpeakingTestPageState();
}

class _SpeakingTestPageState extends State<SpeakingTestPage> {
  Map<String, dynamic> _speakingTopics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var data = await JsonCacheManager.getJsonWithCache(
      "part_${widget.partNumber}",
      widget.partNumber,
    );
    List<String> _expandHashedString(String s) {
      return [s]; // Placeholder logic
    }

    for (var topic in data.values) {
      for (var field in ['questions', 'vocabulary', 'ideas', 'answers']) {
        var originalList = topic[field];
        if (originalList is List<String>) {
          var newList = <String>[];
          for (var string_ in originalList) {
            if (string_.contains('#')) {
              newList.addAll(_expandHashedString(string_));
            } else {
              newList.add(string_);
            }
          }
          topic[field] = newList;
        }
      }
    }

    setState(() {
      _speakingTopics = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(strokeWidth: 3),
              SizedBox(height: 16),
              Text(
                "Loading genius content...",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("IELTS Speaking Part ${widget.partNumber}"),
      ),
      body: ListView.builder(
        itemCount: _speakingTopics.length,
        itemBuilder: (context, index) {
          String topicKey = _speakingTopics.keys.elementAt(index);
          Map<String, dynamic> topicData = _speakingTopics[topicKey];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ExpansionTile(
              title: Text(topicKey, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                for (var section in ['questions', 'vocabulary', 'ideas', 'answers'])
                  if (topicData[section] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.toUpperCase(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ...List.generate(
                            topicData[section].length,
                            (i) => Text("— ${topicData[section][i]}"),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class JsonCacheManager {
  static final Map<String, Map<String, dynamic>> _cache = {};

  static Future<Map<String, dynamic>> getJsonWithCache(String key, int partNumber) async {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final data = await rootBundle.loadString("assets/ielts/part_$partNumber.json");
    final decodedData = jsonDecode(data) as Map<String, dynamic>;

    _cache[key] = decodedData;
    return decodedData;
  }
}
