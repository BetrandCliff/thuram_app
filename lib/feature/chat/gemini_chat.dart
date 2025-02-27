// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:thuram_app/core/constants/asset-paths.dart';
// import 'package:thuram_app/core/constants/values.dart';

// class GeminiChat extends StatefulWidget {
//   const GeminiChat({super.key});

//   @override
//   State<GeminiChat> createState() => _GeminiChatState();
// }

// class _GeminiChatState extends State<GeminiChat> {
//   final Gemini gemini = Gemini.instance;
//   List<ChatMessage> messages = [];
//   ChatUser currentUser = ChatUser(
//       id: FirebaseAuth.instance.currentUser?.uid ?? "0",
//       firstName: FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous");
//   ChatUser geminiUser =
//       ChatUser(id: "1", firstName: "Gemini", profileImage: AppImages.equation);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chat with Gemini", style: Theme.of(context).textTheme.displayMedium,),),
//       body: buildChat());
//   }

//   Widget buildChat() {
//     return DashChat(
//         currentUser: currentUser, onSend: _sendMessage, messages: messages);
//   }

//   void _sendMessage(ChatMessage message) {
//     setState(() {
//       messages = [message, ...messages];
//       final question = message.text;
//       gemini.streamGenerateContent(question).listen((event) {
//         ChatMessage? lastMessage = messages.firstOrNull;

//         if (lastMessage != null && lastMessage.user == geminiUser) {
//           final lastMessage = messages.removeAt(0);
//           String response = event.content?.parts?.fold(
//                   '', (previous, current) => "$previous ${current}") ??
//               "";
//           lastMessage.text = response;
//           setState(() {
//             messages = [lastMessage, ...messages];
//           });
//         } else {
//           String response = event.content?.parts?.fold(
//                   '', (previous, current) => "$previous${current.text}") ??
//               "";
//           ChatMessage message = ChatMessage(
//               user: geminiUser, createdAt: DateTime.now(), text: response);

//           setState(() {
//             messages = [message, ...messages];
//           });
//         }
//       });
//     });
//     try {} catch (e) {}
//   }
// }



// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:thuram_app/core/constants/asset-paths.dart';

// class GeminiChat extends StatefulWidget {
//   const GeminiChat({super.key});

//   @override
//   State<GeminiChat> createState() => _GeminiChatState();
// }

// class _GeminiChatState extends State<GeminiChat> {
//   final Gemini gemini = Gemini.instance;
//   List<ChatMessage> messages = [];
//   ChatUser currentUser = ChatUser(
//     id: FirebaseAuth.instance.currentUser?.uid ?? "0",
//     firstName: FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
//   );
//   ChatUser geminiUser = ChatUser(
//     id: "1",
//     firstName: "Gemini",
//     profileImage: AppImages.equation,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chat with Gemini", style: Theme.of(context).textTheme.displayMedium),
//       ),
//       body: buildChat(),
//     );
//   }

//   Widget buildChat() {
//     return DashChat(
//       currentUser: currentUser,
//       onSend: _sendMessage,
//       messages: messages,
//     );
//   }

//   void _sendMessage(ChatMessage message) {
//     setState(() {
//       messages.insert(0, message); // Add user message
//     });

//     final question = message.text;

//     gemini.streamGenerateContent(question).listen((event) {
//       // Extract response safely
//       String response = event.content?.parts
//               ?.map((part) => part.toString()) // Convert to string safely
//               .join(" ") ?? "I'm not sure how to respond.";

//       ChatMessage botMessage = ChatMessage(
//         user: geminiUser,
//         createdAt: DateTime.now(),
//         text: response,
//       );

//       setState(() {
//         messages.insert(0, botMessage); // Add Gemini's response
//       });
//     }, onError: (error) {
//       setState(() {
//         messages.insert(
//           0,
//           ChatMessage(
//             user: geminiUser,
//             createdAt: DateTime.now(),
//             text: "Error: Unable to generate a response.",
//           ),
//         );
//       });
//     });
//   }
// }


import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:flutter/services.dart'; // Import for Clipboard

class GeminiChat extends StatefulWidget {
  const GeminiChat({super.key});

  @override
  State<GeminiChat> createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(
    id: FirebaseAuth.instance.currentUser?.uid ?? "0",
    firstName: FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
  );
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: AppImages.equation,
  );
  bool _isGeneratingResponse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Gemini", style: Theme.of(context).textTheme.displayMedium),
      ),
      body: buildChat(),
    );
  }

  Widget buildChat() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      inputOptions: InputOptions(
        sendButtonBuilder: (onSend) {
          return IconButton(
            onPressed: _isGeneratingResponse ? null : onSend,
            icon: Icon(Icons.send),
          );
        },
      ),
      messageOptions: MessageOptions(
        onPressMessage: (ChatMessage message) {
          _copyMessageToClipboard(message.text);
        },
      ),
    );
  }
void _sendMessage(ChatMessage message) {
  setState(() {
    messages.insert(0, message);
    _isGeneratingResponse = true;
  });

  final question = message.text;

  gemini.streamGenerateContent(question).listen((event) {
    String response = event.content?.parts
            ?.map((part) {
              if (part is TextPart) {
                return part.text;
              } else {
                // If it's not a TextPart, attempt to get the string representation.
                // This will handle other Part types that have a meaningful toString().
                return part.toString();
              }
            })
            .join(" ") ??
        "I'm not sure how to respond.";

    ChatMessage botMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: response,
    );

    setState(() {
      messages.insert(0, botMessage);
      _isGeneratingResponse = false;
    });
  }, onError: (error) {
    setState(() {
      messages.insert(
        0,
        ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: "Error: Unable to generate a response.",
        ),
      );
      _isGeneratingResponse = false;
    });
  });
}

  void _copyMessageToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message copied to clipboard')),
    );
  }
}