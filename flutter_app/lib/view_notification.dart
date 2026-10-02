// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationModel {
//   final String id;
//   final String date;
//   final String description;
//   final String image;
//   final String caption;
//   final String status;
//
//   NotificationModel({
//     required this.id,
//     required this.date,
//     required this.description,
//     required this.image,
//     required this.caption,
//     required this.status,
//   });
// }
//
//
// class ViewNotifications extends StatefulWidget {
//   @override
//   _ViewNotificationsState createState() => _ViewNotificationsState();
// }
//
// class _ViewNotificationsState extends State<ViewNotifications> {
//   List<NotificationModel> notifications = [];
//   bool isLoading = true;
//   String? img = "";
//
//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//   }
//
//   // FETCH NOTIFICATIONS
//   Future<void> fetchNotifications() async {
//     final sh = await SharedPreferences.getInstance();
//     String? url = sh.getString("url");
//     String? lid = sh.getString("lid");
//     img=sh.getString("img");// Assuming you stored lid during login
//
//     var response = await http.post(
//       Uri.parse("${url}user_view_notification/"),
//       body: {'lid': lid},
//     );
//
//     if (response.statusCode == 200) {
//       var jsonData = json.decode(response.body);
//       List<NotificationModel> temp = [];
//       for (var i in jsonData['data']) {
//         temp.add(NotificationModel(
//           id: i['id'].toString(),
//           date: i['date'],
//           description: i['description'],
//           image: i['image'],
//           caption: i['caption'],
//           status: i['status'],
//         ));
//       }
//       setState(() {
//         notifications = temp;
//         isLoading = false;
//       });
//     }
//   }
//
//   // ACCEPT NOTIFICATION
//   Future<void> updateStatus(String nid, String actionType) async {
//     final sh = await SharedPreferences.getInstance();
//     String? url = sh.getString("url");
//
//   print(actionType);
//   print("=====================");
//     // Using your user_accept_notification endpoint
//     String endpoint = actionType == "Accept" ? "user_accept_notification/" : "user_reject_notification/";
//     // String endpoint = actionType == "Accept" ? "user_accept_notification/" : "user_reject_notification/";
//
//     var response = await http.post(
//       Uri.parse("$url$endpoint"),
//       body: {'nid': nid},
//     );
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Notification $actionType successful!")),
//       );
//       fetchNotifications(); // Refresh the list
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Notifications")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 // Image loading using the "img" shared pref
//
//
//                 Image.network(img!+"/"+notifications[index].image,fit: BoxFit.cover,),
//
//                 // FutureBuilder(
//                 //   future: SharedPreferences.getInstance(),
//                 //   builder: (context, snapshot) {
//                 //     if (snapshot.hasData) {
//                 //       String baseUrl = snapshot.data!.getString("img") ?? "";
//                 //       return Image.network(
//                 //         baseUrl + notifications[index].image,
//                 //         height: 200,
//                 //         width: double.infinity,
//                 //         fit: BoxFit.cover,
//                 //         errorBuilder: (context, error, stackTrace) =>
//                 //             Icon(Icons.broken_image, size: 100),
//                 //       );
//                 //     }
//                 //     return Container(height: 200);
//                 //   },
//                 // ),
//                 ListTile(
//                   title: Text(notifications[index].caption),
//                   subtitle: Text("${notifications[index].description}\nDate: ${notifications[index].date}"),
//                   trailing: Text(notifications[index].status,
//                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                 ),
//
//                 // ACCEPT / REJECT BUTTONS
//                 if (notifications[index].status == "pending") // Only show if not already processed
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                           onPressed: () => updateStatus(notifications[index].id, "Accept"),
//                           child: Text("Accept", style: TextStyle(color: Colors.white)),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                           onPressed: () => updateStatus(notifications[index].id, "Reject"),
//                           child: Text("Reject", style: TextStyle(color: Colors.white)),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Add intl to your pubspec.yaml for date formatting

class NotificationModel {
  final String id;
  final String date;
  final String description;
  final String image;
  final String caption;
  final String status;

  NotificationModel({
    required this.id,
    required this.date,
    required this.description,
    required this.image,
    required this.caption,
    required this.status,
  });
}

class ViewNotifications extends StatefulWidget {
  @override
  _ViewNotificationsState createState() => _ViewNotificationsState();
}

class _ViewNotificationsState extends State<ViewNotifications> {
  List<NotificationModel> allNotifications = [];
  List<NotificationModel> filteredNotifications = [];
  bool isLoading = true;
  String? imgBaseUrl = "";
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString("url");
    String? lid = sh.getString("lid");
    imgBaseUrl = sh.getString("img");

    try {
      var response = await http.post(
        Uri.parse("${url}user_view_notification/"),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<NotificationModel> temp = [];
        for (var i in jsonData['data']) {
          temp.add(NotificationModel(
            id: i['id'].toString(),
            date: i['date'], // Expecting "yyyy-MM-dd"
            description: i['description'],
            image: i['image'],
            caption: i['caption'],
            status: i['status'],
          ));
        }
        setState(() {
          allNotifications = temp;
          filteredNotifications = temp;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching: $e");
    }
  }

  // --- FILTRATION LOGIC ---
  void _filterByDate(DateTime? pick) {
    setState(() {
      selectedDate = pick;
      if (pick == null) {
        filteredNotifications = allNotifications;
      } else {
        String formatted = DateFormat('yyyy-MM-dd').format(pick);
        filteredNotifications = allNotifications
            .where((n) => n.date.contains(formatted))
            .toList();
      }
    });
  }

  Future<void> updateStatus(String nid, String actionType) async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString("url");
    String endpoint = actionType == "Accept" ? "user_accept_notification/" : "user_reject_notification/";

    var response = await http.post(
      Uri.parse("$url$endpoint"),
      body: {'nid': nid},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notification $actionType successful!")),
      );
      fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // Clear Filter Button
          if (selectedDate != null)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => _filterByDate(null),
            ),
          // Date Picker Button
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) _filterByDate(picked);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredNotifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: filteredNotifications.length,
        itemBuilder: (context, index) {
          final item = filteredNotifications[index];
          return _buildNotificationCard(item);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text("No notifications found for this date", style: TextStyle(color: Colors.grey[600])),
          TextButton(onPressed: () => _filterByDate(null), child: Text("View All"))
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Stack(
            children: [
              Image.network(
                "$imgBaseUrl/${item.image}",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey[500]),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.caption, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(item.description, style: TextStyle(color: Colors.grey[700])),
                Divider(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(item.date, style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    if (item.status.toLowerCase() == "pending")
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => updateStatus(item.id, "Reject"),
                            child: Text("Reject", style: TextStyle(color: Colors.red)),
                          ),
                          ElevatedButton(
                            onPressed: () => updateStatus(item.id, "Accept"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Accept", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'accept': return Colors.green;
      case 'reject': return Colors.red;
      default: return Colors.blue;
    }
  }
}