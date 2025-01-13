import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/main.dart';

class ChatBotApiService {
  ChatBotApiService();

  Future<dynamic> getMessagesData(String threadId) async {
    try {
      log('${ApiMethod.get} - /threads/$threadId/messages - ⏰');
      final response = await Dio().get(
        'https://api.openai.com/v1/threads/$threadId/messages',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIApiKey',
            'OpenAI-Beta': 'assistants=v2',
          },
        ),
      );

      log('${ApiMethod.get} - /threads/$threadId/messages - ✅');

      return response.data['data'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<Uint8List> getFileFromStorage(String fileId) async {
    try {
      final response = await Dio().get(
        'https://api.openai.com/v1/files/$fileId/content',
        options: Options(
          headers: {
            'Authorization': 'Bearer $openAIApiKey',
          },
          // Nếu bạn muốn tải file binary, thêm responseType này:
          responseType: ResponseType.bytes,
        ),
      );

      log("File tải về thành công! - ✅");
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> createThread() async {
    try {
      log('${ApiMethod.post} - /threads - ⏰');
      final response = await Dio().post(
        'https://api.openai.com/v1/threads',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIApiKey',
            'OpenAI-Beta': 'assistants=v2',
          },
        ),
      );

      log('threadId = ${response.data['id']}');
      log('CREATE Thread successful. - ✅');

      return response.data['id'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<bool> clearChatHistory(String threadId) async {
    try {
      log('${ApiMethod.delete} - /threads/$threadId - ⏰');
      final response = await Dio().delete(
        'https://api.openai.com/v1/threads/$threadId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIApiKey',
            'OpenAI-Beta': 'assistants=v2',
          },
        ),
      );

      log('DELETE Thread successful. - ✅');

      return response.data['deleted'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> uploadFileToStorage(XFile image) async {
    try {
      log('${ApiMethod.post} - /files - ⏰');
      final formData = FormData.fromMap({
        'purpose': 'vision',
        'file': MultipartFile.fromBytes(await image.readAsBytes(),
            filename: image.name),
      });

      final response = await Dio().post(
        'https://api.openai.com/v1/files',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $openAIApiKey',
          },
        ),
      );

      log('UPLOAD FILE successful. - ✅');
      log('file_id = ${response.data['id']}');

      return response.data['id'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
