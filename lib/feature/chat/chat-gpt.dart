// // apikey =
// // endpoint = https://api.openai.com/v1/chat/completions

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:thuram_app/feature/chat/model.dart';
// import 'package:http/http.dart' as http;

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late TextEditingController controller;
//   String responseText = '';
//   late ChatCompletion _responModel;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text('GPT-3 Chat'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             ReponseBld(
//               reponseText: responseText,
//             ),
//             TextFormBld(controller: controller, btn: completion)
//           ],
//         ),
//       ),
//     );
//   }

//   completion() async {
//     setState(() {
//       responseText = "Loading...";
//     });
//     final String endpoint = 'https://api.openai.com/v1/chat/completions';

//     final response = await http.post(Uri.parse(endpoint),
//         headers: {
//           'content-type': "application/json",
//           "Authorization": "Bearer ${dotenv.env['token']}"
//         },
//         body: json.encode({
//           "model": "text-davinci-003",
//           "prompt": controller.text,
//           "max_token": 250,
//           "temparature": 0,
//           "top_p": 1
//         }));

//     setState(() {
//       _responModel = ChatCompletion.fromJson(json.decode(response.body));
//       responseText = _responModel.choices[0].message.content;
//       debugPrint(responseText);
//     });
//   }
// }

// class TextFormBld extends StatelessWidget {
//   const TextFormBld({super.key, required this.btn, required this.controller});
//   final TextEditingController controller;
//   final Function btn;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       child: Row(
//         children: [
//           Flexible(
//               child: TextFormField(
//             cursorColor: Colors.white,
//             controller: controller,
//             autofocus: true,
//             style: TextStyle(color: Colors.white, fontSize: 30),
//             decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Color(0xff444653),
//                   ),
//                   borderRadius: BorderRadius.circular(5.5)),
//               enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xff444653))),
//               fillColor: Color(0xff444653),
//               hintText: 'Ask any thing',
//               filled: true,
//             ),
//           )),
//           Container(
//             color: Color(0xff19bc99),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: IconButton(
//                     onPressed: () => btn(),
//                     icon: const Icon(
//                       Icons.send,
//                       color: Colors.white,
//                     )),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class ReponseBld extends StatelessWidget {
//   const ReponseBld({super.key, required this.reponseText});
//   final String reponseText;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 1.33,
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Text(
//               reponseText,
//               textAlign: TextAlign.start,
//               style: TextStyle(fontSize: 25, color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatCompletion {
  final String id;
  final String object;
  final int created;
  final String model;
  final String systemFingerprint;
  final List<Choice> choices;
  final Usage usage;

  ChatCompletion({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.systemFingerprint,
    required this.choices,
    required this.usage,
  });

  factory ChatCompletion.fromJson(Map<String, dynamic> json) {
    return ChatCompletion(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      systemFingerprint: json['system_fingerprint'],
      choices:
          (json['choices'] as List).map((i) => Choice.fromJson(i)).toList(),
      usage: Usage.fromJson(json['usage']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'object': object,
        'created': created,
        'model': model,
        'system_fingerprint': systemFingerprint,
        'choices': choices.map((i) => i.toJson()).toList(),
        'usage': usage.toJson(),
      };
}

class Choice {
  final int index;
  final Message message;
  final dynamic logprobs;
  final String finishReason;

  Choice({
    required this.index,
    required this.message,
    this.logprobs,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'],
      message: Message.fromJson(json['message']),
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
    );
  }

  Map<String, dynamic> toJson() => {
        'index': index,
        'message': message.toJson(),
        'logprobs': logprobs,
        'finish_reason': finishReason,
      };
}

class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final CompletionTokensDetails completionTokensDetails;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    required this.completionTokensDetails,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
      completionTokensDetails:
          CompletionTokensDetails.fromJson(json['completion_tokens_details']),
    );
  }

  Map<String, dynamic> toJson() => {
        'prompt_tokens': promptTokens,
        'completion_tokens': completionTokens,
        'total_tokens': totalTokens,
        'completion_tokens_details': completionTokensDetails.toJson(),
      };
}

class CompletionTokensDetails {
  final int reasoningTokens;
  final int acceptedPredictionTokens;
  final int rejectedPredictionTokens;

  CompletionTokensDetails({
    required this.reasoningTokens,
    required this.acceptedPredictionTokens,
    required this.rejectedPredictionTokens,
  });

  factory CompletionTokensDetails.fromJson(Map<String, dynamic> json) {
    return CompletionTokensDetails(
      reasoningTokens: json['reasoning_tokens'],
      acceptedPredictionTokens: json['accepted_prediction_tokens'],
      rejectedPredictionTokens: json['rejected_prediction_tokens'],
    );
  }

  Map<String, dynamic> toJson() => {
        'reasoning_tokens': reasoningTokens,
        'accepted_prediction_tokens': acceptedPredictionTokens,
        'rejected_prediction_tokens': rejectedPredictionTokens,
      };
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController controller;
  String responseText = '';

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
      appBar: AppBar(
        title: Text('GPT-3 Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ReponseBld(reponseText: responseText),
            TextFormBld(controller: controller, btn: completion)
          ],
        ),
      ),
    );
  }

  completion() async {
    print("REQUEST");
    setState(() {
      responseText = "Loading...";
    });

    final String endpoint = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': "application/json",
          "Authorization": "Bearer ${dotenv.env['token']}"
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
      print("REQUEST STATUS CODE ${response.statusCode}");
      if (response.statusCode == 200) {
        final chatCompletion =
            ChatCompletion.fromJson(json.decode(response.body));
        setState(() {
          responseText = chatCompletion.choices[0].message.content;
          controller.clear(); // Clear text after submission
        });
      } else {
        setState(() {
          responseText =
              "Error: ${response.statusCode} - ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        responseText = "Failed to connect: $e";
      });
    }
  }
}

class TextFormBld extends StatelessWidget {
  const TextFormBld({super.key, required this.btn, required this.controller});
  final TextEditingController controller;
  final Function btn;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Row(
        children: [
          Flexible(
              child: TextFormField(
            cursorColor: Colors.white,
            controller: controller,
            autofocus: false,
            style: TextStyle(color: Colors.white, fontSize: 30),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff444653),
                  ),
                  borderRadius: BorderRadius.circular(5.5)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff444653))),
              fillColor: Color(0xff444653),
              hintText: 'Ask anything',
              filled: true,
            ),
          )),
          Container(
            color: Color(0xff19bc99),
            child: IconButton(
                onPressed: () => btn(),
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}

class ReponseBld extends StatelessWidget {
  const ReponseBld({super.key, required this.reponseText});
  final String reponseText;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.33,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Text(
              reponseText,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
