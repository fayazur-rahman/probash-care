import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HotTopicsPage extends StatefulWidget {
  const HotTopicsPage({super.key});

  @override
  State<HotTopicsPage> createState() => _HotTopicsPageState();
}

class _HotTopicsPageState extends State<HotTopicsPage> {
  List<Map<String, dynamic>> allTopics = [];
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
    loadAllTopicsFromFirestore();
  }

  // Fetch all topics from Firestore
  Future<void> loadAllTopicsFromFirestore() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('hottopics').get();

      final List<Map<String, dynamic>> topics = querySnapshot.docs.map((doc) {
        return {
          'title': doc['title'] ?? 'Untitled',
          'category': doc['category'] ?? 'Uncategorized',
          'date': doc['date'] ?? '',
          'url': doc['url'] ?? '',
        };
      }).toList();

      setState(() {
        allTopics = topics.reversed.toList(); // Reverse to maintain the order
      });
    } catch (e) {
      print('Error fetching Firestore data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hot Topics"),
        centerTitle: true,
      ),
      body: allTopics.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allTopics.length,
              itemBuilder: (context, index) {
                final topic = allTopics[index];
                return ListTile(
                  leading:
                      const Icon(Icons.article_outlined, color: Colors.blue),
                  title: Text(
                    topic['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text("Category: ${topic['category']} \n${topic['date']}"),
                  onTap: () async {
                    lunchURL(topic['url']);
                  },
                );
              },
            ),
    );
  }
}
