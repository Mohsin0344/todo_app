import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todos_app/routes/route_models/add_or_edit_todo_route_model.dart';
import 'package:todos_app/utils/app_colors.dart';
import 'package:todos_app/utils/app_fonts.dart';
import 'package:todos_app/utils/screen_names.dart';
import 'package:todos_app/view_models/delete_todo_cubit/delete_todo_cubit.dart';
import 'package:todos_app/view_models/get_todos_cubit/get_todos_cubit.dart';
import '../../utils/app_strings.dart';
import '../../view_models/todo_status/todo_status_cubit.dart';
import '../widgets/app_snackbar.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late GetTodosCubit getTodosCubit;
  late TodoStatusCubit todoStatusCubit;
  late DeleteTodoCubit deleteTodoCubit;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initCubit();
    getTodos();
  }

  initCubit() {
    getTodosCubit = context.read<GetTodosCubit>();
    todoStatusCubit = context.read<TodoStatusCubit>();
    deleteTodoCubit = context.read<DeleteTodoCubit>();
  }

  getTodos() {
    getTodosCubit.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetTodosCubit, GetTodosState>(
          listener: (context, state) {
            if (state is GetTodosError) {
              AppSnackBar.showAnimatedSnackBar(
                message: state.message.toString(),
                context: context,
              );
            } else if (state is GetTodosTimeout) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.timeout,
                context: context,
              );
            } else if (state is GetTodosNoInternet) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.noInternet,
                context: context,
              );
            } else if (state is GetTodosLoaded) {}
          },
        ),
        BlocListener<TodoStatusCubit, TodoStatusState>(
          listener: (context, state) {
            if (state is TodoStatusError) {
              AppSnackBar.showAnimatedSnackBar(
                message: state.message.toString(),
                context: context,
              );
            } else if (state is TodoStatusTimeout) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.timeout,
                context: context,
              );
            } else if (state is TodoStatusNoInternet) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.noInternet,
                context: context,
              );
            }
          },
        ),
        BlocListener<DeleteTodoCubit, DeleteTodoState>(
          listener: (context, state) {
            if (state is DeleteTodoError) {
              AppSnackBar.showAnimatedSnackBar(
                message: state.message.toString(),
                context: context,
              );
            } else if (state is DeleteTodoTimeout) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.timeout,
                context: context,
              );
            } else if (state is DeleteTodoNoInternet) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.noInternet,
                context: context,
              );
            } else if (state is DeleteTodoLoaded) {
              getTodosCubit.allTodos.removeAt(selectedIndex);
              getTodosCubit.rebuildTodos();
            }
          },
        ),
      ],
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 0.20.sh,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'My Todos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  background: Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: AppColors.primaryColor,
                      height: 0.10.sh,
                      margin: EdgeInsets.symmetric(
                        horizontal: 12.w,
                      ),
                      child: todosChartBuilder(),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: todosBuilder(),
        ),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }

  todosChartBuilder() {
    return BlocBuilder<GetTodosCubit, GetTodosState>(
      builder: (context, state) {
        if (state is GetTodosLoaded) {
          return todosChart();
        }
        return todosChartLoading();
      },
    );
  }

  todosChart() {
    return Row(
      children: [
        headerSliverContainers(
          text: getTodosCubit.allTodos.where((element) => !element.completed).length.toString(),
          icon: Icons.arrow_downward,
          description: 'Pending',
        ),
        SizedBox(
          width: 6.w,
        ),
        headerSliverContainers(
          text: getTodosCubit.allTodos.where((element) => element.completed).length.toString(),
          icon: Icons.arrow_upward,
          description: 'Completed',
        ),
        SizedBox(
          width: 6.w,
        ),
        headerSliverContainers(
          text: getTodosCubit.allTodos.length.toString(),
          icon: Icons.equalizer,
          description: 'Total',
        ),
      ],
    );
  }

  todosChartLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBaseColor,
      highlightColor: AppColors.skeletonHighlightColor,
      child: Row(
        children: [
          headerSliverContainers(
            text: '',
            icon: Icons.arrow_downward,
            description: '',
          ),
          SizedBox(
            width: 6.w,
          ),
          headerSliverContainers(
            text: '',
            icon: Icons.arrow_upward,
            description: '',
          ),
          SizedBox(
            width: 6.w,
          ),
          headerSliverContainers(
            text: '',
            icon: Icons.equalizer,
            description: '',
          ),
        ],
      ),
    );
  }

  headerSliverContainers({
    required String text,
    required String description,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.totalColor,
          borderRadius: BorderRadius.circular(
            8.r,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),
        child: Center(
            child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Center(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                description,
                style: AppFonts.bodyFont(
                  color: AppColors.primaryColor,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  //** Floating action button for adding todos **//
  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        if (getTodosCubit.allTodos.length <= 9) {
          Navigator.pushNamed(context, ScreenNames.addOrEditTodos, arguments: const AddOrEditTodoRouteModel(todo: null));
          return;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) => Platform.isIOS ? _buildIOSDialog(context) : _buildAndroidDialog(context),
        );
      },
      backgroundColor: AppColors.primaryColor,
      child: const Icon(
        Icons.add,
        color: AppColors.textColor,
      ),
    );
  }

  todosBuilder() {
    return BlocBuilder<GetTodosCubit, GetTodosState>(
      builder: (context, state) {
        if (state is GetTodosLoaded) {
          return todosBody();
        }
        return todosLoading();
      },
    );
  }

  todosBody() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return SizedBox(
            height: 100.h,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ListTile(
                    title: Text(
                      getTodosCubit.allTodos[index].title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      getTodosCubit.allTodos[index].description,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    trailing: SizedBox(
                      width: 70.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: deleteTodoBuilder(
                              index: index,
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Expanded(
                            child: SwitchListTile(
                              onChanged: (val) {
                                getTodosCubit.allTodos[index].completed = !getTodosCubit.allTodos[index].completed;
                                todoStatusCubit.changeTodoStatus(
                                  todoId: getTodosCubit.allTodos[index].id,
                                  completed: val,
                                );
                                getTodosCubit.rebuildTodos();
                              },
                              value: getTodosCubit.allTodos[index].completed,
                              activeColor: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ScreenNames.addOrEditTodos,
                        arguments: AddOrEditTodoRouteModel(
                          todo: getTodosCubit.allTodos[index],
                        ),
                      );
                    },
                    child: Container(
                      width: 0.92.sw,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          'Edit',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 12.h,
          );
        },
        itemCount: getTodosCubit.allTodos.length);
  }

  deleteTodoBuilder({required int index}) {
    return BlocBuilder<DeleteTodoCubit, DeleteTodoState>(
      builder: (context, state) {
        if (state is DeleteTodoLoading && selectedIndex == index) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }
        return IconButton(
            icon: const Icon(Icons.delete),
            color: AppColors.secondaryColor,
            onPressed: () {
              selectedIndex = index;
              deleteTodoCubit.deleteTodo(
                todoId: getTodosCubit.allTodos[index].id,
              );
            });
      },
    );
  }

  todosLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBaseColor,
      highlightColor: AppColors.skeletonHighlightColor,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return SizedBox(
            height: 50.h,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 12.h,
          );
        },
        itemCount: 3,
      ),
    );
  }

  Widget _buildIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'Limit Completed',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: Text(
        'You have reached the limit of completed todos. Upgrade to the Pro version or remove the first todo.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            // TODO: Handle Buy Pro Version
            Navigator.of(context).pop();
          },
          child: const Text('Buy Pro Version'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            deleteFirstTodo();
          },
          child: const Text('Remove First Todo'),
        ),
      ],
    );
  }

  Widget _buildAndroidDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Limit Completed',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: Text(
        'You have reached the limit of completed todos. Upgrade to the Pro version or remove the first todo.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        TextButton(
          onPressed: () {
            // TODO: Handle Buy Pro Version
            Navigator.of(context).pop();
          },
          child: const Text('Buy Pro Version'),
        ),
        TextButton(
          onPressed: () {
            deleteFirstTodo();
          },
          child: const Text('Remove First Todo'),
        ),
      ],
    );
  }

  deleteFirstTodo() {
    deleteTodoCubit.deleteTodo(
      todoId: getTodosCubit.allTodos.first.id,
    );
    Navigator.of(context).pop();
  }
}
