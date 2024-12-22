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
      pageIndex: currentPostIndex,
      pageSize: 15,
      channelId: channelId,
    );
  }

  Future<Post> likePost(String postId) async {
    return await apiService.likePost(postId);
  }

  Future<Post> unlikePost(String postId) async {
    return await apiService.unlikePost(postId);
  }

  Future<PostComment> addComment(Map<String, dynamic> postData) async {
    return await apiService.addComment(postData);
  }

  Future<PagingData<PostComment>> listComments(
      int currentPostIndex, String postId) async {
    return await apiService.getCommentsByPost(
      pageIndex: currentPostIndex,
      pageSize: 15,
      postId: postId,
    );
  }
}
