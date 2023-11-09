import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todos_app/utils/app_colors.dart';
import 'package:todos_app/utils/app_strings.dart';
import 'package:todos_app/view_models/create_todo_cubit/create_todo_cubit.dart';
import 'package:todos_app/view_models/edit_todo_cubit/edit_todo_cubit.dart';
import 'package:todos_app/view_models/get_todos_cubit/get_todos_cubit.dart';
import 'package:todos_app/views/widgets/app_snackbar.dart';

import '../../models/todo_model.dart';

class AddOrEditTodos extends StatefulWidget {
  final Todo? todo;

  const AddOrEditTodos({
    Key? key,
    this.todo,
  }) : super(key: key);

  @override
  State<AddOrEditTodos> createState() => _AddOrEditTodosState();
}

class _AddOrEditTodosState extends State<AddOrEditTodos> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late CreateTodoCubit createTodoCubit;
  late GetTodosCubit getTodosCubit;
  late EditTodoCubit editTodoCubit;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    initCubit();
    populateInitialValues();
  }

  initCubit() {
    createTodoCubit = context.read<CreateTodoCubit>();
    getTodosCubit = context.read<GetTodosCubit>();
    editTodoCubit = context.read<EditTodoCubit>();
  }

  populateInitialValues() {
    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.description;
      completed = widget.todo!.completed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateTodoCubit, CreateTodoState>(
          listener: (context, state) {
            if (state is CreateTodoError) {
              AppSnackBar.showAnimatedSnackBar(
                message: state.message.toString(),
                context: context,
              );
            } else if (state is CreateTodoTimeout) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.timeout,
                context: context,
              );
            } else if (state is CreateTodoNoInternet) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.noInternet,
                context: context,
              );
            } else if (state is CreateTodoCreated) {
              getTodosCubit.getTodos();
              Navigator.pop(context);
            }
          },
        ),
        BlocListener<EditTodoCubit, EditTodoState>(
          listener: (context, state) {
            if (state is EditTodoError) {
              AppSnackBar.showAnimatedSnackBar(
                message: state.message.toString(),
                context: context,
              );
            } else if (state is EditTodoTimeout) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.timeout,
                context: context,
              );
            } else if (state is EditTodoNoInternet) {
              AppSnackBar.showAnimatedSnackBar(
                message: AppStrings.noInternet,
                context: context,
              );
            } else if (state is EditTodoCreated) {
              getTodosCubit.getTodos();
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Todos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: SafeArea(
            bottom: true,
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 20.h,
                    ),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      textFieldWithLeadingText(
                          controller: titleController,
                          text: 'Title',
                          validator: (title) {
                            if (title!.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          }),
                      textFieldWithLeadingText(
                          controller: descriptionController,
                          text: 'Description',
                          validator: (description) {
                            if (description!.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          }),
                      Visibility(
                          visible: widget.todo != null,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Completed', style: Theme.of(context).textTheme.bodyLarge),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: StatefulBuilder(
                                    builder: (context, toggle) {
                                      return SwitchListTile(
                                        onChanged: (val) {
                                          toggle(() {
                                            completed = !completed;
                                          });
                                        },
                                        value: completed,
                                        activeColor: AppColors.primaryColor,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                widget.todo == null ? submitButton() : editButton(),
              ],
            )),
      ),
    );
  }

  submitButton() {
    return BlocBuilder<CreateTodoCubit, CreateTodoState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: state != const CreateTodoLoading()
                ? () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      createTodoCubit.createTodo(title: titleController.text, description: descriptionController.text);
                    }
                  }
                : null,
            child: Container(
              height: 50.h,
              margin: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: state != const CreateTodoLoading()
                    ? Text(
                        'Add Todo',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : const CircularProgressIndicator(
                        color: AppColors.textColor,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  editButton() {
    return BlocBuilder<EditTodoCubit, EditTodoState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: state != const EditTodoLoading()
                ? () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      editTodoCubit.editTodo(
                        todoId: widget.todo!.id,
                        newTitle: titleController.text,
                        newDescription: descriptionController.text,
                        newCompletedStatus: completed,
                      );
                    }
                  }
                : null,
            child: Container(
              height: 50.h,
              margin: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: state != const EditTodoLoading()
                    ? Text(
                        'Edit Todo',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : const CircularProgressIndicator(
                        color: AppColors.textColor,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  textFieldWithLeadingText({required String text, required TextEditingController controller, String? Function(String?)? validator}) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controller,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
