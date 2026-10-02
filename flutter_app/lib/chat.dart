


import 'dart:async';

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {

  final String receiverId;

  final String receiverName;

  const ChatPage({super.key, required this.receiverId, required this.receiverName});

  @override

  State<ChatPage> createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _controller = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  List<dynamic> _messages = [];

  Timer? _timer;

  String? _myId;

  String? _baseUrl;

  @override

  void initState() {

    super.initState();

    _setupChat();

  }

  Future<void> _setupChat() async {

    final sh = await SharedPreferences.getInstance();

    setState(() {

      _myId = sh.getString("lid"); // Your Login ID

      _baseUrl = sh.getString("url"); // e.g., http://192.168.1.5:8000/

    });

    _fetchChat();

    // Polling every 2 seconds to match the Web version logic

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) => _fetchChat());

  }

  Future<void> _fetchChat() async {

    if (_myId == null || _baseUrl == null) return;

    try {

      final response = await http.post(

        Uri.parse("${_baseUrl}chat_api/"),

        body: {

          'sender_id': _myId,

          'receiver_id': widget.receiverId,

        },

      );

      if (response.statusCode == 200) {

        var result = jsonDecode(response.body);

        if (result['status'] == 'ok') {

          setState(() {

            _messages = result['data'];

          });

          // Optional: Auto-scroll to bottom on new message

          // _scrollToBottom();

        }

      }

    } catch (e) {

      debugPrint("Chat Fetch Error: $e");

    }

  }

  Future<void> _sendMessage() async {

    String text = _controller.text.trim();

    if (text.isEmpty) return;

    _controller.clear();

    try {

      await http.post(

        Uri.parse("${_baseUrl}chat_api/"),

        body: {

          'sender_id': _myId,

          'receiver_id': widget.receiverId,

          'message': text,

        },

      );

      _fetchChat(); // Refresh immediately after sending

    } catch (e) {

      debugPrint("Send Error: $e");

    }

  }

  @override

  void dispose() {

    _timer?.cancel();

    _controller.dispose();

    super.dispose();

  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(widget.receiverName),

        backgroundColor: Colors.indigo,

        foregroundColor: Colors.white,

      ),

      body: Column(

        children: [

          Expanded(

            child: ListView.builder(

              controller: _scrollController,

              padding: const EdgeInsets.all(10),

              itemCount: _messages.length,

              itemBuilder: (context, index) {

                final msg = _messages[index];

                bool isMe = msg['sid'].toString() == _myId;

                return Align(

                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

                  child: Container(

                    margin: const EdgeInsets.symmetric(vertical: 5),

                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

                    decoration: BoxDecoration(

                      color: isMe ? Colors.indigo[100] : Colors.grey[300],

                      borderRadius: BorderRadius.only(

                        topLeft: const Radius.circular(15),

                        topRight: const Radius.circular(15),

                        bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,

                        bottomRight: isMe ? Radius.zero : const Radius.circular(15),

                      ),

                    ),

                    child: Column(

                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,

                      children: [

                        Text(msg['msg'], style: const TextStyle(fontSize: 16)),

                        const SizedBox(height: 4),

                        Text(msg['time'], style: const TextStyle(fontSize: 10, color: Colors.black54)),

                      ],

                    ),

                  ),

                );

              },

            ),

          ),

          _buildInputArea(),

        ],

      ),

    );

  }

  Widget _buildInputArea() {

    return Container(

      padding: const EdgeInsets.all(8),

      color: Colors.white,

      child: Row(

        children: [

          Expanded(

            child: TextField(

              controller: _controller,

              decoration: InputDecoration(

                hintText: "Type a message...",

                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),

                contentPadding: const EdgeInsets.symmetric(horizontal: 20),

              ),

            ),

          ),

          const SizedBox(width: 8),

          CircleAvatar(

            backgroundColor: Colors.indigo,

            child: IconButton(

              icon: const Icon(Icons.send, color: Colors.white),

              onPressed: _sendMessage,

            ),

          ),

        ],

      ),

    );

  }

}