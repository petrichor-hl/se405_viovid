import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viovid_app/features/chat_bot/cubit/chat_bot_state.dart';
import 'package:viovid_app/features/chat_bot/data/chat_bot_repository.dart';
import 'package:viovid_app/features/chat_bot/dtos/message.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/main.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  final ChatBotRepository chatBotRepository;

  ChatBotCubit(this.chatBotRepository) : super(ChatBotState());

  Future<void> getMessages(String threadId) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );
    final result = await chatBotRepository.getMessages(threadId);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            messages: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<String?> createThread() async {
    final result = await chatBotRepository.createThread();
    switch (result) {
      case Success():
        return result.data;
      case Failure():
        emit(
          state.copyWith(
            errorMessage: (result as Failure).message,
          ),
        );
        return null;
    }
  }

  Future<bool> clearChatHistory(String threadId) async {
    emit(
      state.copyWith(
        errorMessage: null,
      ),
    );
    final result = await chatBotRepository.clearChatHistory(threadId);
    switch (result) {
      case Success():
        emit(
          state.copyWith(
            messages: [],
          ),
        );
        return result.data;
      case Failure():
        emit(
          state.copyWith(
            errorMessage: (result as Failure).message,
          ),
        );
        return false;
    }
  }

  Future<String?> uploadFileToStorage(XFile image) async {
    final result = await chatBotRepository.uploadFileToStorage(image);
    switch (result) {
      case Success():
        return result.data;
      case Failure():
        emit(
          state.copyWith(
            errorMessage: (result as Failure).message,
          ),
        );
        return null;
    }
  }

  Future<Uint8List?> getFileFromStorage(String fileId) async {
    final result = await chatBotRepository.getFileFromStorage(fileId);
    switch (result) {
      case Success():
        return result.data;
      case Failure():
        emit(
          state.copyWith(
            errorMessage: (result as Failure).message,
          ),
        );
        return null;
    }
  }

  void updateMessages(List<Message> list) {
    emit(
      state.copyWith(
        messages: list,
      ),
    );
  }

  Future<String?> addMessageToThread(
    String threadId,
    String messageText,
    String? fileId,
  ) async {
    final dio = Dio();
    // Tạo formData
    try {
      final response = await dio.post(
        'https://api.openai.com/v1/threads/$threadId/messages',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIApiKey',
            'OpenAI-Beta': 'assistants=v2',
          },
        ),
        data: {
          "role": "user",
          "content": [
            if (fileId != null)
              {
                "type": "image_file",
                "image_file": {
                  "file_id": fileId,
                },
              },
            {
              "type": "text",
              "text": messageText,
            },
          ],
        },
      );

      log("ADD Message to Thread successful. ✅");
      return response.data['id'];
    } catch (e) {
      log('ERROR: ADD Message to Thread failed. ❌\n$e');
      return null;
    }
  }

  Future<String?> createRun(
    String threadId,
  ) async {
    final dio = Dio();
    Completer<void> completer = Completer();
    // Tạo formData
    try {
      final response = await dio.post(
        'https://api.openai.com/v1/threads/$threadId/runs',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIApiKey',
            'OpenAI-Beta': 'assistants=v2',
          },
        ),
        data: {
          "assistant_id": viovidAssistantId,
        },
      );

      final runId = response.data['id'];
      log("CREATE Run successful - runId $runId ✅");
      log("Polling Run Object ... ⏰");

      Timer.periodic(const Duration(milliseconds: 500), (timer) {
        checkRunStatus(threadId, runId).then((status) async {
          if (terminalStates.contains(status)) {
            log('Dừng theo dõi Run status');
            timer.cancel(); // Dừng vòng lặp

            if (!completer.isCompleted) {
              completer.complete();
            }
          }
        });
      });

      await completer.future;
      log("Done. ✅");
      return response.data['id'];
    } catch (e) {
      log('ERROR: CREATE Run failed. ❌\n$e');
      return null;
    }
  }

  Future<String> checkRunStatus(String threadId, String runId) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'https://api.openai.com/v1/threads/$threadId/runs/$runId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIApiKey',
            'OpenAI-Beta': 'assistants=v2',
          },
        ),
      );
      // log("GET Run successful. ✅");
      log("runId ${response.data['id']} - status: ${response.data['status']}");
      return response.data['status'];
    } catch (e) {
      log('Error checking run status: $e');
      return 'failed';
    }
  }

  Future<Message?> getLastThreadMessages(String threadId) async {
    final dio = Dio();
    // Tạo formData
    try {
      final response = await dio.get(
        'https://api.openai.com/v1/threads/$threadId/messages',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIApiKey',
            'OpenAI-Beta': 'assistants=v2',
          },
        ),
      );

      // log('Response ${response.data}');
      final latestMessageObj = (response.data['data'] as List).first;

      log("GET LAST Thread Messages successful. ✅");
      return Message(
        content: latestMessageObj['content'][0]['text']['value'],
        isUserMessage: false,
        type: MessageType.text,
      );
    } catch (e) {
      log('ERROR: GET LAST Thread Messages failed. ❌\n$e');
      return null;
    }
  }
}

const viovidAssistantId = 'asst_XYzSdgaUiGMFv89iM41Bjm5H';
const terminalStates = [
  'expired',
  'completed',
  'failed',
  'incomplete',
  'cancelled'
];
