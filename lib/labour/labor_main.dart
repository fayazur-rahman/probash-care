import 'package:flutter/material.dart';
import 'package:probas/drawer.dart';
import 'package:probas/labour/community_support.dart';
import 'package:probas/labour/finance_info.dart';
import 'package:probas/labour/job_agency_info.dart';
import 'package:probas/labour/legal_visa_support.dart';
import 'package:probas/labour/relevent_course.dart';

// Function to show dialog with options
void _showOptionsDialog(BuildContext context, String title,
    List<String> options, Function(String) onSelect) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options
            .map(
              (option) => ListTile(
                title: Text(option),
                onTap: () {
                  Navigator.pop(context); // Close dialog after selection
                  onSelect(option);
                },
              ),
            )
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}

class LaborerSection extends StatefulWidget {
  const LaborerSection({super.key});

  @override
  State<LaborerSection> createState() => _LaborerSectionState();
}

class _LaborerSectionState extends State<LaborerSection> {
  String? selectedCountry;
  String? selectedJob;
  bool showJobInfo = false;
  bool showAdditionalJobInfo = false;

  void showJobRelatedInfo() {
    setState(() {
      showJobInfo = true;
      showAdditionalJobInfo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("💼 Laborer Section"),
      ),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 10),
          ListTile(
            title: const Text("Country Selection"),
            subtitle: Text(selectedCountry ?? "Select a country"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showOptionsDialog(context, "Select Country", [
              "Saudi Arabia",
              "UAE",
              "Malaysia",
              "Qatar",
              "Singapore"
            ], (value) {
              setState(() {
                selectedCountry = value;
              });
            }),
          ),
          if (selectedCountry != null) ...[
            ListTile(
              title: const Text("Job Type"),
              subtitle: Text(selectedJob ?? "Select a job type"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showOptionsDialog(context, "Select Job", [
                "Construction Worker",
                "Cleaning Staff",
                "Hospitality Worker"
              ], (value) {
                setState(() {
                  selectedJob = value;
                });
              }),
            ),
          ],
          if (selectedJob != null) ...[
            ElevatedButton(
              onPressed: showJobRelatedInfo,
              child: const Text("Search for Job Opportunities"),
            ),
            if (showJobInfo) ...[
              ListTile(
                title: const Text("Job Agency Information"),
                subtitle: const Text("Global Worker Agency"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobAgencyInfo(
                        selectedCountry: selectedCountry!,
                        selectedJob: selectedJob!,
                      ),
                    ),
                  );
                },
              ),
            ],
            if (showAdditionalJobInfo) ...[
              ListTile(
                title: const Text("Legal and Visa Support"),
                subtitle: const Text("Visa and Labor Law Support"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LegalVisaSupportPage(
                        selectedCountry: selectedCountry!,
                        selectedJob: selectedJob!,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Financial Information"),
                subtitle: const Text("Financial Support and Loans"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinancialInformationPage(
                        selectedCountry: selectedCountry!,
                        selectedJob: selectedJob!,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Community Support"),
                subtitle: const Text("Expats Support Groups"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunitySupportPage(
                        selectedCountry: selectedCountry!,
                        selectedJob: selectedJob!,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Relevant Courses"),
                subtitle: const Text("Courses for Skill Development"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RelevantCoursesPage(
                        selectedCountry: selectedCountry!,
                        selectedJob: selectedJob!,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}
