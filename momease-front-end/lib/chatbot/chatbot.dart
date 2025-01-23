import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatListPage(),
    );
  }
}

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> chats = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatsData = prefs.getStringList('chats') ?? [];
    setState(() {
      chats = chatsData.map((chatJson) => json.decode(chatJson) as Map<String, dynamic>).toList();
    });
  }

  Future<void> _saveChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatsJson = chats.map((chat) => json.encode(chat)).toList();
    await prefs.setStringList('chats', chatsJson);
  }


  void _createNewChat() async {
    String? chatName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Enter Chat Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Chat name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
    if (chatName != null && chatName.isNotEmpty) {
      setState(() {
        chats.add({"title": chatName, "key": chatName, "messages": []});
        _saveChats();
      });
    }
  }

  void _deleteChat(int index) async {
    setState(() {
      chats.removeAt(index);
      _saveChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final lastMessage = chats[index]['messages'].isNotEmpty ? chats[index]['messages'].last['content'] : 'No messages yet';
          return ListTile(
            title: Text(chats[index]['title']),
            subtitle: Text(lastMessage),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomPage(
                    chat: chats[index],
                    onMessageSent: (message) {
                      setState(() {
                        chats[index]['messages'].add({'role': 'user', 'content': message});
                        _saveChats();
                      });
                    },
                  ),
                ),
              );
            },
            trailing: PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'delete') {
                  _deleteChat(index);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewChat,
        child: Icon(Icons.add),
      ),
    );
  }
}


class ChatRoomPage extends StatefulWidget {
  final Map<String, dynamic> chat;
  final Function(String) onMessageSent;

  ChatRoomPage({required this.chat, required this.onMessageSent});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}


class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  bool isLoading = false;
  final String geminiApiKey = 'AIzaSyAhXwJ6NLgxqFJxXqXvZVGK2VzmS_lozP0';


  Future<String> _sendMessageToGemini(String message) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key= $geminiApiKey');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $geminiApiKey',
    };
    final body = jsonEncode({
      "model": "text-davinci-003", // Or whichever Gemini model you want to use
      "prompt": message,
      "max_tokens": 50, // Adjust as needed
    });


      try {
        final response = await http.post(Uri.parse('$url?key=$geminiApiKey'), headers: headers, body: body);


      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);


        final geminiMessage = jsonResponse['candidates'][0]['content']['parts'][0]['text']; // Correct path


        setState(() {
          widget.chat['messages'].add({'role': 'assistant', 'content': geminiMessage});
          isLoading = false;
        });


        return geminiMessage;
      } else {
        // Handle errors
        print('Error from Gemini API: ${response.statusCode} - ${response.body}');
        setState(() {
          isLoading = false;
        });
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        isLoading = false;
      });
      return 'Error: $e';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat['title']),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
           Expanded(
            child: ListView.builder(
              reverse: false,
              padding: EdgeInsets.all(16.0),
              itemCount: widget.chat['messages'].length,
              itemBuilder: (context, index) {
                final message = widget.chat['messages'][index];
                final isUserMessage = message['role'] == 'user';
                 return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message['content'],
                      style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),

          Divider(height: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () async {
                    if (messageController.text.isNotEmpty) {
                       widget.onMessageSent(messageController.text);
                      await _sendMessageToGemini(messageController.text);

                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}