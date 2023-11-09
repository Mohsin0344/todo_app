part of 'create_todo_cubit.dart';

@immutable
abstract class CreateTodoState {
  const CreateTodoState();
}

class CreateTodoInitial extends CreateTodoState {
  const CreateTodoInitial();
}

class CreateTodoLoading extends CreateTodoState {
  const CreateTodoLoading();
}

class CreateTodoCreated extends CreateTodoState {
  const CreateTodoCreated();
}

class CreateTodoTimeout extends CreateTodoState {
  const CreateTodoTimeout();
}

class CreateTodoNoInternet extends CreateTodoState {
  const CreateTodoNoInternet();
}

class CreateTodoError extends CreateTodoState {
  final String? message;
  const CreateTodoError({this.message});
}
