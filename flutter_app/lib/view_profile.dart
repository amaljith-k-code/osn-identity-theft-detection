// import 'dart:convert';
// import 'package:first/view_experts.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'update_profile.dart'; // Ensure this filename matches your edit page file
//
// class ViewProfile extends StatefulWidget {
//   const ViewProfile({super.key});
//
//   @override
//   State<ViewProfile> createState() => _ViewProfileState();
// }
//
// class _ViewProfileState extends State<ViewProfile> {
//   Map<String, dynamic> userData = {};
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProfile();
//   }
//
//   Future<void> fetchProfile() async {
//     final sh = await SharedPreferences.getInstance();
//     String? url = sh.getString("url");
//     String? lid = sh.getString("lid");
//
//     try {
//       var response = await http.post(
//         Uri.parse("${url}viewprofile/"),
//         body: {'lid': lid.toString()}, // Explicitly string
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           userData = json.decode(response.body);
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("Fetch Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Profile"),
//         backgroundColor: Colors.pink,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditProfile(currentData: userData),
//                 ),
//               ).then((value) => fetchProfile()); // Refresh data when returning
//             },
//           )
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.pink))
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             CircleAvatar(
//               radius: 70,
//               backgroundColor: Colors.grey[200],
//               child: ClipOval(
//                 child: Image.network(
//                   userData['photo'].toString(),
//                   fit: BoxFit.cover,
//                   width: 140,
//                   height: 140,
//                   errorBuilder: (context, error, stackTrace) {
//                     print("Image Error: $error"); // Check your console for the real error
//                     return const Icon(Icons.person, size: 70, color: Colors.grey);
//                   },
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return const Center(child: CircularProgressIndicator());
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             _profileItem("Name", userData['name'].toString()),
//             _profileItem("Email", userData['email'].toString()),
//             _profileItem("Phone", userData['phone'].toString()),
//             _profileItem("DOB", userData['DOB'].toString()),
//             _profileItem("Gender", userData['gender'].toString()),
//
//             ListTile(
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewExpertsPage()));
//               },
//               title: Text("Experts", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
//               subtitle: Text("", style: const TextStyle(fontSize: 16)),
//               leading: Icon(Icons.chat, color: Colors.pink),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _profileItem(String title, String value) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
//         subtitle: Text(value == "null" ? "Not Provided" : value, style: const TextStyle(fontSize: 16)),
//         leading: Icon(_getIconFor(title), color: Colors.pink),
//       ),
//     );
//   }
//
//   IconData _getIconFor(String title) {
//     switch (title) {
//       case "Name": return Icons.person;
//       case "Email": return Icons.email;
//       case "Phone": return Icons.phone;
//       case "DOB": return Icons.calendar_today;
//       case "Gender": return Icons.wc;
//       default: return Icons.info;
//     }
//   }
// }



import 'dart:convert';
import 'package:first/sendfeedback.dart';
import 'package:first/view_complaint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'view_experts.dart';
import 'update_profile.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  String baseUrl = "";

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final sh = await SharedPreferences.getInstance();
    baseUrl = sh.getString("url") ?? "";
    String? lid = sh.getString("lid");

    try {
      var response = await http.post(
        Uri.parse("${baseUrl}viewprofile/"),
        body: {'lid': lid.toString()},
      );

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // --- Floating Action Button for Feedback ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SendFeedbackPage()));
        },
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.rate_review, color: Colors.white),
        label: const Text("Feedback", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : CustomScrollView(
        slivers: [
          // 1. Sleek App Bar with Gradient Background
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.pink,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink, Colors.deepOrangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(userData['photo'].toString()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['name'] ?? "User",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_note, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile(currentData: userData)),
                  ).then((value) => fetchProfile());
                },
              )
            ],
          ),

          // 2. Profile Details Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Personal Information",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 10),
                  _buildInfoCard(),

                  const SizedBox(height: 30),
                  const Text("Quick Actions",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 15),

                  // 3. Horizontal Menu for Experts & Others
                  Row(
                    children: [
                      _buildSquareMenu(
                          "View Experts",
                          Icons.psychology,
                          Colors.blue,
                              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewExpertsPage()))
                      ),
                      const SizedBox(width: 15),
                      _buildSquareMenu(
                          "Support",
                          Icons.support_agent,
                          Colors.orange,
                              () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewComplaintsPage()));



                            /* Add Action */ }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Info Section Card
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          _infoRow(Icons.email_outlined, "Email", userData['email']),
          const Divider(),
          _infoRow(Icons.phone_android_outlined, "Phone", userData['phone']),
          const Divider(),
          _infoRow(Icons.cake_outlined, "Birthday", userData['DOB']),
          const Divider(),
          _infoRow(Icons.transgender_outlined, "Gender", userData['gender']),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink, size: 22),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(value?.toString() ?? "Not set", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  // Square Menu Item Design
  Widget _buildSquareMenu(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 35),
              const SizedBox(height: 10),
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // Feedback Popup Dialog
  void _showFeedbackDialog() {
    TextEditingController fbController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("App Feedback"),
        content: TextField(
          controller: fbController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell us what you think...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Later")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () {
                // Add your http.post feedback logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feedback Sent!")));
              },
              child: const Text("Submit", style: TextStyle(color: Colors.white))
          ),
        ],
      ),
    );
  }
}