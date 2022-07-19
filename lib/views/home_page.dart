import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/post_bloc/post_bloc.dart';
import '../models/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (context) => PostBloc(client: Dio())..add(const PostFetched()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  _onScroll() {
    if (isBottom) {
      context.read<PostBloc>().add(const PostFetched());
    }
  }

  bool get isBottom {
    if (!_scrollController.hasClients) return false;
    var maxScroll = _scrollController.position.maxScrollExtent;
    var currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * .9);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        switch (state.status) {
          case Status.failure:
            return const Center(
              child: Text('Bir hata oluştu!'),
            );
          case Status.success:
            if (state.posts.isEmpty) {
              return const Center(
                child: Text('Bir hata oluştu!'),
              );
            }
            var count = state.posts.length;
            if (!state.hasMax) {
              count++;
            }
            return ListView.builder(
                controller: _scrollController,
                itemCount: count,
                itemBuilder: ((context, index) {
                  if (index >= state.posts.length) {
                    return const Indicator();
                  } else {
                    return ListPostTile(post: state.posts[index]);
                  }
                }));
          default:
            return const Indicator();
        }
      }),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ListPostTile extends StatelessWidget {
  final PostModel post;
  const ListPostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text(
          post.id.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
        title: Text(post.title),
        subtitle: Text(post.body),
        isThreeLine: true,
      ),
    );
  }
}
