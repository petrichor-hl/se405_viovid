import 'package:viovid_app/features/post/post_api_service.dart';

class PostRepository {
  final PostApiService apiService;

  PostRepository(this.apiService);

  Future<void> createPost(Map<String, dynamic> PostData) async {
    await apiService.createPost(PostData);
  }

  Future<Map<String, dynamic>> getPosts() async {
    return await apiService.getPosts(
      pageIndex: 0,
      pageSize: 15,
      searchText: '',
    );
  }
}
