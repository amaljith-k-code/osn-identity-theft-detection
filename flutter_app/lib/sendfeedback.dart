import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendFeedbackPage extends StatefulWidget {
  @override
  _SendFeedbackPageState createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _currentRating = 3.0; // Default rating
  bool _isLoading = false;

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your feedback")),
      );
      return;
    }

    setState(() => _isLoading = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? baseUrl = sh.getString("url");
    String? lid = sh.getString("lid");

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}send_feedback/"),
        body: {
          "lid": lid,
          "feedback": _feedbackController.text,
          "rating": _currentRating.toString(),
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "ok") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Feedback sent successfully!")),
          );
          Navigator.pop(context); // Go back after success
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How was your experience?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Star Rating Display
            Center(
              child: Column(
                children: [
                  Text("Rating: ${_currentRating.toInt()} / 5",
                      style: TextStyle(fontSize: 16, color: Colors.blue)),
                  Slider(
                    value: _currentRating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _currentRating.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentRating = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your feedback here...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitFeedback,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Submit Feedback"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}