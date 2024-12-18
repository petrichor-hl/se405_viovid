import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/post/data/post_repository.dart';

class PostCubit extends Cubit<void> {
  final PostRepository repository;

  PostCubit(this.repository) : super(null);

  Future<void> createPost(Map<String, dynamic> PostData) async {
    try {
      await repository.createPost(PostData);
      emit(null); // Emit success state if needed
    } catch (e) {
      emit(null); // Emit failure state if needed
    }
  }

  Future<List<Map<String, dynamic>>> getListPost() async {
    try {
      final response = await repository.getPosts();
      emit(null); // Emit success state if needed
      return List<Map<String, dynamic>>.from(response['result']['items']);
    } catch (e) {
      emit(null); // Emit failure state if needed
      return [];
    }
  }
}
