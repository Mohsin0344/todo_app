part of 'todo_status_cubit.dart';

@immutable
abstract class TodoStatusState {
  const TodoStatusState();
}

class TodoStatusInitial extends TodoStatusState {
  const TodoStatusInitial();
}

class TodoStatusLoading extends TodoStatusState {
  const TodoStatusLoading();
}

class TodoStatusCreated extends TodoStatusState {
  const TodoStatusCreated();
}

class TodoStatusTimeout extends TodoStatusState {
  const TodoStatusTimeout();
}

class TodoStatusNoInternet extends TodoStatusState {
  const TodoStatusNoInternet();
}

class TodoStatusError extends TodoStatusState {
  final String? message;
  const TodoStatusError({this.message});
}
