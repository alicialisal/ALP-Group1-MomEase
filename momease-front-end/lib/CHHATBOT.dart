import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Map<String, dynamic>> chats = [
    {"title": "Chat 1", "key": "chat1", "lastMessage": ""},
    {"title": "Chat 2", "key": "chat2", "lastMessage": ""},
  ];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    for (var chat in chats) {
      chat['lastMessage'] = prefs.getString('${chat['key']}_lastMessage') ?? '';
    }
    setState(() {});
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
        chats.add({"title": chatName, "key": chatName, "lastMessage": ""});
      });
    }
  }

  void _deleteChat(int index) async {
    final prefs = await SharedPreferences.getInstance();
    // Remove the chat data from SharedPreferences
    await prefs.remove('${chats[index]['key']}_lastMessage');
    await prefs.remove(chats[index]['key']);
    
    // Remove the chat from the chats list
    setState(() {
      chats.removeAt(index);
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
          return ListTile(
            title: Text(chats[index]['title']!),
            subtitle: Text(chats[index]['lastMessage']!.isNotEmpty
                ? chats[index]['lastMessage']!
                : 'No messages yet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomPage(
                    chat: chats[index],
                    onMessageSent: (String message) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('${chats[index]['key']}_lastMessage', message);
                      setState(() {
                        chats[index]['lastMessage'] = message;
                      });
                    },
                  ),
                )
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
  late List<String> messages;
  TextEditingController messageController = TextEditingController();
  bool showGreeting = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _checkGreetingStatus();
  }

  // Load previous messages from SharedPreferences
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      messages = prefs.getStringList(widget.chat['key']) ?? [];
    });
  }

  // Check if the greeting has been shown before
  Future<void> _checkGreetingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? hasShownGreeting = prefs.getBool('${widget.chat['key']}_greetingShown');
    
    if (hasShownGreeting == null || !hasShownGreeting) {
      setState(() {
        showGreeting = true;
      });
    } else {
      setState(() {
        showGreeting = false;
      });
    }
  }

  // Save the greeting shown flag to SharedPreferences
  Future<void> _setGreetingShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.chat['key']}_greetingShown', true);
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.chat['key'], messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat['title']),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Cloudy Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/assets/clouds_background.png'), // Add your cloud image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Greeting Screen
              if (showGreeting)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showGreeting = false;
                      });
                      _setGreetingShown();  // Mark greeting as shown
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Halo, [Nama User]",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "MomEase AI",
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Chat Messages
              if (!showGreeting)
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            messages[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Divider(height: 1, color: Colors.grey),
              if (!showGreeting)
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
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            setState(() {
                              messages.add(messageController.text);
                              widget.onMessageSent(messageController.text);
                              messageController.clear();
                            });
                            _saveMessages();
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
