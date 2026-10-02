import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> currentData;
  const EditProfile({super.key, required this.currentData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  String? selectedGender;
  XFile? _newPhoto;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentData['name'].toString());
    emailController = TextEditingController(text: widget.currentData['email'].toString());
    phoneController = TextEditingController(text: widget.currentData['phone'].toString());
    dobController = TextEditingController(text: widget.currentData['DOB'].toString());
    selectedGender = widget.currentData['gender'].toString();
  }

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo != null) setState(() => _newPhoto = photo);
  }

  Future<void> _pickcamera() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) setState(() => _newPhoto = photo);
  }

  Future<void> updateProfile() async {
    setState(() => isSaving = true);
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString("url");
    String? lid = sh.getString("lid");

    try {
      var request = http.MultipartRequest('POST', Uri.parse("${url}update_profile/"));

      // FIX: Explicitly convert every key and value to string
      request.fields['lid'] = lid.toString();
      request.fields['name'] = nameController.text.toString();
      request.fields['email'] = emailController.text.toString();
      request.fields['phone'] = phoneController.text.toString();
      request.fields['DOB'] = dobController.text.toString();
      request.fields['gender'] = selectedGender.toString();

      if (_newPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', _newPhoto!.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'ok') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
          Navigator.pop(context, "refresh");
        }
      } else {
        throw Exception("Server Error");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), backgroundColor: Colors.pink, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [


                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _newPhoto != null
                        ? FileImage(File(_newPhoto!.path)) as ImageProvider
                        : NetworkImage(widget.currentData['photo'].toString()),
                  ),
                  // const Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child:
                  //   CircleAvatar(
                  //     backgroundColor: Colors.pink,
                  //     radius: 18,
                  //     child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  //   ),
                  // ),
                  const Positioned(
                    bottom: 0,
                    right: 2,
                    child:
                    CircleAvatar(
                      backgroundColor: Colors.pink,
                      radius: 18,
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),


                ],
              ),
            ),
            ElevatedButton(onPressed: (){
              _pickcamera();
            }, child: Text("Camera")),
            const SizedBox(height: 30),
            _buildEditField(nameController, "Name", Icons.person),
            _buildEditField(emailController, "Email", Icons.email),
            _buildEditField(phoneController, "Phone", Icons.phone),
            _buildEditField(dobController, "DOB (YYYY-MM-DD)", Icons.calendar_today),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: ["male", "female", "other"].contains(selectedGender) ? selectedGender : null,
              decoration: const InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
              items: ["male", "female", "other"].map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val.toUpperCase()));
              }).toList(),
              onChanged: (val) => setState(() => selectedGender = val),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : updateProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.pink),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

