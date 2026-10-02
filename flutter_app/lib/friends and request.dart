import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FindFriendsPage extends StatefulWidget {
  const FindFriendsPage({super.key});

  @override
  State<FindFriendsPage> createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  // Lists to store data for the three tabs
  List<dynamic> allUsers = [];
  List<dynamic> incomingReqs = [];
  List<dynamic> sentReqs = [];
  String img ="";

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();
    String lid = sh.getString("lid").toString();
    img = sh.getString("img").toString();

    try {
      // 1. Fetch Search Users
      var res1 = await http.post(Uri.parse("${url}search_users/"), body: {'lid': lid});
      // 2. Fetch Incoming
      var res2 = await http.post(Uri.parse("${url}view_incoming_requests/"), body: {'lid': lid});
      // 3. Fetch Sent Status
      var res3 = await http.post(Uri.parse("${url}view_sent_requests/"), body: {'lid': lid});

      setState(() {
        allUsers = json.decode(res1.body)['users'];
        incomingReqs = json.decode(res2.body)['data'];
        sentReqs = json.decode(res3.body)['data'];
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading data");
    }
  }

  Future<void> sendRequest(String toId) async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();
    String lid = sh.getString("lid").toString();

    var response = await http.post(
      Uri.parse("${url}send_friend_request/"),
      body: {'lid': lid, 'to_lid': toId},
    );
    var data = json.decode(response.body);
    if (data['status'] == 'ok') {
      Fluttertoast.showToast(msg: "Request Sent!");
      fetchAllData(); // Refresh lists
    }
  }

  Future<void> manageReq(String rid, String status) async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();

    var response = await http.post(
      Uri.parse("${url}manage_request/"),
      body: {'rid': rid, 'status': status},
    );
    if (json.decode(response.body)['status'] == 'ok') {
      Fluttertoast.showToast(msg: "Request $status");
      fetchAllData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Find Friends"),
          backgroundColor: Colors.pink,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Discover", icon: Icon(Icons.person_search)),
              Tab(text: "Requests", icon: Icon(Icons.call_received)),
              Tab(text: "Pending", icon: Icon(Icons.hourglass_empty)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDiscoverTab(),
            _buildRequestsTab(),
            _buildSentTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return ListView.builder(
      itemCount: allUsers.length,
      itemBuilder: (context, i) => ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(img+allUsers[i]['photo'].toString())),
        title: Text(allUsers[i]['name'].toString()),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
          onPressed: () => sendRequest(allUsers[i]['to_id'].toString()),
          child: const Text("Add", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    return ListView.builder(
      itemCount: incomingReqs.length,
      itemBuilder: (context, i) => ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(incomingReqs[i]['photo'].toString())),
        title: Text(incomingReqs[i]['name'].toString()),
        subtitle: Text("On ${incomingReqs[i]['date']}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () => manageReq(incomingReqs[i]['rid'].toString(), 'accepted')),
            IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => manageReq(incomingReqs[i]['rid'].toString(), 'rejected')),
          ],
        ),
      ),
    );
  }

  Widget _buildSentTab() {
    return ListView.builder(
      itemCount: sentReqs.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(sentReqs[i]['name'].toString()),
        subtitle: Text("Sent on: ${sentReqs[i]['date']}"),
        trailing: Chip(
          label: Text(sentReqs[i]['status'].toString()),
          backgroundColor: sentReqs[i]['status'] == 'accepted' ? Colors.green[100] : Colors.orange[100],
        ),
      ),
    );
  }
}