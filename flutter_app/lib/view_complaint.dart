import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewComplaintsPage extends StatefulWidget {
  const ViewComplaintsPage({super.key});

  @override
  State<ViewComplaintsPage> createState() => _ViewComplaintsPageState();
}

class _ViewComplaintsPageState extends State<ViewComplaintsPage> {
  List<dynamic> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString("url");
    String? lid = sh.getString("lid");

    try {
      final response = await http.post(
        Uri.parse("${url}View_complaint_reply/"),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        setState(() {
          complaints = jsonDecode(response.body)['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  // --- SEND COMPLAINT DIALOG ---
  void _showAddComplaintDialog() {
    TextEditingController complaintController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Post New Complaint"),
        content: TextField(
          controller: complaintController,
          decoration: const InputDecoration(
            hintText: "Describe your issue...",
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (complaintController.text.isNotEmpty) {
                final sh = await SharedPreferences.getInstance();
                String? url = sh.getString("url");
                String? lid = sh.getString("lid");

                final response = await http.post(
                  Uri.parse("${url}send_complaint/"),
                  body: {
                    'lid': lid,
                    'complaint': complaintController.text,
                  },
                );

                if (response.statusCode == 200) {
                  Navigator.pop(context);
                  fetchComplaints(); // Refresh the list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Complaint submitted successfully")),
                  );
                }
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Complaints"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaints.isEmpty
          ? const Center(child: Text("No complaints found."))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final c = complaints[index];
          bool isPending = c['reply'] == "pending";

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        c['date'] ?? "",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPending ? Colors.orange[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isPending ? "Pending" : "Replied",
                          style: TextStyle(
                            color: isPending ? Colors.orange[800] : Colors.green[800],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Q: ${c['complaints'] ?? c['complaint']}", // Handled both keys
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(height: 20),
                  Text(
                    "Reply: ${c['reply']}",
                    style: TextStyle(
                      color: isPending ? Colors.grey : Colors.black87,
                      fontStyle: isPending ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddComplaintDialog,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add_comment, color: Colors.white),
      ),
    );
  }
}