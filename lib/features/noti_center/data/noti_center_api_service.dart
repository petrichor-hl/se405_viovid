import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/noti_center/dtos/update_read_status_dto.dart';
import 'package:viovid_app/features/noti_center/dtos/user_notification.dart';

class NotiCenterApiService {
  NotiCenterApiService(this.dio);

  final Dio dio;

  Future<List<UserNotification>> getListNoti() async {
    try {
      return await ApiClient(dio).request<void, List<UserNotification>>(
        url: '/Notification',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((noti) => UserNotification.fromJson(noti))
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<bool> updateReadStatus(UpdateReadStatusDto updateReadStatusDto) async {
    try {
      return await ApiClient(dio).request<UpdateReadStatusDto, bool>(
        url: '/Notification',
        method: ApiMethod.put,
        payload: updateReadStatusDto,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
