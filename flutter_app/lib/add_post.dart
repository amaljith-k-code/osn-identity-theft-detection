// import 'dart:io';
// import 'dart:convert';
// import 'package:first/homepage.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// import 'login.dart';
//
// // Assuming you have a login page to navigate to
// // import 'package:first/login.dart';
//
// class add_post extends StatefulWidget {
//   const add_post({super.key});
//
//   @override
//   State<add_post> createState() => _add_postState();
// }
//
// class _add_postState extends State<add_post> {
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController captionController = TextEditingController();
//
//
//   String? selectedGender;
//   bool _obscurePassword = true;
//   XFile? _photo;
//
//   // IMAGE PICKERS
//   Future<void> _imgFromCamera() async {
//     final photo = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (photo != null) setState(() => _photo = photo);
//   }
//
//   Future<void> _imgFromGallery() async {
//     final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (photo != null) setState(() => _photo = photo);
//   }
//
//   void _showPicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Gallery'),
//               onTap: () {
//                 _imgFromGallery();
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Camera'),
//               onTap: () {
//                 _imgFromCamera();
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // REGISTER API - MATCHED TO DJANGO
//   Future<void> register() async {
//     // 1. Basic Validation
//     if (_photo == null || captionController.text.isEmpty ) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields and select a photo')),
//       );
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final baseUrl = prefs.getString('url'); // Default for emulator
//       String? lid = prefs.getString('lid'); // Default for emulator
//
//       // Ensure the endpoint matches your urls.py (e.g., /register_api/)
//       final uri = Uri.parse('${baseUrl}add_post/');
//
//       final request = http.MultipartRequest('POST', uri);
//
//       // 2. Matching Keys exactly with Django request.POST['key']
//       request.fields.addAll({
//         'description': descriptionController.text,
//         'caption': captionController.text, // Matched to Django uppercase DOB
//         'lid': lid.toString(), // Matched to Django uppercase DOB
//
//       });
//
//       // 3. Matching File key with Django request.FILES['photo']
//       request.files.add(
//         await http.MultipartFile.fromPath('photo', _photo!.path),
//       );
//
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         // Handle Django's 'username already exists' logic
//         if (data['status'] == 'ok') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Post Added Success')),
//           );
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserHome()));
//
//         } else if (data.containsKey('msg')) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(data['msg'])),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Server Error. Please try again.')),
//         );
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Connection failed: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Post"), centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             // Profile Photo Picker
//             Center(
//               child: GestureDetector(
//                 onTap: () => _showPicker(context),
//                 child: CircleAvatar(
//                   radius: 55,
//                   backgroundColor: Colors.blueGrey[100],
//                   child: _photo != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(55),
//                     child: Image.file(File(_photo!.path), width: 110, height: 110, fit: BoxFit.cover),
//                   )
//                       : const Icon(Icons.camera_alt, size: 40, color: Colors.blueGrey),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             _buildTextField(captionController, "Caption", Icons.closed_caption, ),
//             _buildTextField(descriptionController, "Description", Icons.person),
//
//
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: register,
//                 style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                 child: const Text("Add", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Reusable text field widget
//   Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboard = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboard,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon),
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//
// }


import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:first/homepage.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  XFile? _photo;
  bool _isLoading = false;

  Future<void> _imgFromCamera() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
    if (photo != null) setState(() => _photo = photo);
  }

  Future<void> _imgFromGallery() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (photo != null) setState(() => _photo = photo);
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _imgFromGallery();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take a Photo'),
                onTap: () {
                  _imgFromCamera();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    if (_photo == null || captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a photo and add a caption')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('url');
      String? lid = prefs.getString('lid');

      final uri = Uri.parse('${baseUrl}add_post/');
      final request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'description': descriptionController.text,
        'caption': captionController.text,
        'lid': lid.toString(),
      });

      request.files.add(
        await http.MultipartFile.fromPath('photo', _photo!.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserHome()));
        }
      } else {
        throw Exception("Server Error");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("New Post", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : register,
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("Share", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Preview Area
            GestureDetector(
              onTap: () => _showPicker(context),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width, // Square aspect ratio
                color: Colors.grey[100],
                child: _photo != null
                    ? Image.file(File(_photo!.path), fit: BoxFit.cover)
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.grey[400]),
                    const SizedBox(height: 10),
                    Text("Tap to select a photo", style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Caption Input
                  TextField(
                    controller: captionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),

                  // Description / Detailed Info
                  TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Add more details (Description)...",
                      icon: Icon(Icons.description_outlined, size: 20),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),

                  // Simple Location or Tag placeholders to look more "Social"
                  // ListTile(
                  //   leading: const Icon(Icons.location_on_outlined),
                  //   title: const Text("Add Location", style: TextStyle(fontSize: 14)),
                  //   trailing: const Icon(Icons.chevron_right),
                  //   onTap: () {},
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}