import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/firestore_enums.dart';
import '../../data/firestore_repository.dart';
part 'delete_todo_state.dart';

class DeleteTodoCubit extends Cubit<DeleteTodoState> {
  final FireStore _fireStore;

  DeleteTodoCubit(this._fireStore) : super(const DeleteTodoInitial());

  deleteTodo({required String todoId}) async {
    try {
      emit(const DeleteTodoLoading());
      var deleteTodoRepositoryResponse = await _fireStore.deleteTodo(
        todoId: todoId,
      );
      if (deleteTodoRepositoryResponse == FirebaseResponse.success) {
        emit(
          const DeleteTodoLoaded(),
        );
      } else if (deleteTodoRepositoryResponse == FirebaseResponse.timeout) {
        emit(
          const DeleteTodoTimeout(),
        );
      } else if (deleteTodoRepositoryResponse == FirebaseResponse.noInternet) {
        emit(
          const DeleteTodoNoInternet(),
        );
      } else {
        emit(
          DeleteTodoError(
            message: deleteTodoRepositoryResponse,
          ),
        );
      }
    } catch (e) {
      emit(
        DeleteTodoError(
          message: e.toString(),
        ),
      );
    }
  }
}
