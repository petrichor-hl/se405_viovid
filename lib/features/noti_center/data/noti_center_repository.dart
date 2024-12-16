import 'dart:developer';

import 'package:viovid_app/features/noti_center/data/noti_center_api_service.dart';
import 'package:viovid_app/features/noti_center/dtos/update_read_status_dto.dart';
import 'package:viovid_app/features/noti_center/dtos/user_notification.dart';
import 'package:viovid_app/features/result_type.dart';

class NotiCenterRepository {
  final NotiCenterApiService notiCenterApiService;

  NotiCenterRepository({
    required this.notiCenterApiService,
  });

  Future<Result<List<UserNotification>>> getListNoti() async {
    try {
      return Success(await notiCenterApiService.getListNoti());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> updateReadStatus(String notificationId) async {
    try {
      return Success(
        await notiCenterApiService.updateReadStatus(
          UpdateReadStatusDto(notificationId: notificationId),
        ),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
