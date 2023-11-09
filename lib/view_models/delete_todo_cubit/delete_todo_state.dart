part of 'delete_todo_cubit.dart';

@immutable
abstract class DeleteTodoState {
  const DeleteTodoState();
}

class DeleteTodoInitial extends DeleteTodoState {
  const DeleteTodoInitial();
}

class DeleteTodoLoading extends DeleteTodoState {
  const DeleteTodoLoading();
}

class DeleteTodoLoaded extends DeleteTodoState {
  const DeleteTodoLoaded();
}

class DeleteTodoTimeout extends DeleteTodoState {
  const DeleteTodoTimeout();
}

class DeleteTodoNoInternet extends DeleteTodoState {
  const DeleteTodoNoInternet();
}

class DeleteTodoError extends DeleteTodoState {
  final String? message;
  const DeleteTodoError({this.message});
}
