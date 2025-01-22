import 'package:flutter/material.dart';
import 'package:front_end/navbar/custom_navbar.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> chats = [
    {"title": "Chat 1", "lastMessage": "", "messages": []},
    {"title": "Chat 2", "lastMessage": "", "messages": []},
  ];

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
        chats.add({"title": chatName, "lastMessage": "", "messages": []});
      });
    }
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
                    onMessageSent: (String message) {
                      setState(() {
                        chats[index]['lastMessage'] = message;
                        chats[index]['messages'].add(message);
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewChat,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomFloatingNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          // Handle navigation based on the selected index
        },
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

  @override
  void initState() {
    super.initState();
    messages = List<String>.from(widget.chat['messages']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat['title']!),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
