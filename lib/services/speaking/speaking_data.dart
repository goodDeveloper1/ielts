import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class JsonCacheManager {
  static const Duration cacheDuration = Duration(days: 2);

  static Future fetchFromInternet(String partNumber) async {
    final url = Uri.parse("https://basil-ielts.alwaysdata.net/$partNumber");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch: ${response.statusCode}');
    }
  }

  static Future getJsonWithCache(String fileName, String partNumber) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.json');

    bool isStale = true;

    if (await file.exists()) {
      final modified = await file.lastModified();
      isStale = DateTime.now().difference(modified) > cacheDuration;
    }

    if (!await file.exists() || isStale) {
      try {
        final freshData = await fetchFromInternet(partNumber);
        await file.writeAsString(jsonEncode(freshData));
        print("🌐 Data fetched and cached.");
        return freshData;
      } catch (e) {
        print("❌ Failed to fetch new data: $e");
        if (await file.exists()) {
          final oldContent = await file.readAsString();
          return jsonDecode(oldContent);
        } else {
          throw Exception("🚫 No cache and fetch failed.");
        }
      }
    } else {
      final content = await file.readAsString();
      print("📁 Loaded from cache.");
      return jsonDecode(content);
    }
  }
}
