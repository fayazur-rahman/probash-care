import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RelevantCoursesPage extends StatefulWidget {
  final String selectedCountry;
  final String selectedJob;

  const RelevantCoursesPage({
    Key? key,
    required this.selectedCountry,
    required this.selectedJob,
  }) : super(key: key);

  @override
  State<RelevantCoursesPage> createState() => _RelevantCoursesPageState();
}

class _RelevantCoursesPageState extends State<RelevantCoursesPage> {
  List<dynamic> relevantCourses = [];
  List<dynamic> filteredCourses = [];

  bool _isLaunching = false;

  Future<void> launchURL(String url) async {
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
    loadRelevantCoursesData();
  }

  Future<void> loadRelevantCoursesData() async {
    try {
      final String response =
      await rootBundle.loadString('assets/labour_relevant_courses.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        relevantCourses = data;
        filteredCourses = relevantCourses
            .where((course) =>
        course['type']?.toString().toLowerCase() ==
            widget.selectedJob.toLowerCase())
            .toList();
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relevant Courses"),
      ),
      body: relevantCourses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              filteredCourses.isNotEmpty
                  ? 'Showing courses for "${widget.selectedJob}"'
                  : 'Sorry! No relevant courses available for "${widget.selectedJob}".',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (filteredCourses.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = filteredCourses[index];
                  final courseTitle = course['title'] ?? 'No title available';
                  final courseUrl = course['url'] ?? '';

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
                          launchURL(courseUrl);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal, Colors.blueGrey],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  courseTitle,
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
            ),
        ],
      ),
    );
  }
}
