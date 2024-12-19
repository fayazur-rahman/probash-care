import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class FinancialInformationPage extends StatefulWidget {
  final String selectedCountry;
  final String selectedJob;

  const FinancialInformationPage({
    Key? key,
    required this.selectedCountry,
    required this.selectedJob,
  }) : super(key: key);

  @override
  State<FinancialInformationPage> createState() =>
      _FinancialInformationPageState();
}

class _FinancialInformationPageState extends State<FinancialInformationPage> {
  List<dynamic> financialInformation = [];
  List<dynamic> filteredInformation = [];

  // Load financial data from JSON file
  @override
  void initState() {
    super.initState();
    loadFinancialData();
  }

  Future<void> loadFinancialData() async {
    try {
      final String response = await rootBundle
          .loadString('assets/labour_financial_information.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        financialInformation = data;
        filteredInformation = financialInformation
            .where((info) =>
        info['country']?.toString().toLowerCase() ==
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
          "Financial Information",
        ),
      ),
      body: financialInformation.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              filteredInformation.isNotEmpty
                  ? 'Showing results for "${widget.selectedCountry}"'
                  : 'Sorry! No financial information available for "${widget.selectedCountry}".',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (filteredInformation.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredInformation.length,
                itemBuilder: (context, index) {
                  final info = filteredInformation[index];
                  final name = info['name'] ?? 'No name available';
                  final location =
                      info['location'] ?? 'Location not available';
                  final services =
                      info['services'] ?? 'No services available';
                  final contact =
                      info['contact'] ?? 'No contact available';
                  final exchangeRate = info['exchange_rate'] ?? 'N/A';

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header with company details
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  color: Colors.blueGrey,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Location subtitle
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              location,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          // Service and exchange rate details in grid format
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                _InfoBox(
                                    title: "Services", content: services),
                                _InfoBox(
                                    title: "Exchange Rate",
                                    content: exchangeRate),
                              ],
                            ),
                          ),
                          // Contact information
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Colors.green, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'Contact: $contact',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
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

class _InfoBox extends StatelessWidget {
  final String title;
  final String content;

  const _InfoBox({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
