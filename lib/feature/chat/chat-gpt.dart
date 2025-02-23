import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatCompletion {
  final List<Choice> choices;

  ChatCompletion({required this.choices});

  factory ChatCompletion.fromJson(Map<String, dynamic> json) {
    return ChatCompletion(
      choices:
          (json['choices'] as List).map((i) => Choice.fromJson(i)).toList(),
    );
  }
}

class Choice {
  final Message message;

  Choice({required this.message});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      message: Message.fromJson(json['message']),
    );
  }
}

class Message {
  final String content;

  Message({required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(content: json['content']);
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController controller;
  String responseText = '';
  bool isRequestInProgress = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Chat App')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ResponseWidget(responseText: responseText),
            TextInputWidget(controller: controller, onSend: completion)
          ],
        ),
      ),
    );
  }

  Future<void> completion() async {
    const String endpoint = 'https://api.openai.com/v1/chat/completions';
    int retryCount = 0;
    int maxRetries = 5;
    int delayMs = 1000; // Start with 1 second delay

    // Show loading text
    setState(() {
      responseText = "Loading...";
    });

    while (retryCount < maxRetries) {
      try {
        final response = await http.post(
          Uri.parse(endpoint),
          headers: {
            'Content-Type': "application/json",
            "Authorization": "Bearer \${dotenv.env['token']}",
          },
          body: json.encode({
            "model": "gpt-4o",
            "messages": [
              {"role": "system", "content": "You are a helpful assistant."},
              {"role": "user", "content": controller.text}
            ],
            "max_tokens": 100,
            "temperature": 0.7,
            "top_p": 1.0
          }),
        );

        print("REQUEST STATUS CODE: ${response.statusCode}");

        if (response.statusCode == 200) {
          final chatCompletion =
              ChatCompletion.fromJson(json.decode(response.body));
          setState(() {
            responseText = chatCompletion.choices[0].message.content;
            controller.clear();
          });
          return; // Success, exit function
        } else if (response.statusCode == 429) {
          print("Rate limit exceeded. Retrying in $delayMs ms...");
          await Future.delayed(Duration(milliseconds: delayMs));
          delayMs *= 2; // Exponential backoff
          retryCount++;
        } else {
          setState(() {
            responseText =
                "Error: ${response.statusCode} - ${response.reasonPhrase}";
          });
          return;
        }
      } catch (e) {
        setState(() {
          responseText = "Failed to connect: $e";
        });
        return;
      }
    }

    // setState(() {
    //   responseText = "Request failed after multiple retries.";
    // });
  }
}

class TextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function onSend;

  const TextInputWidget({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: Theme.of(context).textTheme.displayMedium),
          ),
        ),
        IconButton(
          onPressed: () => onSend(),
          icon: Icon(Icons.send),
        ),
      ],
    );
  }
}

class ResponseWidget extends StatelessWidget {
  final String responseText;
  const ResponseWidget({required this.responseText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            responseText,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
