import 'package:viovid_app/features/post/post_api_service.dart';

class PostRepository {
  final PostApiService apiService;

  PostRepository(this.apiService);

  Future<Post> createPost(Map<String, dynamic> PostData) async {
    return await apiService.createPost(PostData);
  }

  Future<PagingData<Post>> getPosts(int currentPostIndex) async {
    return await apiService.getPosts(
      pageIndex: currentPostIndex,
      pageSize: 15,
      searchText: '',
    );
  }

  Future<PagingData<Post>> getPostsFromChannel(
      int currentPostIndex, String channelId) async {
    return await apiService.getPostsByChannel(
        pageIndex: currentPostIndex, pageSize: 15, channelId: channelId);
  }
}
