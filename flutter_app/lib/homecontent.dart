import 'package:first/add_post.dart';
import 'package:first/others_post.dart';
import 'package:first/view_post.dart';
import 'package:first/view_profile.dart';
import 'package:flutter/material.dart';

import 'friends and request.dart';
import 'login.dart';
import 'my_friends.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Home'),

      ),

      body: Column(
        children: [
          ElevatedButton(onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewProfile()));
          }, child: Text('Profile')),

          ElevatedButton(onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
          }, child: Text('POST')),

          ElevatedButton(onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (context)=>PostPage()));
          }, child: Text('View Post')),



          ElevatedButton(onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (context)=>Others_post()));
          }, child: Text('Others Post')),



          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>FindFriendsPage()));}, child: Text('Find Friends')),
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>MyFriendsPage()));}, child: Text('My Friends')),
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));}, child: Text('Logout')),
        ],
      ),
    );
  }
}
//
// import 'package:first/add_post.dart';
// import 'package:first/others_post.dart';
// import 'package:first/view_post.dart';
// import 'package:first/view_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'friends and request.dart';
// import 'login.dart';
// import 'my_friends.dart';
//
// class UserHome extends StatefulWidget {
//   const UserHome({super.key});
//
//   @override
//   State<UserHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<UserHome> {
//   int _currentIndex = 0;
//   List posts = [];
//   String? baseUrl;
//   String? imgUrl;
//   String? lid;
//   bool isLoading = true;
//
//   final List<Map<String, String>> _stories = [
//     {'name': 'Your Story', 'initial': '+'},
//     {'name': 'Alex', 'initial': 'A'},
//     {'name': 'Mia', 'initial': 'M'},
//     {'name': 'Jake', 'initial': 'J'},
//     {'name': 'Sara', 'initial': 'S'},
//     {'name': 'Tom', 'initial': 'T'},
//   ];
//
//   final List<Color> _storyColors = [
//     const Color(0xFF833AB4),
//     const Color(0xFFF77737),
//     const Color(0xFFE1306C),
//     const Color(0xFF405DE6),
//     const Color(0xFF5851DB),
//     const Color(0xFFC13584),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//     loadPrefs();
//   }
//
//   Future<void> loadPrefs() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     baseUrl = sh.getString("url");
//     imgUrl = sh.getString("img");
//     lid = sh.getString("lid");
//     if (baseUrl != null && !baseUrl!.endsWith("/")) {
//       baseUrl = "$baseUrl/";
//     }
//     fetchPosts();
//   }
//
//   Future<void> fetchPosts() async {
//     try {
//       var response = await http.post(
//         Uri.parse("${baseUrl}view_others_post/"),
//         body: {"lid": lid},
//       );
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         setState(() {
//           posts = data["data"] ?? [];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> toggleLike(Map post, int index) async {
//     // Optimistic update
//     setState(() {
//       posts[index]['is_liked'] = !(posts[index]['is_liked'] == true);
//       posts[index]['total_likes'] = (posts[index]['total_likes'] ?? 0) +
//           (posts[index]['is_liked'] == true ? 1 : -1);
//     });
//     try {
//       final response = await http.post(
//         Uri.parse("${baseUrl}toggle_likee/"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"user_id": lid, "post_id": post['post_id']}),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           posts[index]['is_liked'] = data["status"] == "liked";
//           posts[index]['total_likes'] = data["total_likes"];
//         });
//       }
//     } catch (e) {
//       // Revert optimistic update on error
//       setState(() {
//         posts[index]['is_liked'] = !(posts[index]['is_liked'] == true);
//         posts[index]['total_likes'] = (posts[index]['total_likes'] ?? 0) +
//             (posts[index]['is_liked'] == true ? 1 : -1);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF000000),
//       body: _buildBody(),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }
//
//   Widget _buildBody() {
//     switch (_currentIndex) {
//       case 0:
//         return _buildFeed();
//       case 1:
//         return _wrapScaffold(FindFriendsPage(), 'Discover');
//       case 2:
//         return _wrapScaffold(add_post(), 'New Post');
//       case 3:
//         return _wrapScaffold(PostPage(), 'My Posts');
//       case 4:
//         return _wrapScaffold(ViewProfile(), 'Profile');
//       default:
//         return _buildFeed();
//     }
//   }
//
//   Widget _wrapScaffold(Widget page, String title) {
//     return page;
//   }
//
//   Widget _buildFeed() {
//     return CustomScrollView(
//       slivers: [
//         _buildAppBar(),
//         SliverToBoxAdapter(child: _buildStories()),
//         SliverToBoxAdapter(
//           child: Divider(color: Colors.grey[900], thickness: 1),
//         ),
//         isLoading
//             ? SliverFillRemaining(
//           child: Center(
//             child: CircularProgressIndicator(
//               color: const Color(0xFFE1306C),
//               strokeWidth: 2,
//             ),
//           ),
//         )
//             : posts.isEmpty
//             ? SliverFillRemaining(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.photo_camera_outlined,
//                     color: Colors.grey[700], size: 64),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No posts yet',
//                   style: TextStyle(
//                       color: Colors.grey[500], fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         )
//             : SliverList(
//           delegate: SliverChildBuilderDelegate(
//                 (context, index) => _buildPostCard(posts[index], index),
//             childCount: posts.length,
//           ),
//         ),
//       ],
//     );
//   }
//
//   SliverAppBar _buildAppBar() {
//     return SliverAppBar(
//       floating: true,
//       snap: true,
//       backgroundColor: Colors.black,
//       elevation: 0,
//       title: ShaderMask(
//         shaderCallback: (bounds) => const LinearGradient(
//           colors: [Color(0xFFF09433), Color(0xFFE1306C), Color(0xFF833AB4)],
//         ).createShader(bounds),
//         child: const Text(
//           'Postify',
//           style: TextStyle(
//             fontFamily: 'Georgia',
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             letterSpacing: -0.5,
//           ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.favorite_border, color: Colors.white, size: 26),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: const Icon(Icons.send_outlined, color: Colors.white, size: 24),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStories() {
//     return SizedBox(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         itemCount: _stories.length,
//         itemBuilder: (context, index) {
//           final story = _stories[index];
//           final color = _storyColors[index % _storyColors.length];
//           return Padding(
//             padding: const EdgeInsets.only(right: 14),
//             child: Column(
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: index == 0
//                         ? null
//                         : LinearGradient(
//                       colors: [
//                         _storyColors[index % _storyColors.length],
//                         _storyColors[(index + 2) % _storyColors.length],
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     border: index == 0
//                         ? Border.all(color: Colors.grey[700]!, width: 1.5)
//                         : null,
//                     color: index == 0 ? Colors.grey[900] : null,
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(index == 0 ? 0 : 2.5),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: index == 0 ? Colors.grey[900] : Colors.black,
//                       ),
//                       child: Center(
//                         child: Text(
//                           story['initial']!,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: index == 0 ? 22 : 18,
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   story['name']!,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 11,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildPostCard(Map post, int index) {
//     final isLiked = post['is_liked'] == true;
//     return Container(
//       color: Colors.black,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFF09433), Color(0xFFE1306C)],
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(2),
//                     child: CircleAvatar(
//                       backgroundColor: Colors.grey[900],
//                       child: Text(
//                         (post['username'] ?? 'U')[0].toUpperCase(),
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 14),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         post['username'] ?? '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13.5,
//                         ),
//                       ),
//                       if (post['Date'] != null)
//                         Text(
//                           post['Date'],
//                           style: TextStyle(
//                               color: Colors.grey[600], fontSize: 11),
//                         ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.more_horiz, color: Colors.white),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//
//           // Image
//           GestureDetector(
//             onDoubleTap: () => toggleLike(post, index),
//             child: Image.network(
//               "${imgUrl ?? ''}${post['image']}",
//               width: double.infinity,
//               height: 380,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 height: 300,
//                 color: Colors.grey[900],
//                 child: const Center(
//                     child: Icon(Icons.broken_image, color: Colors.grey)),
//               ),
//             ),
//           ),
//
//           // Actions
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 200),
//                     child: Icon(
//                       isLiked ? Icons.favorite : Icons.favorite_border,
//                       key: ValueKey(isLiked),
//                       color: isLiked ? const Color(0xFFE1306C) : Colors.white,
//                       size: 26,
//                     ),
//                   ),
//                   onPressed: () => toggleLike(post, index),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.chat_bubble_outline,
//                       color: Colors.white, size: 24),
//                   onPressed: () async {
//                     SharedPreferences sh =
//                     await SharedPreferences.getInstance();
//                     sh.setString("pid", post['post_id'].toString());
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CommentsPage()));
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send_outlined,
//                       color: Colors.white, size: 24),
//                   onPressed: () {},
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.bookmark_border,
//                       color: Colors.white, size: 24),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//
//           // Likes & Caption
//           Padding(
//             padding:
//             const EdgeInsets.symmetric(horizontal: 14).copyWith(bottom: 6),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${post['total_likes'] ?? 0} likes",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 13.5,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "${post['username'] ?? ''}  ",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13.5,
//                         ),
//                       ),
//                       TextSpan(
//                         text: post['caption'] ?? '',
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 13.5),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (post['description'] != null &&
//                     post['description'].toString().isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 2),
//                     child: Text(
//                       post['description'],
//                       style:
//                       TextStyle(color: Colors.grey[400], fontSize: 13),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//
//           Divider(color: Colors.grey[900], thickness: 0.5),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomNav() {
//     final icons = [
//       Icons.home_filled,
//       Icons.search,
//       Icons.add_box_outlined,
//       Icons.grid_on,
//       Icons.person_outline,
//     ];
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black,
//         border: Border(top: BorderSide(color: Colors.grey[900]!, width: 0.5)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: SizedBox(
//           height: 52,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(icons.length, (index) {
//               final isSelected = _currentIndex == index;
//               return GestureDetector(
//                 onTap: () {
//                   if (index == 1) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => FindFriendsPage()));
//                     return;
//                   }
//                   if (index == 2) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => add_post()));
//                     return;
//                   }
//                   if (index == 3) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => PostPage()));
//                     return;
//                   }
//                   if (index == 4) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ViewProfile()));
//                     return;
//                   }
//                   setState(() => _currentIndex = index);
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.all(8),
//                   child: Icon(
//                     icons[index],
//                     color: isSelected ? Colors.white : Colors.grey[600],
//                     size: isSelected ? 28 : 26,
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Placeholder CommentsPage import fix - ensure this matches your import
// // import 'package:first/view_comment.dart';