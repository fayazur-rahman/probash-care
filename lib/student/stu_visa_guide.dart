import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class VisaGuidancePage extends StatefulWidget {
  final String selectedCountry;
  final String selectedDegree;

  const VisaGuidancePage({
    Key? key,
    required this.selectedCountry,
    required this.selectedDegree,
  }) : super(key: key);

  @override
  State<VisaGuidancePage> createState() => _VisaGuidancePageState();
}

class _VisaGuidancePageState extends State<VisaGuidancePage> {
  List<dynamic> visaGuidance = [];
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

  // Load visa guidance data from the JSON file
  @override
  void initState() {
    super.initState();
    loadVisaGuidanceData();
  }

  Future<void> loadVisaGuidanceData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/stu_visa_guidance_info.json');
      final List<dynamic> data = json.decode(response);
      // Filter data based on selectedCountry and selectedDegree
      setState(() {
        visaGuidance = data.where((agency) {
          final countryMatch = agency['country']?.toString().toLowerCase() ==
              widget.selectedCountry.toLowerCase();
          return countryMatch;
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
        title: const Text("Visa Guidance"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Showing results for ${widget.selectedCountry}',
              style: const TextStyle(
                fontSize: 14,
                //fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: visaGuidance.isEmpty
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
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: visaGuidance.length,
                      itemBuilder: (context, index) {
                        final guidance = visaGuidance[index];
                        final name = guidance['name'] ?? 'No name available';
                        final description = guidance['description'] ??
                            'No description available';

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigo.shade600,
                                Colors.indigoAccent.shade100
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
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(description),
                                          const SizedBox(height: 12),
                                          Text(
                                            "Email:",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(guidance['email'] ??
                                              'No email available'),
                                          const SizedBox(height: 12),
                                          Text(
                                            "Phone:",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(guidance['phone'] ??
                                              'No phone available'),
                                          const SizedBox(height: 12),
                                          Text(
                                            "Address:",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(guidance['address'] ??
                                              'No address available'),
                                          const SizedBox(height: 12),
                                          Text(
                                            "Website:",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              launchURL(guidance['link'] ?? '');
                                            },
                                            child: Text(
                                              guidance['link'] ??
                                                  'No link available',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline,
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
                                  backgroundColor: Colors.indigo.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
