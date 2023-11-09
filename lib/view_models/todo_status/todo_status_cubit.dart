import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/firestore_enums.dart';
import '../../data/firestore_repository.dart';

part 'todo_status_state.dart';

class TodoStatusCubit extends Cubit<TodoStatusState> {
  final FireStore _fireStore;

  TodoStatusCubit(this._fireStore) : super(const TodoStatusInitial());

  changeTodoStatus({required String todoId, required bool completed}) async {
    try {
      emit(const TodoStatusLoading());
      var todoStatusRepositoryResponse = await _fireStore.changeTodoStatus(
        todoId: todoId,
        completed: completed,
      );
      if (todoStatusRepositoryResponse == FirebaseResponse.success) {
        emit(
          const TodoStatusCreated(),
        );
      } else if (todoStatusRepositoryResponse == FirebaseResponse.timeout) {
        emit(
          const TodoStatusTimeout(),
        );
      } else if (todoStatusRepositoryResponse == FirebaseResponse.noInternet) {
        emit(
          const TodoStatusNoInternet(),
        );
      } else {
        emit(
          TodoStatusError(
            message: todoStatusRepositoryResponse,
          ),
        );
      }
    } catch (e) {
      emit(
        TodoStatusError(
          message: e.toString(),
        ),
      );
    }
  }
}
