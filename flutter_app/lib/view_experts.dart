import 'dart:convert';
import 'package:first/view_doubts.dart';
import 'package:first/view_tips.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewExpertsPage extends StatefulWidget {
  const ViewExpertsPage({super.key});

  @override
  State<ViewExpertsPage> createState() => _ViewExpertsPageState();
}

class _ViewExpertsPageState extends State<ViewExpertsPage> {
  List<dynamic> allExperts = [];
  List<dynamic> filteredExperts = [];
  bool isLoading = true;
  String baseUrl = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final sh = await SharedPreferences.getInstance();
    baseUrl = sh.getString("url") ?? "";

    try {
      final response = await http.post(Uri.parse("${baseUrl}View_experts/"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          allExperts = data['data'];
          filteredExperts = allExperts;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching experts: $e");
      setState(() => isLoading = false);
    }
  }

  void _filterList(String query) {
    setState(() {
      filteredExperts = allExperts
          .where((e) => e['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light professional grey
      appBar: AppBar(
        title: const Text("Expert Directory", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Elegant Search Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo[800],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: TextField(
              onChanged: _filterList,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search experts...",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Experts List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredExperts.length,
              itemBuilder: (context, index) {
                final expert = filteredExperts[index];
                // Construct Image URL
                String imgPath = expert['photo'].startsWith('http')
                    ? expert['photo']
                    : "${baseUrl.replaceAll('/myapp/', '')}${expert['photo']}";

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(imgPath),
                          backgroundColor: Colors.indigo[50],
                        ),
                        title: Text(
                          expert['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text("📍 ${expert['place']}\n📧 ${expert['email']}"),
                        ),
                      ),

                      // Action Buttons Row
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            // Button 1: View Doubts
                            // Expanded(
                            //   child: TextButton.icon(
                            //     onPressed: () {
                            //       // Navigate to Doubts Page
                            //     },
                            //     icon: const Icon(Icons.help_outline, color: Colors.orange),
                            //     label: const Text("View Doubts", style: TextStyle(color: Colors.black87)),
                            //   ),
                            // ),
                            // Container(width: 1, height: 20, color: Colors.grey[300]),
                            // // Button 2: View Tips
                            // Expanded(
                            //   child: TextButton.icon(
                            //     onPressed: () {
                            //       // Navigate to Tips Page
                            //     },
                            //     icon: const Icon(Icons.lightbulb_outline, color: Colors.green),
                            //     label: const Text("View Tips", style: TextStyle(color: Colors.black87)),
                            //   ),
                            // ),


                            // Inside the Action Buttons Row of your ViewExpertsPage

// Button: View Doubts
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ViewDoubtsPage(eid: expert['eid'].toString())
                                ));
                              },
                              icon: const Icon(Icons.help_outline, color: Colors.orange),
                              label: const Text("View Doubts"),
                            ),

// Button: View Tips
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ViewTipsPage(eid: expert['eid'].toString())
                                ));
                              },
                              icon: const Icon(Icons.lightbulb_outline, color: Colors.green),
                              label: const Text("View Tips"),
                            ),
                          ],
                        ),
                      ),
                    ],
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