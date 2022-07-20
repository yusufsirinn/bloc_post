import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/post_bloc/post_bloc.dart';
import '../../core/desing_system/atoms/indicator.dart';
import '../../core/enums/status_enum.dart';
import '../../models/post_model.dart';

part 'bone/home_view.dart';
part 'bone/list_post_tile.dart';

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
