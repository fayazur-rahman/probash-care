import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class JobAgencyInfo extends StatefulWidget {
  final String selectedCountry;
  final String selectedJob;

  const JobAgencyInfo({
    Key? key,
    required this.selectedCountry,
    required this.selectedJob,
  }) : super(key: key);

  @override
  State<JobAgencyInfo> createState() => _JobAgencyInfoState();
}

class _JobAgencyInfoState extends State<JobAgencyInfo> {
  List<dynamic> jobAgencies = [];
  List<dynamic> filteredAgencies = [];
  bool _isLaunching = false;

  // Launch URL function
  Future<void> launchURL(String url) async {
    if (_isLaunching) return;
    _isLaunching = true;

    try {
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

  // Load job agency data from JSON file and filter based on selection
  @override
  void initState() {
    super.initState();
    loadJobAgencyData();
  }

  Future<void> loadJobAgencyData() async {
    try {
      final String response =
      await rootBundle.loadString('assets/labour_job_agency_info.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        jobAgencies = data;
        filteredAgencies = jobAgencies
            .where((agency) =>
        agency['country'] == widget.selectedCountry &&
            agency['type'] == widget.selectedJob)
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
        title: const Text("Job Agency Information"),
      ),
      body: Column(
        children: [
          // Display selected country and job type
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Showing results for \"${widget.selectedCountry}\" and \"${widget.selectedJob}\"",
              style: const TextStyle(
                fontSize: 16,
                //fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Display results or "No information available" message
          Expanded(
            child: filteredAgencies.isEmpty
                ? const Center(
              child: Text(
                "Sorry! Information not available.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            )
                : ListView.builder(
              itemCount: filteredAgencies.length,
              itemBuilder: (context, index) {
                final agency = filteredAgencies[index];
                final name = agency['name'] ?? 'No name available';
                final location =
                    agency['location'] ?? 'Location not available';
                final description =
                    agency['description'] ?? 'No description available';

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Business Icon
                          Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.business,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Agency Name
                          Center(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Agency Location
                          Center(
                            child: Text(
                              "Location: $location",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Agency Description
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // Details Button
                          Center(
                            child: ElevatedButton.icon(
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
                                          "Location:",
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(location),
                                        const SizedBox(height: 12),
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
                                          "Website:",
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            launchURL(
                                                agency['website'] ?? '');
                                          },
                                          child: Text(
                                            agency['website'] ??
                                                'No website available',
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
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                              ),
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
