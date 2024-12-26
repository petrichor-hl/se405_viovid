import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/post/data/post_repository.dart';
import 'package:viovid_app/features/post/post_api_service.dart';

class PostCubit extends Cubit<void> {
  final PostRepository repository;

  PostCubit(this.repository) : super(null);

  Future<Post> createPost(Map<String, dynamic> postData) async {
    try {
      final post = await repository.createPost(postData);
      return post;
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }

  Future<List<Post>> getListPost(int currentPostIndex) async {
    try {
      final response = await repository.getPosts(currentPostIndex);
      return response.items;
    } catch (e) {
      emit(null); // Emit failure state if needed
      return [];
    }
  }

  Future<List<Post>> getListPostFromChannel(
      int currentPostIndex, String channelId) async {
    try {
      final response = await repository.getPostsFromChannel(
        currentPostIndex,
        channelId,
      );
      return response.items;
    } catch (e) {
      print(e);
      emit(null); // Emit failure state if needed
      return [];
    }
  }

  Future<Post> likePost(String postId) async {
    try {
      return await repository.likePost(postId);
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }

  Future<Post> unlikePost(String postId) async {
    try {
      return await repository.unlikePost(postId);
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }

  Future<PostComment> addComment(Map<String, dynamic> postData) async {
    try {
      return await repository.addComment(postData);
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }

  Future<List<PostComment>> listComments(
      int currentIndex, String postId) async {
    try {
      final response = await repository.listComments(currentIndex, postId);
      return response.items;
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }
}
