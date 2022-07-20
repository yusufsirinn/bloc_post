import 'package:bloc_post/core/enums/status_enum.dart';
import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  final Status status;

  const BaseState({required this.status});
}
