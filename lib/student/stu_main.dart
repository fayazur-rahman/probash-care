// Student Section Implementation
import 'package:flutter/material.dart';
import 'package:probas/drawer.dart';
import 'package:probas/student/stu_agency_info.dart';
import 'package:probas/student/stu_ielts.dart';
import 'package:probas/student/stu_scholarship.dart';
import 'package:probas/student/stu_visa_guide.dart';

class StudentSection extends StatefulWidget {
  const StudentSection({super.key});

  @override
  State<StudentSection> createState() => _StudentSectionState();
}

class _StudentSectionState extends State<StudentSection> {
  String? selectedCountry;
  String? selectedDegree;
  bool showAgencyInfo = false;
  bool showAdditionalInfo = false;

  void showRelatedInfo() {
    setState(() {
      showAgencyInfo = true;
      showAdditionalInfo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎓 Student Section"),
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
            onTap: () => _showOptionsDialog(context, "Select Country",
                ["USA", "Canada", "UK", "Australia", "Germany"], (value) {
              setState(() {
                selectedCountry = value;
              });
            }),
          ),
          if (selectedCountry != null) ...[
            ListTile(
              title: const Text("Degree Applications"),
              subtitle: Text(selectedDegree ?? "Select a degree"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showOptionsDialog(context, "Select Degree", [
                "Under-Graduate",
                "Post-Graduate",
                "PhD"
              ], (value) {
                setState(() {
                  selectedDegree = value;
                });
              }),
            ),
          ],
          if (selectedDegree != null) ...[
            ElevatedButton(
              onPressed: showRelatedInfo,
              child: const Text("Search for Relevant Information"),
            ),
            if (showAgencyInfo) ...[
              ListTile(
                title: const Text("Agency Information"),
                subtitle: const Text("Global Education Agency"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgencyInfoPage(
                        selectedCountry: selectedCountry!,
                        selectedDegree: selectedDegree!,
                      ),
                    ),
                  );
                },

              ),
            ],
            if (showAdditionalInfo) ...[
              ListTile(
                title: const Text("IELTS Resources"),
                subtitle: const Text("Preparation Materials"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IeltsResourcesPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Visa Guidance"),
                subtitle: const Text("Visa Application Assistance"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisaGuidancePage(
                        selectedCountry: selectedCountry!,
                        selectedDegree: selectedDegree!,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Scholarship Opportunities"),
                subtitle: const Text("Available Scholarships"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScholarshipOpportunitiesPage(
                        selectedCountry: selectedCountry!,
                        selectedDegree: selectedDegree!,
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
}
