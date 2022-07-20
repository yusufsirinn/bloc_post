import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../desing_system/atoms/indicator.dart';
import '../enums/status_enum.dart';
import 'base_state.dart';

class BaseBlocBuilder<B extends StateStreamable<S>, S extends BaseState> extends StatelessWidget {
  final Widget success;
  final Widget? failure;
  final Widget? defaultChild;

  const BaseBlocBuilder({Key? key, required this.success, this.failure, this.defaultChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(builder: (context, state) {
      switch (state.status) {
        case Status.failure:
          if (failure != null) {
            return failure!;
          }
          return const Center(
            child: Text('Bir hata oluştu!'),
          );
        case Status.success:
          return success;
        default:
          if (defaultChild != null) {
            return defaultChild!;
          }
          return const Indicator();
      }
    });
  }
}
