// import 'package:first/view_profile.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// void main() {
//   runApp(const SocialMediaApp());
// }
//
// // Barcelona FC Theme Colors
// class BarcelonaTheme {
//   static const blaugrana = Color(0xFFA50044); // Deep red/burgundy
//   static const blue = Color(0xFF004D98); // Barcelona blue
//   static const gold = Color(0xFFFCAF17); // Gold accent
//   static const darkBlue = Color(0xFF00285E);
//   static const lightGray = Color(0xFFF5F5F5);
//   static const darkGray = Color(0xFF1A1A2E);
// }
//
// class SocialMediaApp extends StatelessWidget {
//   const SocialMediaApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Barça Social',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: BarcelonaTheme.blue,
//         scaffoldBackgroundColor: BarcelonaTheme.lightGray,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: BarcelonaTheme.blue,
//           primary: BarcelonaTheme.blue,
//           secondary: BarcelonaTheme.blaugrana,
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: BarcelonaTheme.blue,
//           elevation: 0,
//         ),
//       ),
//       darkTheme: ThemeData.dark().copyWith(
//         primaryColor: BarcelonaTheme.blue,
//         scaffoldBackgroundColor: BarcelonaTheme.darkGray,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: BarcelonaTheme.darkBlue,
//           elevation: 0,
//         ),
//       ),
//       home: const HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
//   bool _isDarkMode = false;
//
//   final List<Widget> _pages = [
//     const FeedPage(),
//     const FriendsPage(),
//     const SettingsPage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
//       theme: ThemeData(
//         primaryColor: BarcelonaTheme.blue,
//         scaffoldBackgroundColor: BarcelonaTheme.lightGray,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: BarcelonaTheme.blue,
//           primary: BarcelonaTheme.blue,
//           secondary: BarcelonaTheme.blaugrana,
//         ),
//       ),
//       darkTheme: ThemeData.dark().copyWith(
//         primaryColor: BarcelonaTheme.blue,
//         scaffoldBackgroundColor: BarcelonaTheme.darkGray,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: _isDarkMode ? BarcelonaTheme.darkBlue : BarcelonaTheme.blue,
//           title: const Text(
//             'Barça Social',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 24,
//               color: Colors.white,
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.search, color: Colors.white),
//               onPressed: () {},
//             ),
//             Stack(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.notifications, color: Colors.white),
//                   onPressed: () {},
//                 ),
//                 Positioned(
//                   right: 8,
//                   top: 8,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: BarcelonaTheme.blaugrana,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Text(
//                       '3',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             IconButton(
//               icon: Icon(
//                 _isDarkMode ? Icons.light_mode : Icons.dark_mode,
//                 color: BarcelonaTheme.gold,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isDarkMode = !_isDarkMode;
//                 });
//               },
//             ),
//           ],
//         ),
//         body: _pages[_currentIndex],
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 BarcelonaTheme.blue,
//                 BarcelonaTheme.blaugrana,
//               ],
//             ),
//           ),
//           child: BottomNavigationBar(
//             currentIndex: _currentIndex,
//             onTap: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Colors.transparent,
//             selectedItemColor: BarcelonaTheme.gold,
//             unselectedItemColor: Colors.white70,
//             elevation: 0,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.people),
//                 label: 'Friends',
//               ),
//               BottomNavigationB(
//                 icon: Icon(Icons.chat),
//                 label: 'Chat',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.settings),
//                 label: 'Settings',
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: _currentIndex == 0
//             ? FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ViewProfile(
//                 ),
//               ),
//             );
//             _showCreatePostDialog(context);
//           },
//           backgroundColor: BarcelonaTheme.blaugrana,
//           child: const Icon(Icons.add, color: Colors.white),
//         )
//             : null,
//       ),
//     );
//   }
//
//   void _showCreatePostDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => const CreatePostSheet(),
//     );
//   }
// }
//
// // Feed Page
// class FeedPage extends StatefulWidget {
//   const FeedPage({Key? key}) : super(key: key);
//
//   @override
//   State<FeedPage> createState() => _FeedPageState();
// }
//
// class _FeedPageState extends State<FeedPage> {
//   final List<Post> posts = [
//     Post(
//       username: 'Lionel Messi',
//       avatar: 'LM',
//       time: '2h ago',
//       content: 'Training session was intense today! Ready for the big match 💪⚽',
//       likes: 2547,
//       comments: 342,
//       shares: 89,
//       isLiked: false,
//     ),
//     Post(
//       username: 'Gerard Piqué',
//       avatar: 'GP',
//       time: '5h ago',
//       content: 'Great team spirit! Més que un club 💙❤️',
//       likes: 1823,
//       comments: 198,
//       shares: 56,
//       isLiked: true,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return ListView(
//       children: [
//         // Stories Section
//         Container(
//           height: 120,
//           color: isDark ? BarcelonaTheme.darkBlue : Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: 6,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return _buildAddStory();
//               }
//               return _buildStoryItem('User ${index}', index);
//             },
//           ),
//         ),
//
//         // Posts
//         ...posts.map((post) => _buildPostCard(post, isDark)).toList(),
//       ],
//     );
//   }
//
//   Widget _buildAddStory() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         children: [
//           Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [BarcelonaTheme.blue, BarcelonaTheme.blaugrana],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.add, color: Colors.white, size: 32),
//           ),
//           const SizedBox(height: 4),
//           const Text('Your Story', style: TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStoryItem(String name, int index) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         children: [
//           Container(
//             width: 70,
//             height: 70,
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [BarcelonaTheme.blaugrana, BarcelonaTheme.gold],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   'U$index',
//                   style: TextStyle(
//                     color: BarcelonaTheme.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(name, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPostCard(Post post, bool isDark) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//       color: isDark ? BarcelonaTheme.darkBlue : Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Post Header
//           ListTile(
//             leading: CircleAvatar(
//               backgroundColor: BarcelonaTheme.blaugrana,
//               child: Text(
//                 post.avatar,
//                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//             title: Text(
//               post.username,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(post.time),
//             trailing: IconButton(
//               icon: const Icon(Icons.more_vert),
//               onPressed: () {},
//             ),
//           ),
//
//           // Post Content
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Text(post.content),
//           ),
//
//           // Post Stats
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('${post.likes} likes'),
//                 Row(
//                   children: [
//                     Text('${post.comments} comments'),
//                     const SizedBox(width: 16),
//                     Text('${post.shares} shares'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const Divider(height: 1),
//
//           // Post Actions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               TextButton.icon(
//                 onPressed: () {
//                   setState(() {
//                     post.isLiked = !post.isLiked;
//                     post.likes += post.isLiked ? 1 : -1;
//                   });
//                 },
//                 icon: Icon(
//                   post.isLiked ? Icons.favorite : Icons.favorite_border,
//                   color: post.isLiked ? BarcelonaTheme.blaugrana : null,
//                 ),
//                 label: const Text('Like'),
//               ),
//               TextButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.comment),
//                 label: const Text('Comment'),
//               ),
//               TextButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.share),
//                 label: const Text('Share'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Friends Page
// class FriendsPage extends StatelessWidget {
//   const FriendsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         // Search Bar
//         TextField(
//           decoration: InputDecoration(
//             hintText: 'Search friends...',
//             prefixIcon: const Icon(Icons.search),
//             filled: true,
//             fillColor: isDark ? BarcelonaTheme.darkBlue : Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 20),
//
//         // Friend Requests
//         Text(
//           'Friend Requests (3)',
//           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: BarcelonaTheme.blue,
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         ...List.generate(3, (i) => _buildFriendRequest(context, i, isDark)),
//
//         const SizedBox(height: 20),
//
//         // All Friends
//         Text(
//           'All Friends (48)',
//           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: BarcelonaTheme.blue,
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         ...List.generate(5, (i) => _buildFriendItem(context, i, isDark)),
//       ],
//     );
//   }
//
//   Widget _buildFriendRequest(BuildContext context, int index, bool isDark) {
//     return Card(
//       color: isDark ? BarcelonaTheme.darkBlue : Colors.white,
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: BarcelonaTheme.gold,
//           child: Text('FR', style: TextStyle(color: BarcelonaTheme.blue)),
//         ),
//         title: Text('Friend Request ${index + 1}'),
//         subtitle: const Text('5 mutual friends'),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: BarcelonaTheme.blue,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Accept'),
//             ),
//             const SizedBox(width: 8),
//             OutlinedButton(
//               onPressed: () {},
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: BarcelonaTheme.blaugrana,
//               ),
//               child: const Text('Delete'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFriendItem(BuildContext context, int index, bool isDark) {
//     return Card(
//       color: isDark ? BarcelonaTheme.darkBlue : Colors.white,
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Stack(
//           children: [
//             CircleAvatar(
//               backgroundColor: BarcelonaTheme.blaugrana,
//               child: Text('F${index + 1}', style: const TextStyle(color: Colors.white)),
//             ),
//             if (index % 2 == 0)
//               Positioned(
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   width: 12,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         title: Text('Friend ${index + 1}'),
//         subtitle: Text('${10 + index} mutual friends'),
//         trailing: OutlinedButton(
//           onPressed: () {},
//           style: OutlinedButton.styleFrom(
//             foregroundColor: BarcelonaTheme.blue,
//           ),
//           child: const Text('Message'),
//         ),
//       ),
//     );
//   }
// }
//
// // Chat Page
//
// // Settings Page
// class SettingsPage extends StatelessWidget {
//   const SettingsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return ListView(
//       children: [
//         // Profile Header
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [BarcelonaTheme.blue, BarcelonaTheme.blaugrana],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.white,
//                 child: Text(
//                   'ME',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: BarcelonaTheme.blue,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'My Profile',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const Text(
//                 'user@barca.social',
//                 style: TextStyle(color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 20),
//
//         // Settings Options
//         _buildSettingItem(
//           context,
//           Icons.person,
//           'Edit Profile',
//           BarcelonaTheme.blue,
//           isDark,
//         ),
//         _buildSettingItem(
//           context,
//           Icons.notifications,
//           'Notifications',
//           BarcelonaTheme.blaugrana,
//           isDark,
//         ),
//         _buildSettingItem(
//           context,
//           Icons.lock,
//           'Privacy & Security',
//           BarcelonaTheme.gold,
//           isDark,
//         ),
//         _buildSettingItem(
//           context,
//           Icons.bookmark,
//           'Saved Posts',
//           BarcelonaTheme.blue,
//           isDark,
//         ),
//         _buildSettingItem(
//           context,
//           Icons.block,
//           'Blocked Users',
//           BarcelonaTheme.blaugrana,
//           isDark,
//         ),
//
//         const SizedBox(height: 20),
//
//         // Logout Button
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: BarcelonaTheme.blaugrana,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               'Log Out',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSettingItem(
//       BuildContext context,
//       IconData icon,
//       String title,
//       Color iconColor,
//       bool isDark,
//       ) {
//     return Card(
//       color: isDark ? BarcelonaTheme.darkBlue : Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: iconColor),
//         ),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//         trailing: const Icon(Icons.chevron_right),
//         onTap: () {},
//       ),
//     );
//   }
// }
//
// class CreatePostSheet extends StatefulWidget {
//   const CreatePostSheet({Key? key}) : super(key: key);
//
//   @override
//   State<CreatePostSheet> createState() => _CreatePostSheetState();
// }
//
// class _CreatePostSheetState extends State<CreatePostSheet> {
//   final TextEditingController captionController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//
//   File? selectedImage;
//   bool isLoading = false;
//
//   // PICK IMAGE
//   Future<void> pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: source);
//
//     if (picked != null) {
//       setState(() {
//         selectedImage = File(picked.path);
//       });
//     }
//   }
//
//   // CREATE POST API CALL
//   Future<void> createPost() async {
//     if (captionController.text.isEmpty &&
//         descriptionController.text.isEmpty &&
//         selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Post cannot be empty')),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final ip = prefs.getString('ip');
//       final userId = prefs.getInt('user_id');
//
//       if (ip == null || userId == null) {
//         throw 'Missing IP or User ID';
//       }
//
//       final uri = Uri.parse('http://$ip/create-post/');
//       final request = http.MultipartRequest('POST', uri);
//
//       request.fields['user_id'] = userId.toString();
//       request.fields['caption'] = captionController.text;
//       request.fields['description'] = descriptionController.text;
//
//       if (selectedImage != null) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'image',
//             selectedImage!.path,
//           ),
//         );
//       }
//
//       final response = await request.send();
//
//       setState(() => isLoading = false);
//
//       if (response.statusCode == 201) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Post created successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to create post')),
//         );
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     captionController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       decoration: BoxDecoration(
//         color: isDark ? BarcelonaTheme.darkBlue : Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 12),
//
//             // HEADER
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Create Post',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: BarcelonaTheme.blue,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Divider(),
//
//             // TEXT FIELD
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: TextField(
//                 controller: captionController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   hintText: "What's on your mind?",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//
//             // IMAGE PREVIEW
//             if (selectedImage != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     selectedImage!,
//                     height: 180,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//
//             const SizedBox(height: 12),
//
//             // MEDIA OPTIONS
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _mediaButton(
//                     icon: Icons.photo_library,
//                     label: 'Gallery',
//                     color: Colors.green,
//                     onTap: () => pickImage(ImageSource.gallery),
//                   ),
//                   _mediaButton(
//                     icon: Icons.camera_alt,
//                     label: 'Camera',
//                     color: BarcelonaTheme.blue,
//                     onTap: () => pickImage(ImageSource.camera),
//                   ),
//                 ],
//               ),
//             ),
//
//             // POST BUTTON
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : createPost,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: BarcelonaTheme.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                     'Post',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _mediaButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }
// }
//
//
// // Post Model
// class Post {
//   final String username;
//   final String avatar;
//   final String time;
//   final String content;
//   int likes;
//   final int comments;
//   final int shares;
//   bool isLiked;
//
//   Post({
//     required this.username,
//     required this.avatar,
//     required this.time,
//     required this.content,
//     required this.likes,
//     required this.comments,
//     required this.shares,
//     required this.isLiked,
//   });
// }


import 'package:first/add_post.dart';
import 'package:first/others_post.dart';
import 'package:first/view_comment.dart';
import 'package:first/view_notification.dart';
import 'package:first/view_post.dart';
import 'package:first/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'friends and request.dart';
import 'login.dart';
import 'my_friends.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _FeedPage(),
    PostPage(),
    AddPost(),
    MyFriendsPage(),
    ViewProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.grey[850]!, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_on_outlined), label: 'Posts'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 32),
              label: 'Add',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Friends'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// ─── Feed Page ────────────────────────────────────────────────────────────────

class _FeedPage extends StatefulWidget {
  const _FeedPage();

  @override
  State<_FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<_FeedPage> {
  List posts = [];
  String? baseUrl;
  String? imgUrl;
  String? lid;
  bool isLoading = true;



  final List<Color> _storyColors = [
    Colors.purple,
    const Color(0xFFE1306C),
    const Color(0xFFFD1D1D),
    const Color(0xFFF77737),
    Colors.deepPurple,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    _loadAndFetch();
  }

  Future<void> _loadAndFetch() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    baseUrl = sh.getString("url");
    imgUrl = sh.getString("img");
    lid = sh.getString("lid");
    if (baseUrl != null && !baseUrl!.endsWith("/")) baseUrl = "$baseUrl/";
    await _fetchPosts();
  }

  Future<void> _fetchPosts() async {
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
      setState(() => isLoading = false);
    }
  }

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

  Future<void> _openComments(Map post) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("pid", post['post_id'].toString());
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => CommentsPage()));
  }

  Future<void> _logout() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    // await sh.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : RefreshIndicator(
                onRefresh: _fetchPosts,
                color: Colors.white,
                backgroundColor: Colors.black,
                child: CustomScrollView(
                  slivers: [
                    // SliverToBoxAdapter(child: _buildStories()),
                    const SliverToBoxAdapter(
                      child: Divider(color: Color(0xFF262626), height: 1),
                    ),
                    posts.isEmpty
                        ? const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No posts yet.\nFollow people to see their posts.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    )
                        : SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildPostCard(posts[index], index),
                        childCount: posts.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Instagram-style wordmark
          const Text(
            'OSN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notification_add, color: Colors.white, size: 26),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ViewNotifications()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white, size: 26),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FindFriendsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.white, size: 24),
            onPressed: _logout,
          ),
        ],
      ),
    );
  }


  Widget _buildPostCard(Map post, int index) {
    final isLiked = post['is_liked'] == true;
    final likes = post['total_likes'] ?? 0;

    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE1306C), Color(0xFFF77737)],
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey[800],
                      child: Text(
                        (post['username'] as String? ?? '?')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['username'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                      if (post['Date'] != null)
                        Text(
                          post['Date'],
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                    ],
                  ),
                ),
                 // IconButton(onPressed: (){
                 //
                 //
                 //
                 // }, icon: Icon(Icons.delete)),
              ],
            ),
          ),

          // ── Image ────────────────────────────────────────────────
          GestureDetector(
            onDoubleTap: () => _toggleLike(post, index),
            child: Image.network(
              "${imgUrl!+post['image']}",
              width: double.infinity,
              height: 380,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 300,
                color: Colors.grey[900],
                child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey, size: 48)),
              ),
            ),
          ),

          // ── Actions ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 26,
                  ),
                  onPressed: () => _toggleLike(post, index),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white, size: 24),
                  onPressed: () => _openComments(post),
                ),
                // IconButton(
                //   icon: const Icon(Icons.send_outlined,
                //       color: Colors.white, size: 24),
                //   onPressed: () {},
                // ),
                const Spacer(),
                // IconButton(
                //   icon:
                //   const Icon(Icons.bookmark_border, color: Colors.white, size: 26),
                //   onPressed: () {},
                // ),
              ],
            ),
          ),

          // ── Likes ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$likes ${likes == 1 ? 'like' : 'likes'}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5),
            ),
          ),

          // ── Caption ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 2),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${post['username']}  ',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5),
                  ),
                  TextSpan(
                    text: post['caption'] ?? '',
                    style:
                    const TextStyle(color: Colors.white, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),

          if ((post['description'] ?? '').toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
              child: Text(
                post['description'],
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),

          // ── View comments ────────────────────────────────────────
          GestureDetector(
            onTap: () => _openComments(post),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'View all comments',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),

          const Divider(color: Color(0xFF1A1A1A), height: 1),
        ],
      ),
    );
  }
}