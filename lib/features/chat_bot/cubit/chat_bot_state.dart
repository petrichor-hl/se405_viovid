import 'package:viovid_app/features/chat_bot/dtos/message.dart';

class ChatBotState {
  final List<Message> messages;
  final bool isLoading;
  // final bool isProcessing;
  // final bool isClearingThread;
  final String errorMessage;

  ChatBotState({
    this.messages = const [],
    this.isLoading = false,
    // this.isProcessing = false,
    // this.isClearingThread = false,
    this.errorMessage = "",
  });

  ChatBotState copyWith({
    List<Message>? messages,
    bool? isLoading,
    // bool? isProcessing,
    // bool? isClearingThread,
    String? errorMessage,
  }) {
    return ChatBotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      // isProcessing: isProcessing ?? this.isProcessing,
      // isClearingThread: isClearingThread ?? this.isClearingThread,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
