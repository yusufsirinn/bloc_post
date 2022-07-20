part of '../home_page.dart';

class ListPostTile extends StatelessWidget {
  final PostModel post;
  const ListPostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
