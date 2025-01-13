import 'dart:developer';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:viovid_app/features/chat_bot/data/chat_bot_api_service.dart';
import 'package:viovid_app/features/chat_bot/dtos/message.dart';
import 'package:viovid_app/features/result_type.dart';

class ChatBotRepository {
  final ChatBotApiService chatBotApiService;

  ChatBotRepository({
    required this.chatBotApiService,
  });

  Future<Result<List<Message>>> getMessages(String threadId) async {
    try {
      final messagesData = await chatBotApiService.getMessagesData(threadId);

      Iterable<dynamic> listItem = (messagesData as List).reversed;
      final List<Message> messages = [];

      for (final messageObj in listItem) {
        List<dynamic> contents = messageObj['content'];
        bool isUserMessage = messageObj['role'] == 'user';
        for (final content in contents) {
          if (content['type'] == 'text') {
            messages.add(
              Message(
                content: content['text']['value'],
                isUserMessage: isUserMessage,
                type: MessageType.text,
              ),
            );
          } else if (content['type'] == 'image_file') {
            final fileId = content['image_file']['file_id'];
            Uint8List? imageBytes =
                await chatBotApiService.getFileFromStorage(fileId);
            messages.add(
              Message(
                content: imageBytes,
                isUserMessage: isUserMessage,
                type: MessageType.image,
              ),
            );
          }
        }
      }
      return Success(messages);
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> createThread() async {
    try {
      return Success(await chatBotApiService.createThread());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> clearChatHistory(String threadId) async {
    try {
      return Success(await chatBotApiService.clearChatHistory(threadId));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> uploadFileToStorage(XFile image) async {
    try {
      return Success(await chatBotApiService.uploadFileToStorage(image));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<Uint8List>> getFileFromStorage(String fileId) async {
    try {
      return Success(await chatBotApiService.getFileFromStorage(fileId));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
