import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/cubits/app_bar_cubit.dart';
import 'package:viovid_app/features/topic/cubit/topic_list_cubit.dart';
import 'package:viovid_app/features/topic/dtos/topic.dart';
import 'package:viovid_app/screens/main/browse/components/content_header.dart';
import 'package:viovid_app/screens/main/browse/components/content_list.dart';
import 'package:viovid_app/screens/main/browse/components/custom_app_bar.dart';

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
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        context.read<TopicListCubit>().getTopicList();
      }
    });
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
      // endDrawer: buildEndDrawer(),
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
  // Widget buildEndDrawer() => Stack(
  //       children: [
  //         const SizedBox.expand(),
  //         Positioned(
  //           right: 0,
  //           top: 0,
  //           bottom: 0,
  //           child: Drawer(
  //             width: 258,
  //             backgroundColor: Colors.black,
  //             elevation: 0,
  //             child: FutureBuilder(
  //               future: _futureGenres,
  //               builder: (ctx, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return const Center(
  //                     child: CircularProgressIndicator(),
  //                   );
  //                 }

  //                 if (snapshot.hasError) {
  //                   return const Center(
  //                     child: Text(
  //                       'Truy xuất danh sách Thể loại thất bại',
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   );
  //                 }

  //                 return SafeArea(
  //                   child: ListView(
  //                     children: List.generate(
  //                       genres.length,
  //                       (index) => ListTile(
  //                         onTap: () {
  //                           final genreId = genres[index]['id'];
  //                           context
  //                               .read<RouteStackCubit>()
  //                               .push('/films_by_genre@$genreId');
  //                           context.read<RouteStackCubit>().printRouteStack();
  //                           Navigator.of(context).push(
  //                             PageTransition(
  //                               child: FilmsByGenre(
  //                                 genreId: genreId,
  //                                 genreName: genres[index]['name'],
  //                               ),
  //                               type: PageTransitionType.rightToLeft,
  //                               settings: RouteSettings(
  //                                   name: '/films_by_genre@$genreId'),
  //                             ),
  //                           );
  //                         },
  //                         title: Text(
  //                           genres[index]['name'],
  //                           style: const TextStyle(
  //                             color: Colors.white,
  //                           ),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           right: 228,
  //           top: 0,
  //           bottom: 0,
  //           child: Center(
  //             child: IconButton.filled(
  //               onPressed: () => _scaffoldKey.currentState!.closeEndDrawer(),
  //               icon: const Icon(
  //                 Icons.arrow_forward_rounded,
  //                 size: 32,
  //               ),
  //               style: IconButton.styleFrom(
  //                   backgroundColor: Colors.white,
  //                   foregroundColor: Colors.black,
  //                   padding: const EdgeInsets.all(14)),
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
}
