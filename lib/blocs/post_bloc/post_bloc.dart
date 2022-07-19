import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/post_model.dart';

part 'post_event.dart';
part 'post_state.dart';

EventTransformer<T> postDroppable<T>() {
  return ((events, mapper) {
    return droppable<T>().call(events.throttle(const Duration(milliseconds: 200)), mapper);
  });
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final Dio _client;
  PostBloc({required Dio client})
      : _client = client,
        super(
          const PostState(),
        ) {
    on<PostFetched>(_onPostFetched, transformer: postDroppable());
  }

  Future<void> _onPostFetched(PostFetched event, Emitter<PostState> emit) async {
    if (state.hasMax) return;
    try {
      if (state.status == Status.initial) {
        final posts = await _fetchPosts();
        return emit(state.copyWith(status: Status.success, posts: posts, hasMax: false));
      }
      final posts = await _fetchPosts(startIndex: state.posts.length);
      if (posts.isEmpty) {
        emit(state.copyWith(hasMax: true));
      } else {
        emit(state.copyWith(status: Status.success, posts: List.of(state.posts)..addAll(posts)));
      }
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  Future<List<PostModel>> _fetchPosts({int startIndex = 0, int limit = 20}) async {
    final response = await _client.get(
      'https://jsonplaceholder.typicode.com/posts',
      queryParameters: {'_start': '$startIndex', '_limit': '$limit'},
    );
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => PostModel.fromMap(e)).cast<PostModel>().toList();
    }
    throw Exception();
  }
}
