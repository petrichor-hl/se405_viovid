import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/post/data/post_repository.dart';
import 'package:viovid_app/features/post/post_api_service.dart';

class PostCubit extends Cubit<void> {
  final PostRepository repository;

  PostCubit(this.repository) : super(null);

  Future<Post> createPost(Map<String, dynamic> PostData) async {
    try {
      return await repository.createPost(PostData);
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }

  Future<List<Post>> getListPost(int currentPostIndex) async {
    try {
      final response = await repository.getPosts(currentPostIndex);
      emit(null); // Emit success state if needed
      return response.items;
    } catch (e) {
      emit(null); // Emit failure state if needed
      return [];
    }
  }

  Future<List<Post>> getListPostFromChannel(
      int currentPostIndex, String channelId) async {
    try {
      final response =
          await repository.getPostsFromChannel(currentPostIndex, channelId);
      emit(null); // Emit success state if needed
      return response.items;
    } catch (e) {
      emit(null); // Emit failure state if needed
      return [];
    }
  }
}
