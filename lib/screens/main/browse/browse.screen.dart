import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/cubits/app_bar_cubit.dart';
import 'package:viovid_app/features/topic/cubit/topic_list_cubit.dart';
import 'package:viovid_app/features/topic/dtos/topic.dart';
import 'package:viovid_app/screens/main/browse/components/content_header.dart';
import 'package:viovid_app/screens/main/browse/components/content_list.dart';
import 'package:viovid_app/screens/main/browse/components/custom_app_bar.dart';
import 'package:viovid_app/screens/main/browse/components/genre_list_drawer.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late final Size _screenSize = MediaQuery.sizeOf(context);

  late final ScrollController _scrollController = ScrollController()
    ..addListener(() {
      context.read<AppBarCubit>().setOffset(_scrollController.offset);
    });

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<dynamic> genres;

  @override
  void initState() {
    super.initState();
    context.read<TopicListCubit>().getTopicList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size(_screenSize.width, 70),
        child: BlocBuilder<AppBarCubit, double>(
          builder: (ctx, scrollOffset) {
            return CustomAppBar(
              scrollOffset: scrollOffset,
              scaffoldKey: _scaffoldKey,
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      // Thay đổi màu cho phần còn lại của màn hình khi Drawer đang mở
      // drawerScrimColor: Colors.transparent,
      endDrawer: const GenreListDrawer(),
      // Tùy chọn: Khoảng cách bên phải để mở drawer khi vuốt từ lề
      drawerEdgeDragWidth: 20,
      body: BlocBuilder<TopicListCubit, TopicListState>(
        builder: (ctx, state) {
          var browseWidget = (switch (state) {
            TopicListInProgress() => _buildInProgressBrowseWidget(),
            TopicListSuccess() => _buildBrowseWidget(state.topicList),
            TopicListFailure() => _buildFailureBrowseWidget(state.message),
          });

          return browseWidget;
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFA000),
        onPressed: () => context.go('/bottom-nav/chat-bot'),
        child: const Icon(
          Icons.smart_toy_rounded,
        ),
      ),
    );
  }

  Widget _buildInProgressBrowseWidget() {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SkeletonLoading(height: 450),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SkeletonLoading(
                        width: 240,
                        height: 54,
                      ),
                      Gap(4),
                      SkeletonLoading(
                        width: 200,
                        height: 20,
                      ),
                      Gap(14),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Gap(20),
                          Expanded(
                            child: SkeletonLoading(
                              height: 48,
                            ),
                          ),
                          Gap(20),
                          Expanded(
                            child: SkeletonLoading(
                              height: 48,
                            ),
                          ),
                          Gap(20),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, top: 16, bottom: 6),
              child: SkeletonLoading(
                width: 120,
                height: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: SkeletonLoading(
                height: 180,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, top: 16, bottom: 6),
              child: SkeletonLoading(
                width: 120,
                height: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: SkeletonLoading(
                height: 180,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseWidget(List<Topic> topicList) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverToBoxAdapter(
          child: ContentHeader(
            id: 'placeholder',
            posterPath: 'placeholder',
          ),
        ),
        ...topicList.map(
          (topic) => SliverToBoxAdapter(
            child: ContentList(
              key: PageStorageKey(topic),
              topic: topic,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 20))
      ],
    );
  }

  Widget _buildFailureBrowseWidget(String errorMessage) {
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
