import 'dart:convert';
import 'package:first/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:first/register.dart';

import 'homepage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Add this line

  // Helper to show error dialogs
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }


  void _showAlertDialogB(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Banned'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // THE LOGIN LOGIC MATCHED TO YOUR DJANGO CODE
  Future<void> loginProcess() async {
    final sh = await SharedPreferences.getInstance();
    String uname = usernameController.text.trim();
    String passwd = passwordController.text.trim();

    // Get the base URL (e.g., http://192.168.1.5:8000/myapp/)
    String? baseUrl = sh.getString("url");

    if (uname.isEmpty || passwd.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter username and password");
      return;
    }

    try {
      // url + "flutter_login/" matches your path('flutter_login/', ...)
      final fullUrl = Uri.parse("${baseUrl}flutter_login/");

      var response = await http.post(
        fullUrl,
        body: {
          'username': uname,
          'password': passwd,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        String status = jsonData['status'].toString();

        print(status);
        print("status");

        if (status == "ok") {
          // Saving all user details returned by your Django view
          sh.setString("lid", jsonData['lid'].toString());
          sh.setString("user_name", jsonData['name'].toString());
          sh.setString("user_email", jsonData['email'].toString());
          sh.setString("user_image", jsonData['image'].toString());

          Fluttertoast.showToast(msg: "Login Successful");

          // Navigate to Home
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UserHome()),
                (route) => false,
          );
        }
        else if(status == "blocked"){

          // Fluttertoast.showToast(msg: "Blocked");
          _showAlertDialogB("You are Blocked by admin.");
        }
        else {
          _showAlertDialog("Invalid username or password.");
        }
      } else {
        Fluttertoast.showToast(msg: "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Login Error: $e");
      Fluttertoast.showToast(msg: "Connection Error: Check your IP/Network");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 150),
                  const Icon(Icons.lock_outline, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Username Field

                  // Username Field
                  _buildTextField(usernameController, 'Username', Icons.person),
                  const SizedBox(height: 20),

// Password Field - Change 'isObscure: true' to 'isPassword: true'
                  _buildTextField(passwordController, 'Password', Icons.lock, isPassword: true),
                  // _buildTextField(usernameController, 'Username', Icons.person),
                  const SizedBox(height: 20),

                  // Password Field
                  // _buildTextField(passwordController, 'Password', Icons.lock, isObscure: true),

                  // const SizedBox(height: 30),

                  // Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.pink,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                        ),
                        onPressed: loginProcess,
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(color: Colors.white70)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpForm()),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable text field UI


  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        // If it's a password field, obscure text only if _isPasswordVisible is false
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white),

          // Add the Visibility Toggle Icon here
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }
  // Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isObscure = false}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: TextField(
  //       controller: controller,
  //       obscureText: isObscure,
  //       style: const TextStyle(color: Colors.white),
  //       decoration: InputDecoration(
  //         labelText: label,
  //         labelStyle: const TextStyle(color: Colors.white),
  //         prefixIcon: Icon(icon, color: Colors.white),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //           borderSide: const BorderSide(color: Colors.white54),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //           borderSide: const BorderSide(color: Colors.white),
  //         ),
  //         filled: true,
  //         fillColor: Colors.white.withOpacity(0.1),
  //       ),
  //     ),
  //   );
  // }
}