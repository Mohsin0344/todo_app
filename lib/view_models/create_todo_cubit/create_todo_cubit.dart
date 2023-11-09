import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos_app/data/firestore_enums.dart';

import '../../data/firestore_repository.dart';

part 'create_todo_state.dart';

class CreateTodoCubit extends Cubit<CreateTodoState> {
  final FireStore _fireStore;
  CreateTodoCubit(this._fireStore) : super(const CreateTodoInitial());
  
  createTodo({
    required String title,
    required String description,
  }) async {
    try {
      emit(const CreateTodoLoading());
      var createTodoRepository = await _fireStore.createTodo(title: title, description: description);
      if(createTodoRepository == FirebaseResponse.success) {
        emit(const CreateTodoCreated(),);
      } else if(createTodoRepository == FirebaseResponse.timeout) {
        emit(const CreateTodoTimeout(),);
      } else if(createTodoRepository == FirebaseResponse.noInternet) {
        emit(const CreateTodoNoInternet(),);
      } else {
        emit(CreateTodoError(message: createTodoRepository,),);
      }
    } catch(e) {
      emit(CreateTodoError(message: e.toString(),),);
    }
  }
}
