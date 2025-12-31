import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:project_riverpod/providers/ai_provider.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ChatScreen());
  }
}

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(AiProvider);
    final chatNotifier = ref.read(AiProvider.notifier);
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Terbaru di bawah
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message =
                    chatState.messages[chatState.messages.length - 1 - index];
                return ChatBubble(message: message);
              },
            ),
          ),
          if (chatState.isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onSubmitted: (value) {
                      chatNotifier.sendMessage(value);
                      controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed:
                      chatState.isLoading
                          ? null
                          : () {
                            chatNotifier.sendMessage(controller.text);
                            controller.clear();
                          },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.teal : Colors.grey[300],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}