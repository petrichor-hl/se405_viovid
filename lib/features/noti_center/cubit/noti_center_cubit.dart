import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/noti_center/data/noti_center_repository.dart';
import 'package:viovid_app/features/noti_center/dtos/user_notification.dart';
import 'package:viovid_app/features/result_type.dart';

part 'noti_center_state.dart';

// Cubit + Repository
class NotiCenterCubit extends Cubit<NotiCenterState> {
  final NotiCenterRepository _notiCenterRepository;

  NotiCenterCubit(this._notiCenterRepository) : super(NotiCenterInProgress());

  Future<void> getNotiCenter() async {
    final result = await _notiCenterRepository.getListNoti();

    return (switch (result) {
      Success() => emit(NotiCenterSuccess(result.data)),
      Failure() => emit(NotiCenterFailure(result.message)),
    });
  }

  Future<void> addNotiToCenter(UserNotification newNoti) async {
    log('addNotiToCenter');
    if (state is NotiCenterSuccess) {
      log('NotiCenterSuccess');
      emit(
        NotiCenterSuccess(
          [newNoti, ...(state as NotiCenterSuccess).notifications],
        ),
      );
    }
  }

  // Future<void> updateReadStatus(String notificationId) async {
  //   if (state is NotiCenterSuccess) {
  //     final updatedNotifications =
  //         (state as NotiCenterSuccess).notifications.map((notification) {
  //       if (notification.id == notificationId) {
  //         return UserNotification(
  //           id: notification.id,
  //           applicationUserId: notification.applicationUserId,
  //           category: notification.category,
  //           createdDateTime: notification.createdDateTime,
  //           readStatus: 1, // Cập nhật readStatus thành 1 => read
  //           title: notification.title,
  //           body: notification.body,
  //           params: notification.params,
  //         );
  //       }
  //       return notification;
  //     }).toList();

  //     // Update Locally
  //     emit(NotiCenterSuccess(updatedNotifications));
  //     // Update to Server
  //     await _notiCenterRepository.updateReadStatus(notificationId);
  //   }
  // }
}
