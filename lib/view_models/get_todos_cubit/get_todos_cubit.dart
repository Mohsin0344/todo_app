import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/firestore_enums.dart';
import '../../data/firestore_repository.dart';
import '../../models/todo_model.dart';

part 'get_todos_state.dart';

class GetTodosCubit extends Cubit<GetTodosState> {
  final FireStore _fireStore;
  GetTodosCubit(this._fireStore) : super(const GetTodosInitial());
  List<Todo> allTodos = [];

  getTodos() async {
    try {
      emit(const GetTodosLoading());
      var getTodosRepositoryResponse = await _fireStore.getTodos();
      if(getTodosRepositoryResponse is List<Todo>) {
        allTodos = getTodosRepositoryResponse;
        emit(GetTodosLoaded(allTodos: allTodos),);
      } else if(getTodosRepositoryResponse == FirebaseResponse.timeout) {
        emit(const GetTodosTimeout(),);
      } else if(getTodosRepositoryResponse == FirebaseResponse.noInternet) {
        emit(const GetTodosNoInternet(),);
      } else {
        emit(GetTodosError(message: getTodosRepositoryResponse,),);
      }
    } catch(e) {
      emit(GetTodosError(message: e.toString(),),);
    }
  }

  rebuildTodos() {
    emit(GetTodosLoaded(allTodos: allTodos),);
  }
}
