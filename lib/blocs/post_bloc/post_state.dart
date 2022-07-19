part of './post_bloc.dart';

enum Status { initial, success, failure }

class PostState extends Equatable {
  final List<PostModel> posts;
  final bool hasMax;
  final Status status;

  const PostState({
    this.posts = const <PostModel>[],
    this.hasMax = false,
    this.status = Status.initial,
  });
  @override
  List<Object?> get props => [posts, status, hasMax];

  PostState copyWith({
    List<PostModel>? posts,
    bool? hasMax,
    Status? status,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      hasMax: hasMax ?? this.hasMax,
      status: status ?? this.status,
    );
  }
}
