import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/noti_center/cubit/noti_center_cubit.dart';
import 'package:viovid_app/features/noti_center/dtos/user_notification.dart';
import 'package:viovid_app/screens/main/noti_center/components/new_comment_noti.dart';
import 'package:viovid_app/screens/main/noti_center/components/new_film_noti.dart';

class NotiCenterScreen extends StatefulWidget {
  const NotiCenterScreen({super.key});

  @override
  State<NotiCenterScreen> createState() => _NotiCenterScreenState();
}

class _NotiCenterScreenState extends State<NotiCenterScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotiCenterCubit>().getNotiCenter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotiCenterCubit, NotiCenterState>(
      // buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        var notiCenterWidget = (switch (state) {
          NotiCenterInProgress() => _buildInProgressNotiWidget(),
          NotiCenterSuccess() => _buildNotiWidget(state.notifications),
          NotiCenterFailure() => _buildFailureNotiWidget(state.message),
        });
        return notiCenterWidget;
      },
    );
  }

  Widget _buildInProgressNotiWidget() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Gap(14),
          Text(
            'Đang tải dữ liệu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotiWidget(List<UserNotification> notifications) {
    return SafeArea(
      child: Column(
        children: [
          const Gap(10),
          const Text(
            'Trung tâm thông báo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context
                  .read<NotiCenterCubit>()
                  .getNotiCenter(), // Hàm làm mới
              child: notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'Hiện chưa có thông báo nào.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : NotificationList(
                      notifications: notifications,
                    ),
              // : ListView.builder(
              //     itemCount: notifications.length,
              // itemBuilder: (context, index) {
              //   return Stack(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             SizedBox(
              //               width: 60,
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Text(
              //                     'THG ${notifications[index].createdDateTime.toLocal().month}',
              //                     style: const TextStyle(
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                   Text(
              //                     notifications[index]
              //                         .createdDateTime
              //                         .toLocal()
              //                         .day
              //                         .toString()
              //                         .padLeft(2, '0'),
              //                     style: const TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 36,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                   notifications[index].category == 0
              //                       ? Container(
              //                           decoration: BoxDecoration(
              //                             borderRadius:
              //                                 BorderRadius.circular(4),
              //                             color: Theme.of(context)
              //                                 .primaryColor,
              //                           ),
              //                           width: double.infinity,
              //                           padding:
              //                               const EdgeInsets.symmetric(
              //                             vertical: 8,
              //                           ),
              //                           child: const Text(
              //                             'Phim mới',
              //                             textAlign: TextAlign.center,
              //                             style: TextStyle(
              //                               color: Colors.white,
              //                               fontWeight: FontWeight.bold,
              //                             ),
              //                           ),
              //                         )
              //                       : const CircleAvatar(
              //                           radius: 3,
              //                           backgroundColor: Colors.red,
              //                         ),
              //                 ],
              //               ),
              //             ),
              //             const Gap(10),
              //             Expanded(
              //               child: notifications[index].category == 0
              //                   ? NewFilmNoti(
              //                       notification: notifications[index],
              //                     )
              //                   : NewCommentNoti(
              //                       notification: notifications[index],
              //                     ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Positioned.fill(
              //         child: Material(
              //           color: Colors.transparent,
              //           child: InkWell(
              //             onTap: () {
              //               if (notifications[index].category == 0) {
              //                 context.push(
              //                   RouteName.filmDetail.replaceFirst(
              //                     ':id',
              //                     notifications[index].params['filmId'],
              //                   ),
              //                 );
              //               }

              //               // Update ReadStatus if category = 'post' && readStatus == unread
              //               // if (notifications[index].category == 1 &&
              //               //     notifications[index].readStatus == 0) {
              //               //   context
              //               //       .read<NotiCenterCubit>()
              //               //       .updateReadStatus(
              //               //         notifications[index].id,
              //               //       );
              //               // }
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   );
              //     },
              //   ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureNotiWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({
    super.key,
    required this.notifications,
  });

  final List<UserNotification> notifications;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final _reviewsListKey = GlobalKey<AnimatedListState>();

  @override
  void didUpdateWidget(covariant NotificationList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.notifications.length != oldWidget.notifications.length) {
      log('widget.notifications != oldWidget.notifications');
      log('widget.notifications.length = ${widget.notifications.length}');
      log('oldWidget.notifications.length = ${oldWidget.notifications.length}');
      _reviewsListKey.currentState?.insertItem(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    log('widget.notifications.length = ${widget.notifications.length}');
    return AnimatedList(
      key: _reviewsListKey,
      initialItemCount: widget.notifications.length,
      itemBuilder: (ctx, index, animation) => SizeTransition(
        sizeFactor: animation,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 60,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'THG ${widget.notifications[index].createdDateTime.toLocal().month}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.notifications[index].createdDateTime
                              .toLocal()
                              .day
                              .toString()
                              .padLeft(2, '0'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.notifications[index].category == 0
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).primaryColor,
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: const Text(
                                  'Phim mới',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 3,
                                backgroundColor: Colors.red,
                              ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: widget.notifications[index].category == 0
                        ? NewFilmNoti(
                            notification: widget.notifications[index],
                          )
                        : NewCommentNoti(
                            notification: widget.notifications[index],
                          ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (widget.notifications[index].category == 0) {
                      context.push(
                        RouteName.filmDetail.replaceFirst(
                          ':id',
                          widget.notifications[index].params['filmId'],
                        ),
                      );
                    }
                    // Update ReadStatus if category = 'post' && readStatus == unread
                    // if (widget.notifications[index].category == 1 &&
                    //     notifications[index].readStatus == 0) {
                    //   context
                    //       .read<NotiCenterCubit>()
                    //       .updateReadStatus(
                    //         notifications[index].id,
                    //       );
                    // }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
