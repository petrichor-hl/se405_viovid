import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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
      // endDrawer: buildEndDrawer(),
      // Tùy chọn: Khoảng cách bên phải để mở drawer khi vuốt từ lề
      drawerEdgeDragWidth: 20,
      body: BlocBuilder<TopicListCubit, TopicListState>(
        builder: (ctx, state) {
          var browseScreen = (switch (state) {
            TopicListInProgress() => _buildInProgressBrowseScreen(),
            TopicListSuccess() => _buildBrowseScreen(state.topicList),
            TopicListFailure() => _buildFailureBrowseScreen(state.message),
          });
          return browseScreen;
        },
      ),
    );
  }

  Widget _buildInProgressBrowseScreen() {
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

  Widget _buildBrowseScreen(List<Topic> topicList) {
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

  Widget _buildFailureBrowseScreen(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
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
