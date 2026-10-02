import 'package:first/comment_reply.dart';
import 'package:first/homecontent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List comments = [];
  String? baseUrl;
  String? pid;
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
      pid = sh.getString("pid"); // ensure pid is saved earlier
      lid = sh.getString("lid"); // ensure pid is saved earlier
    });
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    if (baseUrl == null || pid == null) return;
    var response = await http.post(
      Uri.parse("${baseUrl}view_comments/"),
      body: {
        "pid": pid!,
        "lid": lid!,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        comments = data["data"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showCommentDialog();
      },child: Icon(Icons.comment),),
      body: comments.isEmpty
          ? Center(child: Text("No comments"))
          : ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          var c = comments[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person, color: Colors.white),
                backgroundColor: Colors.blue,
              ),
              title: Text(c['u_name'] ?? "Unknown User",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['comment']),
                  SizedBox(height: 4),
                  Text("Type: ${c['type']}"),
                  Text("Date: ${c['Date']}",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),

                  c['delete_status']? IconButton(onPressed: ()async{

                    final sh = await SharedPreferences.getInstance();


                    // Get the base URL (e.g., http://192.168.1.5:8000/myapp/)
                    String? baseUrl = sh.getString("url");

                    // url + "flutter_login/" matches your path('flutter_login/', ...)
                    final fullUrl = Uri.parse("${baseUrl}Delete_cmt/");

                    var response = await http.post(
                      fullUrl,
                      body: {
                        'cid': c['id'].toString(),
                      },
                    );
                    if (response.statusCode == 200) {
                      var jsonData = json.decode(response.body);
                      String status = jsonData['status'].toString();

                      if (status == "ok") {
                        // Saving all user details returned by your Django view
                        Fluttertoast.showToast(msg: "Deleted");
                        _fetchComments();
                      } else {
                        Fluttertoast.showToast(msg: " Failed");
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Server Error: ${response.statusCode}");
                    }
                  }, icon:Icon(Icons.delete)):Text(""),

                  ElevatedButton(onPressed: ()async{
                    SharedPreferences sh = await SharedPreferences.getInstance();
                    sh.setString("cid", c['id'].toString());

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Reply_comment()));

                  }, child: Text("Replies"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  void _showCommentDialog() {
    TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(hintText: "Enter your comment"),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Post"),
            onPressed: () async{
              // SharedPreferences sh = await SharedPreferences.getInstance();
              final sh = await SharedPreferences.getInstance();
              // Get the base URL (e.g., http://192.168.1.5:8000/myapp/)
              String? baseUrl = sh.getString("url");
              String? lid = sh.getString("lid");
                // url + "flutter_login/" matches your path('flutter_login/', ...)
                final fullUrl = Uri.parse("${baseUrl}send_comment/");
                var response = await http.post(
                  fullUrl,
                  body: {
                    'comment': commentController.text,
                    'pid': pid,
                    'lid': lid.toString(),
                  },
                );

                if (response.statusCode == 200) {
                  var jsonData = json.decode(response.body);
                  String status = jsonData['status'].toString();

                  if (status == "ok") {
                    // Saving all user details returned by your Django view
                    Fluttertoast.showToast(msg: " Successful");
                    // Navigate to Home
                    Navigator.pop(context);
                    _fetchComments();
                  } else {
                    Fluttertoast.showToast(msg: " Failed");

                  }
                } else {
                  Fluttertoast.showToast(msg: "Server Error: ${response.statusCode}");
                }


            },
          ),


        ],
      ),
    );
  }

}


