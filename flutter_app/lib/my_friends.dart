// import 'dart:convert';
// import 'package:first/chat.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyFriendsPage extends StatefulWidget {
//   const MyFriendsPage({super.key});
//
//   @override
//   State<MyFriendsPage> createState() => _MyFriendsPageState();
// }
//
// class _MyFriendsPageState extends State<MyFriendsPage> {
//   List<dynamic> friends = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     getFriends();
//   }
//
//   Future<void> getFriends() async {
//     final sh = await SharedPreferences.getInstance();
//     String url = sh.getString("url").toString();
//     String lid = sh.getString("lid").toString();
//
//     try {
//       var response = await http.post(
//         Uri.parse("${url}view_my_friends/"),
//         body: {'lid': lid},
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           friends = json.decode(response.body)['data'];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Friends"),
//         backgroundColor: Colors.pink,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : friends.isEmpty
//           ? const Center(child: Text("No friends added yet."))
//           : ListView.builder(
//         padding: const EdgeInsets.all(10),
//         itemCount: friends.length,
//         itemBuilder: (context, i) => Card(
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(friends[i]['photo'].toString()),
//             ),
//             title: Text(
//               friends[i]['name'].toString(),
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             trailing:
//             const Icon(Icons.chat, color: Colors.pink),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatPage(
//                     receiverId: friends[i]['id'].toString(),
//                     receiverName: friends[i]['name'].toString(),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//


import 'dart:convert';
import 'package:first/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyFriendsPage extends StatefulWidget {
  const MyFriendsPage({super.key});

  @override
  State<MyFriendsPage> createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends State<MyFriendsPage> {
  List<dynamic> friends = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  Future<void> getFriends() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString("url");
    String? lid = sh.getString("lid");

    if (url == null || lid == null) {
      setState(() {
        isLoading = false;
        friends = [];
        errorMessage = 'URL or LID not set';
      });
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("${url}view_my_friends/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"lid": lid}),
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        if (body['status'] == 'ok') {
          setState(() {
            friends = body['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            friends = [];
            isLoading = false;
            errorMessage = body['message'] ?? 'Error fetching friends';
          });
        }
      } else {
        setState(() {
          friends = [];
          isLoading = false;
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        friends = [];
        errorMessage = 'Failed to fetch friends: $e';
      });
    }
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)));
    }

    if (friends.isEmpty) {
      return const Center(child: Text("No friends added yet."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: friends.length,
      itemBuilder: (context, i) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: friends[i]['photo'] != null && friends[i]['photo'] != ""
                ? NetworkImage(friends[i]['photo'])
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          title: Text(
            friends[i]['name'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.chat, color: Colors.pink),
          onTap: () {
            if (friends[i]['id'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverId: friends[i]['id'].toString(),
                    receiverName: friends[i]['name'] ?? '',
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Friend ID missing')),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Friends"),
        backgroundColor: Colors.pink,
      ),
      body: RefreshIndicator(
        onRefresh: getFriends,
        child: buildBody(),
      ),
    );
  }
}