import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ViewDoubtsPage extends StatefulWidget {
  final String eid;
  const ViewDoubtsPage({super.key, required this.eid});

  @override
  State<ViewDoubtsPage> createState() => _ViewDoubtsPageState();
}

class _ViewDoubtsPageState extends State<ViewDoubtsPage> {
  List<dynamic> doubts = [];
  bool isLoading = true;

  Future<void> fetchDoubts() async {
    final sh = await SharedPreferences.getInstance();
    String url = "${sh.getString("url")}View_experts_doubts_reply/";
    var response = await http.post(Uri.parse(url), body: {'eid': widget.eid});
    if (response.statusCode == 200) {
      setState(() {
        doubts = jsonDecode(response.body)['data'];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDoubts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Doubts"), backgroundColor: Colors.orange),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: doubts.length,
        itemBuilder: (context, index) {
          final d = doubts[index];
          return Card(
            child: ListTile(
              title: Text(d['doubt']),
              subtitle: Text("Reply: ${d['reply']}"),
              trailing: Text(d['date'], style: const TextStyle(fontSize: 10)),
              tileColor: d['reply'] == "pending" ? Colors.orange[50] : Colors.green[50],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDoubtDialog(),
        label: const Text("Ask Expert"),
        icon: const Icon(Icons.add_comment),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // --- 3. SEND DOUBT DIALOG ---
  void _showAddDoubtDialog() {
    TextEditingController doubtController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ask a Doubt"),
        content: TextField(
          controller: doubtController,
          decoration: const InputDecoration(hintText: "Type your question here..."),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () async {
                final sh = await SharedPreferences.getInstance();
                String url = "${sh.getString("url")}send_doubt_expert/";
                await http.post(Uri.parse(url), body: {
                  'lid': sh.getString("lid"), // User Login ID from SharedPreferences
                  'eid': widget.eid,
                  'doubt': doubtController.text,
                });
                Navigator.pop(context);
                fetchDoubts(); // Refresh list
              },
              child: const Text("Send")
          ),
        ],
      ),
    );
  }
}