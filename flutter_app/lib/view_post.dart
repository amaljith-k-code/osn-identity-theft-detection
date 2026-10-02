// import 'package:first/view_comment.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class PostPage extends StatefulWidget {
//   @override
//   _PostPageState createState() => _PostPageState();
// }
//
// class _PostPageState extends State<PostPage> {
//   List posts = [];
//   String? baseUrl;
//   bool isLiked = false;
//   int likeCount = 0;
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
//       Uri.parse("${baseUrl}view_own_post/"),
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
//       appBar: AppBar(title: Text("My Posts")),
//       body: posts.isEmpty
//           ? Center(child: CircularProgressIndicator())
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
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                   child: Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFFE1306C), Color(0xFFF77737)],
//                           ),
//                         ),
//                         padding: const EdgeInsets.all(2),
//                         child: CircleAvatar(
//                           radius: 17,
//                           backgroundColor: Colors.black,
//                           child: CircleAvatar(
//                             radius: 15,
//                             backgroundColor: Colors.grey[800],
//                             child: Text(
//                               (post['username'] as String? ?? '?')[0].toUpperCase(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               post['username'] ?? '',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13.5,
//                               ),
//                             ),
//                             if (post['Date'] != null)
//                               Text(
//                                 post['Date'],
//                                 style:
//                                 const TextStyle(color: Colors.grey, fontSize: 11),
//                               ),
//                           ],
//                         ),
//                       ),
//                       const Icon(Icons.more_horiz, color: Colors.white),
//                     ],
//                   ),
//                 ),
//
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
//                       Text(post['caption'],
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
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
//
//
//           children: [
//                       IconButton(
//                         icon: Icon(Icons.thumb_up_alt_outlined),
//                         onPressed: () async {
//                           final prefs = await SharedPreferences.getInstance();
//                           final baseUrl = prefs.getString('url'); // Default for emulator
//                           String? lid = prefs.getString('lid'); // Default for emulator
//
//                           final response = await http.post(
//                             Uri.parse("${baseUrl}toggle_like/"),
//                             headers: {"Content-Type": "application/json"},
//                             body: jsonEncode({
//                               "user_id": lid,
//                               "post_id": post['id'],
//                             }),
//                           );
//
//                           final data = jsonDecode(response.body);
//
//                           setState(() {
//                             isLiked = data["status"] == "liked";
//                             likeCount = data["total_likes"];
//                           });
//                         },
//                       ),
//
//
//
//
//
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
//
//
//
//
//
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

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List posts = [];
  String? baseUrl;
  String? imgUrl;
  String? lid;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    setState(() {
      baseUrl = sh.getString("url");
      imgUrl = sh.getString("img");
      lid = sh.getString("lid");
    });
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    if (baseUrl == null) return;
    try {
      var response = await http.post(
        Uri.parse("${baseUrl}view_own_post/"),
        body: {"lid": lid},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          posts = data["data"];
        });
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  // --- DELETE POST METHOD ---
  Future<void> _deletePost(String pid, int index) async {
    try {
      var response = await http.post(
        Uri.parse("${baseUrl}Delete_post/"),
        body: {"pid": pid},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "ok") {
          setState(() {
            posts.removeAt(index); // Remove from list immediately
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Post deleted successfully")),
          );
        }
      }
    } catch (e) {
      print("Delete error: $e");
    }
  }

  // --- TOGGLE LIKE METHOD ---


  Future<void> _toggleLike(Map post, int index) async {
    // Optimistic update
    setState(() {
      posts[index]['is_liked'] = !(post['is_liked'] == true);
      posts[index]['total_likes'] =
          (post['total_likes'] ?? 0) + (post['is_liked'] == true ? 1 : -1);
    });
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}toggle_likee/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": lid, "post_id": post['post_id']}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          posts[index]['is_liked'] = data["status"] == "liked";
          posts[index]['total_likes'] = data["total_likes"];
        });
      }
    } catch (_) {}
  }


  // Future<void> _toggleLike(int index) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse("${baseUrl}toggle_likee/"),
  //       body: {
  //         "user_id": lid.toString(),
  //         "post_id": posts[index]['post_id'].toString(), // Match Django key
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       setState(() {
  //         // Update specific item in the list
  //         posts[index]['is_liked'] = (data["status"] == "liked");
  //         posts[index]['total_likes'] = data["total_likes"];
  //       });
  //     }
  //   } catch (e) {
  //     print("Like error: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Posts")),
      body: posts.isEmpty
          ? Center(child: Text("No Post") )
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          var post = posts[index];
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Username and Delete
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      (post['username'] ?? "U")[0].toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(post['username'] ?? "Unknown"),
                  subtitle: Text(post['Date'] ?? ""),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deletePost(post['post_id'].toString(), index),
                  ),
                ),

                // Post Image
                ClipRRect(
                  child: Image.network(
                    "${imgUrl!+post['image']}",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 200, color: Colors.grey, child: Icon(Icons.broken_image)),
                  ),
                ),

                // Caption & Description
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['caption'] ?? "",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(post['description'] ?? ""),
                    ],
                  ),
                ),

                Divider(height: 1),

                // Interaction Row (Like & Comment)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      // LIKE BUTTON
                      IconButton(
                        icon: Icon(
                          post['is_liked'] == true ? Icons.favorite : Icons.favorite_border,
                          color: post['is_liked'] == true ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleLike(post, index),
                      ),
                      Text("${post['total_likes'] ?? 0}"),

                      SizedBox(width: 20),

                      // COMMENT BUTTON
                      IconButton(
                        icon: Icon(Icons.chat_bubble_outline),
                        onPressed: () async {
                          SharedPreferences sh = await SharedPreferences.getInstance();
                          sh.setString("pid", post['post_id'].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CommentsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}