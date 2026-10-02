// import 'dart:io';
// import 'dart:convert';
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
// class SignUpForm extends StatefulWidget {
//   const SignUpForm({super.key});
//
//   @override
//   State<SignUpForm> createState() => _SignUpFormState();
// }
//
// class _SignUpFormState extends State<SignUpForm> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
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
//     if (_photo == null || selectedGender == null || nameController.text.isEmpty || usernameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields and select a photo')),
//       );
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final baseUrl = prefs.getString('url') ?? 'http://10.0.2.2:8000'; // Default for emulator
//
//       // Ensure the endpoint matches your urls.py (e.g., /register_api/)
//       final uri = Uri.parse('${baseUrl}register/');
//
//       final request = http.MultipartRequest('POST', uri);
//
//       // 2. Matching Keys exactly with Django request.POST['key']
//       request.fields.addAll({
//         'name': nameController.text,
//         'email': emailController.text,
//         'phone': phoneController.text,
//         'DOB': dobController.text, // Matched to Django uppercase DOB
//         'gender': selectedGender!,
//         'username': usernameController.text,
//         'password': passwordController.text,
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
//             const SnackBar(content: Text('Registration successful')),
//           );
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
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
//       appBar: AppBar(title: const Text("User Registration"), centerTitle: true),
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
//             _buildTextField(nameController, "Full Name", Icons.person),
//             _buildTextField(emailController, "Email", Icons.email, keyboard: TextInputType.emailAddress),
//             _buildTextField(phoneController, "Phone", Icons.phone, keyboard: TextInputType.phone),
//             _buildTextField(dobController, "Date of Birth (YYYY-MM-DD)", Icons.calendar_today),
//
//             const SizedBox(height: 10),
//             _buildGenderSelector(),
//             const SizedBox(height: 10),
//
//             _buildTextField(usernameController, "Username", Icons.account_circle),
//             _buildPasswordField(),
//
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: register,
//                 style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                 child: const Text("REGISTER NOW", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
//   Widget _buildPasswordField() {
//     return TextField(
//       controller: passwordController,
//       obscureText: _obscurePassword,
//       decoration: InputDecoration(
//         labelText: "Password",
//         prefixIcon: const Icon(Icons.lock),
//         suffixIcon: IconButton(
//           icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//           onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//         ),
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
//
//   Widget _buildGenderSelector() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         Row(
//           children: [
//             Radio<String>(value: 'Male', groupValue: selectedGender, onChanged: (v) => setState(() => selectedGender = v)),
//             const Text("Male"),
//             Radio<String>(value: 'Female', groupValue: selectedGender, onChanged: (v) => setState(() => selectedGender = v)),
//             const Text("Female"),
//             Radio<String>(value: 'Other', groupValue: selectedGender, onChanged: (v) => setState(() => selectedGender = v)),
//             const Text("Other"),
//           ],
//         ),
//       ],
//     );
//   }
// }



import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Add this to pubspec.yaml for date formatting

import 'login.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedGender;
  bool _obscurePassword = true;
  XFile? _photo;

  // --- DATE PICKER LOGIC ---
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.indigo),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // --- IMAGE PICKER ---
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            const Text("Profile Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.photo_library, color: Colors.white)),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (photo != null) setState(() => _photo = photo);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.camera_alt, color: Colors.white)),
              title: const Text('Capture from Camera'),
              onTap: () async {
                final photo = await ImagePicker().pickImage(source: ImageSource.camera);
                if (photo != null) setState(() => _photo = photo);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- REGISTER LOGIC ---
  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a profile photo')));
      return;
    }
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select gender')));
      return;
    }


      // 1. Basic Validation
      if (_photo == null || selectedGender == null || nameController.text.isEmpty || usernameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields and select a photo')),
        );
        return;
      }

      try {
        final prefs = await SharedPreferences.getInstance();
        final baseUrl = prefs.getString('url') ?? 'http://10.0.2.2:8000'; // Default for emulator

        // Ensure the endpoint matches your urls.py (e.g., /register_api/)
        final uri = Uri.parse('${baseUrl}register/');

        final request = http.MultipartRequest('POST', uri);

        // 2. Matching Keys exactly with Django request.POST['key']
        request.fields.addAll({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'DOB': dobController.text, // Matched to Django uppercase DOB
          'gender': selectedGender!,
          'username': usernameController.text,
          'password': passwordController.text,
        });

        // 3. Matching File key with Django request.FILES['photo']
        request.files.add(
          await http.MultipartFile.fromPath('photo', _photo!.path),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          // Handle Django's 'username already exists' logic
          if (data['status'] == 'ok') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful')),
            );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
          } else if (data.containsKey('msg')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['msg'])),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Server Error. Please try again.')),
          );
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection failed: $e')),
        );
      }
    // [Keep your existing http.MultipartRequest logic here...]
    // Note: ensure you use _formKey.currentState!.validate() before calling API.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blueAccent]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _showPicker(context),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white24,
                            backgroundImage: _photo != null ? FileImage(File(_photo!.path)) : null,
                            child: _photo == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: CircleAvatar(
                              radius: 18, backgroundColor: Colors.white,
                              child: Icon(Icons.add_a_photo, size: 18, color: Colors.indigo[900]),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(nameController, "Full Name", Icons.person_outline, (v) => v!.isEmpty ? "Enter name" : null),

                    _buildField(emailController, "Email Address", Icons.email_outlined, (v) {
                      if (v!.isEmpty) return "Enter email";
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Enter valid email";
                      return null;
                    }, type: TextInputType.emailAddress),

                    _buildField(phoneController, "Phone Number", Icons.phone_android_outlined, (v) {
                      if (v!.isEmpty) return "Enter phone";
                      if (v.length != 10) return "Phone must be 10 digits";
                      return null;
                    }, type: TextInputType.phone),

                    // Date of Birth Field (Tappable)
                    TextFormField(
                      controller: dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (v) => v!.isEmpty ? "Select date" : null,
                      decoration: _inputDecoration("Date of Birth", Icons.calendar_month_outlined),
                    ),
                    const SizedBox(height: 20),

                    _buildGenderSelector(),
                    const SizedBox(height: 20),

                    _buildField(usernameController, "Username", Icons.alternate_email, (v) => v!.isEmpty ? "Enter username" : null),

                    _buildPasswordField(),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      child: const Text("REGISTER NOW", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE DESIGN COMPONENTS ---

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.indigo, width: 2)),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, String? Function(String?)? validator, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        validator: validator,
        decoration: _inputDecoration(label, icon),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscurePassword,
      validator: (v) => v!.length < 6 ? "Password too short" : null,
      decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text("Gender", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _radioOption("Male"),
              _radioOption("Female"),
              _radioOption("Other"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _radioOption(String val) {
    return Row(
      children: [
        Radio<String>(
          value: val,
          groupValue: selectedGender,
          activeColor: Colors.indigo,
          onChanged: (v) => setState(() => selectedGender = v),
        ),
        Text(val),
      ],
    );
  }
}




