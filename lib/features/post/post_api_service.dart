import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';

class PostComment {
  final String id;
  final DateTime createdAt;
  String content;
  final String applicationUserId;
  final Map<String, dynamic>? applicationUser;
  final String postId;

  PostComment({
    required this.id,
    required this.createdAt,
    required this.content,
    required this.applicationUserId,
    required this.applicationUser,
    required this.postId,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    var postComment = PostComment(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      content: json['content'],
      applicationUserId: json['applicationUserId'],
      applicationUser: json['applicationUser'],
      postId: json['postId'],
    );
    return PostComment(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      content: json['content'],
      applicationUserId: json['applicationUserId'],
      applicationUser: json['applicationUser'],
      postId: json['postId'],
    );
  }
}

class Post {
  final String id;
  final DateTime createdAt;
  DateTime updatedAt;
  List<String> hashtags;
  String content;
  List<String> imageUrls;
  int likes;
  final String applicationUserId;
  final Map<String, dynamic>? applicationUser;
  final String channelId;
  final List<PostComment> comments;

  Post({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.hashtags,
    required this.content,
    required this.imageUrls,
    required this.likes,
    required this.applicationUserId,
    required this.channelId,
    required this.applicationUser,
    this.comments = const [],
  });

  // Factory method to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      hashtags: List<String>.from(json['hashtags']),
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls']),
      likes: json['likes'],
      applicationUserId: json['applicationUserId'],
      applicationUser: json['applicationUser'],
      channelId: json['channelId'],
      comments: (json['postComments'] != null && json['postComments'] is List)
          ? List<PostComment>.from(json['postComments']
              .map((comment) => PostComment.fromJson(comment)))
          : [],
    );
  }
}

class PagingData<T> {
  final List<T> items;

  PagingData({
    required this.items,
  });

  factory PagingData.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    var res = PagingData(
      items: List<T>.from(json['items'].map((item) => fromJsonT(item))),
    );
    // print("res: ${res.items}");
    return res;
  }
}

class PostApiService {
  final Dio dio;

  PostApiService(this.dio);

  Future<Post> createPost(Map<String, dynamic> postData) async {
    print('creating Post...');
    final result = await ApiClient(dio).request<Map<String, dynamic>, Post>(
      url: '/Post',
      method: ApiMethod.post,
      payload: postData,
      fromJson: (result) => Post.fromJson(result),
    );
    print(result);
    return result;
  }

  Future<PagingData<Post>> getPosts({
    required int pageIndex,
    required int pageSize,
    required String searchText,
  }) async {
    print("getting Posts...");
    final response = await ApiClient(dio).request<void, PagingData<Post>>(
      url: '/Post',
      method: ApiMethod.get,
      queryParameters: {
        'PageIndex': pageIndex,
        'PageSize': pageSize,
        'SearchText': searchText,
      },
      fromJson: (json) => PagingData.fromJson(json, Post.fromJson),
    );

    print(response);
    return response;
  }

  Future<PagingData<Post>> getPostsByChannel({
    required int pageIndex,
    required int pageSize,
    required String channelId,
  }) async {
    print("getting Posts...");
    final response = await ApiClient(dio).request<void, PagingData<Post>>(
      url: '/Post/Channel',
      method: ApiMethod.get,
      queryParameters: {
        'PageIndex': pageIndex,
        'PageSize': pageSize,
        'ChannelId': channelId,
      },
      fromJson: (json) => PagingData.fromJson(json, Post.fromJson),
    );

    return response;
  }

  // Add Like Post Logic
  Future<Post> likePost(String postId) async {
    print("Liking post with id: $postId...");
    var result = await ApiClient(dio).request<void, Post>(
      url: '/Post/$postId/Like',
      method: ApiMethod.post,
      fromJson: (result) => Post.fromJson(result),
    );
    print("Post liked successfully.");

    return result;
  }

  // Add Unlike Post Logic
  Future<Post> unlikePost(String postId) async {
    print("Unliking post with id: $postId...");
    var result = await ApiClient(dio).request<void, Post>(
      url: '/Post/$postId/Unlike',
      method: ApiMethod.post,
      fromJson: (result) => Post.fromJson(result),
    );
    print("Post unliked successfully.");
    return result;
  }

  Future<PostComment> addComment(Map<String, dynamic> PostData) async {
    final result = await ApiClient(dio).request<void, PostComment>(
      url: '/PostComment',
      method: ApiMethod.post,
      payload: PostData,
      fromJson: (result) => PostComment.fromJson(result),
    );
    print("Comment added successfully.");
    return result;
  }

  Future<PagingData<PostComment>> getCommentsByPost({
    required int pageIndex,
    required int pageSize,
    required String postId,
  }) async {
    final response =
        await ApiClient(dio).request<void, PagingData<PostComment>>(
      url: '/PostComment/Post',
      method: ApiMethod.get,
      queryParameters: {
        'PageIndex': pageIndex,
        'PageSize': pageSize,
        'PostId': postId,
      },
      fromJson: (json) => PagingData.fromJson(json, PostComment.fromJson),
    );

    return response;
  }
}
