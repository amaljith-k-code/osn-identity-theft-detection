// import 'package:first/view_comment.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class Others_post extends StatefulWidget {
//   @override
//   _Others_postState createState() => _Others_postState();
// }
//
// class _Others_postState extends State<Others_post> {
//   List posts = [];
//   String? baseUrl;
//   String? imgUrl;
//   String? lid;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPrefs();
//   }
//
//   Future<void> _loadPrefs() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     setState(() {
//       baseUrl = sh.getString("url");
//       imgUrl = sh.getString("img");
//       lid = sh.getString("lid");
//     });
//     _fetchPosts();
//   }
//
//   Future<void> _fetchPosts() async {
//     if (baseUrl == null) return;
//     var response = await http.post(
//       Uri.parse("${baseUrl}view_others_post/"),
//       body: {"lid": lid}, // replace with actual login id
//     );
//
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       setState(() {
//         posts = data["data"];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Others Posts")),
//       body: posts.isEmpty
//           ? Center(child: Text("No Post"))
//           : ListView.builder(
//         itemCount: posts.length,
//         itemBuilder: (context, index) {
//           var post = posts[index];
//           return Card(
//             margin: EdgeInsets.all(10),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image
//                 ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                   child: Image.network(
//                     "${imgUrl}${post['image']}",
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: 200,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(post['username'],
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 5),
//                       Text(post['caption']),
//                       SizedBox(height: 5),
//                       Text(post['description']),
//                       SizedBox(height: 5),
//                       Text("Date: ${post['Date']}",
//                           style: TextStyle(
//                               fontSize: 12, color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//                 Divider(),
//                 // Like & Comment buttons
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.thumb_up_alt_outlined),
//                         onPressed: () {
//                           // TODO: handle like action
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.comment_outlined),
//                         onPressed: () async{
//                           SharedPreferences sh = await SharedPreferences.getInstance();
//                           sh.setString("pid", post['id'].toString());
//                           Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentsPage()));
//                         },
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showCommentDialog(post) {
//     TextEditingController commentController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Add Comment"),
//         content: TextField(
//           controller: commentController,
//           decoration: InputDecoration(hintText: "Enter your comment"),
//         ),
//         actions: [
//           TextButton(
//             child: Text("Cancel"),
//             onPressed: () => Navigator.pop(context),
//           ),
//           ElevatedButton(
//             child: Text("Post"),
//             onPressed: () {
//               // TODO: send comment to backend
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:first/view_comment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Others_post extends StatefulWidget {
  @override
  _Others_postState createState() => _Others_postState();
}

class _Others_postState extends State<Others_post> {
  List posts = [];
  String? baseUrl;
  String? imgUrl;
  String? lid;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    SharedPreferences sh = await SharedPreferences.getInstance();

    baseUrl = sh.getString("url");
    imgUrl = sh.getString("img");
    lid = sh.getString("lid");

    // if (baseUrl != null && !baseUrl!.endsWith("/")) {
    //   baseUrl = "$baseUrl/";
    // }

    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      var response = await http.post(
        Uri.parse("${baseUrl}view_others_post/"),
        body: {"lid": lid},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          posts = data["data"] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Fetch error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleLike(Map post, int index) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}toggle_likee/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": lid,
          "post_id": post['post_id'],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          posts[index]['is_liked'] =
              data["status"] == "liked";
          posts[index]['total_likes'] =
          data["total_likes"];
        });
      }
    } catch (e) {
      print("Like error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Others Posts")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : posts.isEmpty
          ? Center(child: Text("No Posts"))
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          var post = posts[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Image.network(
                  "${post['image']}",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(post['username'],
                          style: TextStyle(
                              fontWeight:
                              FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(post['caption']),
                      SizedBox(height: 5),
                      Text(post['description']),
                      SizedBox(height: 5),
                      Text("Date: ${post['Date']}",
                          style: TextStyle(
                              color: Colors.grey)),
                    ],
                  ),
                ),

                Divider(),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            post['is_liked'] == true
                                ? Icons.thumb_up
                                : Icons
                                .thumb_up_alt_outlined,
                            color:
                            post['is_liked'] ==
                                true
                                ? Colors.blue
                                : null,
                          ),
                          onPressed: () =>
                              toggleLike(
                                  post, index),
                        ),
                        Text(
                            "${post['total_likes'] ?? 0}")
                      ],
                    ),

                    IconButton(
                      icon:
                      Icon(Icons.comment),
                      onPressed: () async {
                        SharedPreferences sh =
                        await SharedPreferences
                            .getInstance();
                        sh.setString(
                            "pid",
                            post['post_id']
                                .toString());

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CommentsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}