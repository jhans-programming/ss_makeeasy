import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:makeeasy/utils/appStyle.dart';


class ChatHistory {
  static List<Map<String, String>> messages = [];
}

class LippieChatPage extends StatefulWidget {
  @override
  _LippieChatPageState createState() => _LippieChatPageState();
}

class _LippieChatPageState extends State<LippieChatPage> {
  //final String _apiKey = Environment.apiKey;
  //List<String> chatMessages = ChatHistory.messages;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  void ask(String question) async {
    setState(() {
      ChatHistory.messages.add({'role': 'user', 'content': question});
      ChatHistory.messages.add({'role': 'assistant', 'content': 'typing'}); // placeholder
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    _controller.clear();

    //because it runs locally, we need to change the URL based on the server
    final url = Uri.parse('http://172.20.10.3:11434/api/chat');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'model': 'llama3.2',
      'messages': [
        {
          'role': 'system',
          'content': "You are Lippie, a helpful and friendly personal makeup assistant. Only answer makeup-related questions. Use casual, helpful tone and include appropriate emojis. Don't give too long answers unless asked. You may use basic Markdown like *italic*, **bold**, and lists to format your replies."
        },
        ...ChatHistory.messages
      ],
      'stream': false,
    });

    try {
      final result = await http.post(url, headers: headers, body: body);
      final decoded = jsonDecode(result.body);
      var response = decoded['message']['content'] ?? 'No response';

      // Clean up the response: trim leading/trailing whitespace
      response = response.trimLeft();

      // Capitalize first letter if it's lowercase
      if (response.isNotEmpty && response[0] == response[0].toLowerCase()) {
        response = response[0].toUpperCase() + response.substring(1);
      }

      print("Response: ${result.body}");

      setState(() {
        if(ChatHistory.messages.isNotEmpty &&
           ChatHistory.messages.last['role'] == 'assistant' &&
           ChatHistory.messages.last['content'] == 'typing') {
          ChatHistory.messages.removeLast(); // remove the 'typing' placeholder
        }

        ChatHistory.messages.add({'role': 'assistant', 'content': response});
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

    } catch (e) {
      setState(() {
        ChatHistory.messages.add({'role': 'assistant', 'content': 'Error: Unable to fetch response.'});
      });
    }
  }
  Future<void> waitForOllama() async {
    // Wait a few seconds to let Ollama finish loading
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    waitForOllama().then((_) {
      setState(() {
        if(ChatHistory.messages.isEmpty) {
          ChatHistory.messages.add({
            'role': 'assistant',
            'content': "Hi! I'm Lippie💋, your Personal Makeup AI Assistant. 💄✨ How can I assist you today?"
          });
        }
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. The app bar (top bar)
      appBar: AppBar(
        backgroundColor: appColors['primaryDark1'],
        title: Row(
          //mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: Image.asset(
                'assets/images/lippie_logo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Lippie',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Clear Chat?'),
                    content: Text('Are you sure you want to clear all messages?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // close dialog
                        },
                      ),
                      TextButton(
                        child: Text('Clear'),
                        onPressed: () {
                          setState(() {
                            ChatHistory.messages.clear();
                          });
                          Navigator.of(context).pop(); // close dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      // 2. The body (main content: scrollable area + text input)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: ChatHistory.messages.length,
                itemBuilder: (context, index) {
                  final message = ChatHistory.messages[index];
                  final isUser = message['role'] == 'user';

                  return Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUser ? appColors['primaryLight1'] : Colors.grey[100],
                            border: Border.all(
                              color: Colors.grey, //isUser ? appColors['primaryDark1'] : Colors.grey[300]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: message['content'] == 'typing' && !isUser
                            ? TypingDots() // Custom widget
                            : MarkdownBody(
                                data: message['content'] ?? '',
                                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                  p: TextStyle(fontSize: 16),
                                  blockSpacing: 8,
                                ),
                              ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 35),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: ask,
                      decoration: const InputDecoration(
                        hintText: 'Ask Lippie something...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send,
                      color: appColors['primaryDark1'],),
                    onPressed: () {
                      if(_controller.text.trim().isEmpty) {
                        _showSnackBar(context, 'Please enter a question');
                        return;
                      }
                      ask(_controller.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}



// TypingDots widget to show typing animation
// This widget will show three dots that animate to indicate typing

class TypingDots extends StatefulWidget {
  @override
  _TypingDotsState createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dots;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _dots = StepTween(begin: 1, end: 3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dots,
      builder: (context, child) {
        final dots = '.' * _dots.value;
        return Text(
          'Lippie is typing$dots',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
