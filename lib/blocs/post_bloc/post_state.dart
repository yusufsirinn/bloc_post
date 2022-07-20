// ignore_for_file: public_member_api_docs, sort_constructors_first
part of './post_bloc.dart';

class PostState extends BaseState {
  final List<PostModel> posts;
  final bool hasMax;

  const PostState({
    this.posts = const <PostModel>[],
    this.hasMax = false,
    super.status = Status.initial,
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
