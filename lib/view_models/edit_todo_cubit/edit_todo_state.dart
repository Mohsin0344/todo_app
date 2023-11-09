part of 'edit_todo_cubit.dart';

@immutable
abstract class EditTodoState {
  const EditTodoState();
}

class EditTodoInitial extends EditTodoState {
  const EditTodoInitial();
}

class EditTodoLoading extends EditTodoState {
  const EditTodoLoading();
}

class EditTodoCreated extends EditTodoState {
  const EditTodoCreated();
}

class EditTodoTimeout extends EditTodoState {
  const EditTodoTimeout();
}

class EditTodoNoInternet extends EditTodoState {
  const EditTodoNoInternet();
}

class EditTodoError extends EditTodoState {
  final String? message;
  const EditTodoError({this.message});
}
