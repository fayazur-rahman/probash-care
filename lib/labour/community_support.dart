import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CommunitySupportPage extends StatefulWidget {
  final String selectedCountry;
  final String selectedJob;

  const CommunitySupportPage({
    Key? key,
    required this.selectedCountry,
    required this.selectedJob,
  }) : super(key: key);

  @override
  State<CommunitySupportPage> createState() => _CommunitySupportPageState();
}

class _CommunitySupportPageState extends State<CommunitySupportPage> {
  List<dynamic> communitySupport = [];
  List<dynamic> filteredSupport = [];

  // Load community support data from JSON file
  @override
  void initState() {
    super.initState();
    loadCommunitySupportData();
  }

  Future<void> loadCommunitySupportData() async {
    try {
      final String response = await rootBundle
          .loadString('assets/labour_community_support_info.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        communitySupport = data;
        filteredSupport = communitySupport
            .where((support) =>
        support['country']?.toString().toLowerCase() ==
            widget.selectedCountry.toLowerCase())
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
        title: const Text(
          "Community Support",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: communitySupport.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              filteredSupport.isNotEmpty
                  ? 'Showing results for "${widget.selectedCountry}"'
                  : 'Sorry! No community support information available for "${widget.selectedCountry}".',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (filteredSupport.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredSupport.length,
                itemBuilder: (context, index) {
                  final support = filteredSupport[index];
                  final country = support['country'] ?? 'Country not available';
                  final city = support['city'] ?? 'City not available';
                  final description =
                      support['description'] ?? 'No description available';
                  final contact = support['contact'] ?? 'No contact available';
                  final services =
                      support['services'] ?? ['No services available'];
                  final activities =
                      support['activities'] ?? ['No activities listed'];

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: Row(
                            children: [
                              Icon(
                                Icons.group_add,
                                color: Colors.deepPurple,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                country,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            city,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 16.0, right: 16.0),
                              child: Text(
                                description,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone,
                                      color: Colors.green),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Contact: $contact',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  // Services Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Services Offered:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        ...services.map((service) =>
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 4.0),
                                              child: Text(service,
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Activities Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Community Activities:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        ...activities.map((activity) =>
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 4.0),
                                              child: Text(activity,
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
