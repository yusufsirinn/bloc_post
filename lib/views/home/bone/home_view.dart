part of '../home_page.dart';

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
            return _success(state);
          default:
            return const Indicator();
        }
      }),
    );
  }

  Widget _success(PostState state) {
    var count = state.posts.length;
    if (!state.hasMax) count++;
    return ListView.builder(
      controller: _scrollController,
      itemCount: count,
      itemBuilder: ((context, index) {
        if (index >= state.posts.length) {
          return const Indicator();
        } else {
          return ListPostTile(post: state.posts[index]);
        }
      }),
    );
  }
}
