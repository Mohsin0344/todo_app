import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/firestore_enums.dart';
import '../../data/firestore_repository.dart';

part 'edit_todo_state.dart';

class EditTodoCubit extends Cubit<EditTodoState> {
  final FireStore _fireStore;

  EditTodoCubit(this._fireStore) : super(const EditTodoInitial());

  editTodo({
    required String todoId,
    required String newTitle,
    required String newDescription,
    required bool newCompletedStatus,
  }) async {
    try {
      emit(const EditTodoLoading());
      var editTodoRepositoryResponse = await _fireStore.editTodo(
        todoId: todoId,
        newTitle: newTitle,
        newDescription: newDescription,
        newCompletedStatus: newCompletedStatus,
      );
      if (editTodoRepositoryResponse == FirebaseResponse.success) {
        emit(
          const EditTodoCreated(),
        );
      } else if (editTodoRepositoryResponse == FirebaseResponse.timeout) {
        emit(
          const EditTodoTimeout(),
        );
      } else if (editTodoRepositoryResponse == FirebaseResponse.noInternet) {
        emit(
          const EditTodoNoInternet(),
        );
      } else {
        emit(
          EditTodoError(
            message: editTodoRepositoryResponse,
          ),
        );
      }
    } catch (e) {
      emit(
        EditTodoError(
          message: e.toString(),
        ),
      );
    }
  }
}
