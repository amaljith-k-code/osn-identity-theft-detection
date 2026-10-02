import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewTipsPage extends StatefulWidget {
  final String eid;
  const ViewTipsPage({super.key, required this.eid});

  @override
  State<ViewTipsPage> createState() => _ViewTipsPageState();
}

class _ViewTipsPageState extends State<ViewTipsPage> {
  List<dynamic> tips = [];
  bool isLoading = true;

  Future<void> getTips() async {
    final sh = await SharedPreferences.getInstance();
    String url = "${sh.getString("url")}View_experts_tips/";

    var response = await http.post(Uri.parse(url), body: {'eid': widget.eid});
    if (response.statusCode == 200) {
      setState(() {
        tips = jsonDecode(response.body)['data'];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expert Tips"), backgroundColor: Colors.green),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(10),
          elevation: 3,
          child: ListTile(
            leading: const Icon(Icons.lightbulb, color: Colors.orange),
            title: Text(tips[index]['tip'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${tips[index]['details']}\nDate: ${tips[index]['date']}"),
          ),
        ),
      ),
    );
  }
}