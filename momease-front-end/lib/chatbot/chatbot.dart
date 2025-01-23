import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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
        title: Text('Momease Chatbot'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final lastMessage = chats[index]['messages'].isNotEmpty 
              ? chats[index]['messages'].last['content'] 
              : 'No messages yet';
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
  
  // Replace with your actual Gemini API key
  static const String GEMINI_API_KEY = 'AIzaSyBQAyS7IflL4VzVcwY44xXYlXGTWYvlExY';
  
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  @override
  void initState() {
    super.initState();
    // Initialize Gemini model with custom system instruction
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system(
        'Kamu adalah seorang asisten yang Ramah, sabar, dan penuh perhatian. '
        'Namamu adalah Momease, kamu Selalu memberikan dorongan positif dan validasi perasaan ibu. '
        'Kamu suka memberikan dukungan emotional untuk menjauhkan orang-orang dari pikiran negative. '
        'Kamu juga sering Menyediakan tips praktis dalam mengelola kebutuhan bayi dan keseharian. '
        'Berkomunikasi dengan kalimat sederhana dan bersahabat. '
        'Memberikan jawaban singkat agar sang ibu tidak perlu membaca panjang-panjang. '
        'Menghindari nada menghakimi atau memerintah dan menggunakan pendekatan kolaboratif.'
      ),
    );

    // Initialize chat session
    _chatSession = _model.startChat();
  }

  Future<void> _sendMessageToGemini(String message) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _chatSession.sendMessage(
        Content.text(message),
      );

      setState(() {
        widget.chat['messages'].add({
          'role': 'assistant', 
          'content': response.text ?? 'No response'
        });
        isLoading = false;
      });
    } catch (e) {
      print('Error sending message to Gemini: $e');
      setState(() {
        widget.chat['messages'].add({
          'role': 'assistant', 
          'content': 'Error: $e'
        });
        isLoading = false;
      });
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