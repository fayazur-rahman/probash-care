import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AgencyInfoPage extends StatefulWidget {
  final String selectedCountry;
  final String selectedDegree;

  const AgencyInfoPage({
    Key? key,
    required this.selectedCountry,
    required this.selectedDegree,
  }) : super(key: key);

  @override
  State<AgencyInfoPage> createState() => _AgencyInfoPageState();
}

class _AgencyInfoPageState extends State<AgencyInfoPage> {
  List<dynamic> agencies = [];

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
    loadAgencyData();
  }

  Future<void> loadAgencyData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/stu_agency_info.json');
      final List<dynamic> data = json.decode(response);
      // Filter data based on selectedCountry and selectedDegree
      setState(() {
        agencies = data.where((agency) {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth > 600 ? 3 : 2; // Adjust grid count for larger screens

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agency Information"),
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
            child: agencies.isEmpty
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 3 : 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: agencies.length,
                      itemBuilder: (context, index) {
                        final agency = agencies[index];
                        final name = agency['name'] ?? 'No name available';
                        final description =
                            agency['description'] ?? 'No description available';

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.teal.shade600,
                                Colors.tealAccent.shade200
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
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
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
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomCenter,
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
                                          content: SingleChildScrollView(
                                            child: Column(
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
                                                  "Phone:",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(agency['phone'] ??
                                                    'No phone available'),
                                                const SizedBox(height: 12),
                                                Text(
                                                  "Address:",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(agency['address'] ??
                                                    'No address available'),
                                                const SizedBox(height: 12),
                                                Text(
                                                  "Email:",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(agency['email'] ??
                                                    'No email available'),
                                                const SizedBox(height: 12),
                                                Text(
                                                  "Visit:",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    lunchURL(
                                                        agency['link'] ?? '');
                                                  },
                                                  child: Text(
                                                    agency['link'] ??
                                                        'No link available',
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                      backgroundColor: Colors.teal.shade600,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
