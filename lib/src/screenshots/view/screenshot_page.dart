import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:vision_intelligence/common/widgets/custom_appbar.dart';

class ScreenshotPage extends StatefulWidget {
  const ScreenshotPage({super.key});

  @override
  State<ScreenshotPage> createState() => _ScreenshotPageState();
}

class _ScreenshotPageState extends State<ScreenshotPage> {
  final String serverIP = 'http://192.168.1.97:5000'; // Update to match your backend
  Map<String, List<String>> groupedImages = {}; // stores local file paths
  bool isLoading = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchScreenshots();
    timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchScreenshots());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<String> _getStoragePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<void> fetchScreenshots() async {
    try {
      final response = await http.get(Uri.parse('$serverIP/alerts'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final storagePath = await _getStoragePath();
        final box = await Hive.openBox('screenshotsBox');

        Map<String, List<String>> newGroupedImages = {};

        for (var item in data) {
          final timestamp = DateTime.parse(item['timestamp']);
          final dateKey = "${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}";
          final imageUrl = '$serverIP${item['url']}';

          final filename = p.basename(imageUrl);
          final localPath = p.join(storagePath, filename);
          final file = File(localPath);

          // Download if doesn't exist
          if (!await file.exists()) {
            final imageResponse = await http.get(Uri.parse(imageUrl));
            await file.writeAsBytes(imageResponse.bodyBytes);
          }

          newGroupedImages.putIfAbsent(dateKey, () => []).add(localPath);
        }

        // Save metadata to Hive
        await box.put('screenshots', newGroupedImages);

        setState(() {
          groupedImages = newGroupedImages;
          isLoading = false;
        });
      } else {
        _loadFromHive();
      }
    } catch (e) {
      print("Error fetching screenshots: $e");
      _loadFromHive(); // fallback
    }
  }

  Future<void> _loadFromHive() async {
    final box = await Hive.openBox('screenshotsBox');
    final storedData = box.get('screenshots');

    if (storedData != null) {
      Map<String, List<String>> loaded = Map<String, List<String>>.from(
        (storedData as Map).map((key, value) =>
            MapEntry<String, List<String>>(key, List<String>.from(value))),
      );

      setState(() {
        groupedImages = loaded;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> sortedDates = groupedImages.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Latest first

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            CustomAppbar(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : groupedImages.isEmpty
                    ? const Center(child: Text("No screenshots yet", style: TextStyle(fontSize: 18)))
                    : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, dateIndex) {
                    final date = sortedDates[dateIndex];
                    final images = groupedImages[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 20),
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: images.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                File(images[index]),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey,
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
