import 'package:flutter/material.dart';
import 'package:todos_app/routes/route_models/add_or_edit_todo_route_model.dart';
import 'package:todos_app/utils/screen_names.dart';
import 'package:todos_app/views/screens/add_or_edit_todos.dart';
import 'package:todos_app/views/screens/todos_screen.dart';

class AppRoutes {
  Route? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ScreenNames.todosScreen:
        return MaterialPageRoute(
          builder: (context) => const TodosScreen(),
        );

      case ScreenNames.addOrEditTodos:
        AddOrEditTodoRouteModel arguments = args as AddOrEditTodoRouteModel;
        return MaterialPageRoute(
          builder: (context) => AddOrEditTodos(
            todo: arguments.todo,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const TodosScreen(),
        );
    }
  }
}
