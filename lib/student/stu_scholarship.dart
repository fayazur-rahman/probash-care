import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ScholarshipOpportunitiesPage extends StatefulWidget {
  final String selectedCountry;
  final String selectedDegree;

  const ScholarshipOpportunitiesPage({
    Key? key,
    required this.selectedCountry,
    required this.selectedDegree,
  }) : super(key: key);

  @override
  State<ScholarshipOpportunitiesPage> createState() =>
      _ScholarshipOpportunitiesPageState();
}

class _ScholarshipOpportunitiesPageState
    extends State<ScholarshipOpportunitiesPage> {
  List<dynamic> scholarships = [];
  bool _isLaunching = false;

  // Launch URL function
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

  // Load scholarship data from the JSON file
  @override
  void initState() {
    super.initState();
    loadScholarshipData();
  }

  Future<void> loadScholarshipData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/stu_scholarship_info.json');
      final List<dynamic> data = json.decode(response);
      // Filter data based on selectedCountry and selectedDegree
      setState(() {
        scholarships = data.where((agency) {
          final countryMatch = agency['country']?.toString().toLowerCase() ==
              widget.selectedCountry.toLowerCase();
          final degreeMatch = agency['degree']?.toString().toLowerCase() ==
              widget.selectedDegree.toLowerCase();
          return countryMatch && degreeMatch;
        }).toList();
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scholarship Opportunities"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Showing results for ${widget.selectedDegree} opportunities in ${widget.selectedCountry}',
              style: const TextStyle(
                fontSize: 14,
                //fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: scholarships.isEmpty
                ? const Center(
                    child: Text(
                      'Oops! Information not available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    // Wrapping with SingleChildScrollView
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap:
                            true, // Makes GridView take up only as much space as it needs
                        physics:
                            NeverScrollableScrollPhysics(), // Disable GridView scroll
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 1.9,
                        ),
                        itemCount: scholarships.length,
                        itemBuilder: (context, index) {
                          final scholarship = scholarships[index];
                          final name =
                              scholarship['name'] ?? 'No name available';
                          final description = scholarship['description'] ??
                              'No description available';

                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade500,
                                  Colors.blue.shade200
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                // Row to align button to the right
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            title: Text(name),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Description:",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(description),
                                                const SizedBox(height: 12),
                                                Text(
                                                  "Application Link:",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    launchURL(
                                                        scholarship['link'] ??
                                                            '');
                                                  },
                                                  child: Text(
                                                    scholarship['link'] ??
                                                        'No application link available',
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Close"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.info),
                                      label: const Text("Details"),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Colors.deepPurple.shade600,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
