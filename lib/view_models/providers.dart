import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/data/firestore_repository.dart';
import 'package:todos_app/view_models/create_todo_cubit/create_todo_cubit.dart';
import 'package:todos_app/view_models/delete_todo_cubit/delete_todo_cubit.dart';
import 'package:todos_app/view_models/edit_todo_cubit/edit_todo_cubit.dart';
import 'package:todos_app/view_models/todo_status/todo_status_cubit.dart';

import 'get_todos_cubit/get_todos_cubit.dart';

class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<CreateTodoCubit>(
      create: (context) => CreateTodoCubit(
        FireStoreRepository(),
      ),
    ),
    BlocProvider<GetTodosCubit>(
      create: (context) => GetTodosCubit(
        FireStoreRepository(),
      ),
    ),
    BlocProvider<TodoStatusCubit>(
      create: (context) => TodoStatusCubit(
        FireStoreRepository(),
      ),
    ),
    BlocProvider<DeleteTodoCubit>(
      create: (context) => DeleteTodoCubit(
        FireStoreRepository(),
      ),
    ),
    BlocProvider<EditTodoCubit>(
      create: (context) => EditTodoCubit(
        FireStoreRepository(),
      ),
    ),
  ];
}
