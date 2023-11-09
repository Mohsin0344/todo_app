part of 'get_todos_cubit.dart';

@immutable
abstract class GetTodosState {
  const GetTodosState();
}

class GetTodosInitial extends GetTodosState {
  const GetTodosInitial();
}

class GetTodosLoading extends GetTodosState {
  const GetTodosLoading();
}

class GetTodosLoaded extends GetTodosState {
  final List<Todo> allTodos;

  const GetTodosLoaded({
    required this.allTodos,
  });
}

class GetTodosTimeout extends GetTodosState {
  const GetTodosTimeout();
}

class GetTodosNoInternet extends GetTodosState {
  const GetTodosNoInternet();
}

class GetTodosError extends GetTodosState {
  final String? message;

  const GetTodosError({this.message});
}
