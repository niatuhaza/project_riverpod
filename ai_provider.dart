import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiNotifier extends StateNotifier<ChatState> {
  AiNotifier() : super(ChatState(messages: [])) {
    _initModel();
  }

  late final GenerativeModel _model;

  void _initModel() {
    final String? apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      state = state.copyWith(
        messages: [
          ChatMessage(text: "Error: API Key tidak ditemukan", isUser: false),
        ],
      );
      return;
    }

    _model = GenerativeModel(model: 'gemini-3-flash-preview', apiKey: apiKey);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      final content = [Content.text(text)];
      final response = await _model.generateContent(content);

      final aiMessage = ChatMessage(
        text: response.text ?? 'Maaf, saya tidak bisa menjawab itu.',
        isUser: false,
      );
      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(text: 'Error: $e', isUser: false),
        ],
        isLoading: false,
      );
    }
  }
}

final AiProvider = StateNotifierProvider<AiNotifier, ChatState>((ref) {
  return AiNotifier();
});

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState({required this.messages, this.isLoading = false});

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}