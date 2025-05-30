import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:frequency_handler/pages/audio.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Chat with our friendly Helper'),
        centerTitle: true,
        elevation: 0,
      ),
      body: LlmChatView(
        provider: GeminiProvider(
          model: GenerativeModel(
            model: 'gemini-2.0-flash',
            apiKey: data["API_KEY"],
          ),
        ),
      ),
    );
  }
}
