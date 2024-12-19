import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalVisaSupportPage extends StatefulWidget {
  final String selectedCountry;
  final String selectedJob;

  const LegalVisaSupportPage({
    Key? key,
    required this.selectedCountry,
    required this.selectedJob,
  }) : super(key: key);

  @override
  State<LegalVisaSupportPage> createState() => _LegalVisaSupportPageState();
}

class _LegalVisaSupportPageState extends State<LegalVisaSupportPage> {
  List<dynamic> legalVisaSupport = [];
  List<dynamic> filteredSupport = [];

  bool _isLaunching = false;

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

  // Load legal and visa support data from JSON file
  @override
  void initState() {
    super.initState();
    loadLegalVisaSupportData();
  }

  Future<void> loadLegalVisaSupportData() async {
    try {
      final String response = await rootBundle
          .loadString('assets/labour_legal_visa_support_info.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        legalVisaSupport = data;
        filteredSupport = legalVisaSupport
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
          "Legal and Visa Support",
        ),
      ),
      body: legalVisaSupport.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              filteredSupport.isNotEmpty
                  ? 'Showing results for "${widget.selectedCountry}"'
                  : 'Sorry! Information not available for "${widget.selectedCountry}".',
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
                  final country =
                      support['country'] ?? 'Country not available';
                  final city = support['city'] ?? 'City not available';
                  final contact =
                      support['contact'] ?? 'No contact available';
                  final services =
                      support['services'] ?? ['No services available'];
                  final activities =
                      support['activities'] ?? ['No activities listed'];

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      color: Colors.teal.shade50,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Country and City Info
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.teal,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$country, $city',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Contact Info
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Contact: $contact',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Services Section
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Services Offered:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...services.map(
                                            (service) => Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Text(
                                            service,
                                            style: const TextStyle(
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: 1,
                                  color: Colors.teal,
                                  width: 30,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Community Activities:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...activities.map(
                                            (activity) => Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Text(
                                            activity,
                                            style: const TextStyle(
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
