import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_post/core/enums/url_enum.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../core/base/base_state.dart';
import '../../core/enums/status_enum.dart';
import '../../core/utils/event_transformer_utils.dart';
import '../../models/post_model.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final Dio _client;
  PostBloc({required Dio client})
      : _client = client,
        super(
          const PostState(),
        ) {
    on<PostFetched>(_onPostFetched, transformer: droppableTransformer());
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
      URL.posts.value(),
      queryParameters: {'_start': '$startIndex', '_limit': '$limit'},
    );
    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List).map((e) => PostModel.fromMap(e)).cast<PostModel>().toList();
    }
    throw Exception();
  }
}
