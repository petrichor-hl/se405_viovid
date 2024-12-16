part of 'noti_center_cubit.dart';

sealed class NotiCenterState {}

class NotiCenterInProgress extends NotiCenterState {}

class NotiCenterSuccess extends NotiCenterState {
  final List<UserNotification> notifications;

  NotiCenterSuccess(this.notifications);
}

class NotiCenterFailure extends NotiCenterState {
  final String message;

  NotiCenterFailure(this.message);
}
