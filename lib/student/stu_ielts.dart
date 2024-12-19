import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class IeltsResourcesPage extends StatefulWidget {
  const IeltsResourcesPage({super.key});

  @override
  State<IeltsResourcesPage> createState() => _IeltsResourcesPageState();
}

class _IeltsResourcesPageState extends State<IeltsResourcesPage> {
  List<dynamic> ieltsResources = [];

  bool _isLaunching = false;

  Future<void> lunchURL(String url) async {
    if (_isLaunching) return;
    _isLaunching = true;

    try {
      // ignore: deprecated_member_use
      if (await launch(url)) {
        _isLaunching = false;
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      _isLaunching = false;
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadIeltsResourcesData();
  }

  Future<void> loadIeltsResourcesData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/stu_ielts_resources.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        ieltsResources = data;
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IELTS Resources"),
      ),
      body: ieltsResources.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ieltsResources.length,
              itemBuilder: (context, index) {
                final resource = ieltsResources[index];
                final videoTitle = resource['title'] ?? 'No title available';
                final videoUrl = resource['url'] ?? '';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  child: Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        lunchURL(videoUrl);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.redAccent, Colors.redAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.video_library,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                videoTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.open_in_browser,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
