import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos_app/data/firestore_enums.dart';

import '../models/todo_model.dart';

abstract class FireStore {
  Future<dynamic> createTodo({
    required String title,
    required String description,
  });

  Future<dynamic> deleteTodo({
    required String todoId,
  });

  Future<dynamic> changeTodoStatus({
    required String todoId,
    required bool completed,
  });

  Future<dynamic> getTodos();

  Future<dynamic> editTodo({
    required String todoId,
    required String newTitle,
    required String newDescription,
    required bool newCompletedStatus,
  });
}

class FireStoreRepository implements FireStore {
  CollectionReference todos = FirebaseFirestore.instance.collection('todos');

  @override
  Future createTodo({
    required String title,
    required String description,
  }) async {
    try {
      await todos.add({
        'title': title,
        'description': description,
        'completed': false,
        'timeStamp': Timestamp.fromDate(DateTime.now()),
      }).timeout(const Duration(seconds: 10));
      return FirebaseResponse.success;
    } on TimeoutException catch (_) {
      return FirebaseResponse.timeout;
    } on SocketException catch (_) {
      return FirebaseResponse.noInternet;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future deleteTodo({
    required String todoId,
  }) async {
    try {
      await todos.doc(todoId).delete().timeout(const Duration(
            seconds: 10,
          ));
      return FirebaseResponse.success;
    } on TimeoutException catch (_) {
      return FirebaseResponse.timeout;
    } on SocketException catch (_) {
      return FirebaseResponse.noInternet;
    } catch (e) {
      return e.toString(); // Propagate the error to the calling code
    }
  }

  @override
  Future changeTodoStatus({
    required String todoId,
    required bool completed,
  }) async {
    try {
      await todos.doc(todoId).update({
        'completed': completed,
      }).timeout(const Duration(seconds: 10));
      return FirebaseResponse.success;
    } on SocketException catch (_) {
      return FirebaseResponse.noInternet;
    } on TimeoutException catch (_) {
      return FirebaseResponse.timeout;
    } catch (e) {
      return e.toString(); // Propagate the error to the calling code
    }
  }

  @override
  Future getTodos() async {
    try {
      QuerySnapshot querySnapshot = await todos.get().timeout(
            const Duration(
              seconds: 10,
            ),
          );
      List<Todo> allTodos = querySnapshot.docs.map((doc) => Todo.fromSnapshot(doc)).toList();
      log(allTodos.toString());
      return allTodos;
    } on TimeoutException catch (_) {
      return FirebaseResponse.timeout;
    } on SocketException catch (_) {
      return FirebaseResponse.noInternet;
    } catch (e) {
      return e.toString(); // Propagate the error to the calling code
    }
  }

  @override
  Future editTodo({
    required String todoId,
    required String newTitle,
    required String newDescription,
    required bool newCompletedStatus,
  }) async {
    try {
      await todos.doc(todoId).update({
        'title': newTitle,
        'description': newDescription,
        'completed': newCompletedStatus,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      }).timeout(
        const Duration(
          seconds: 10,
        ),
      );
      return FirebaseResponse.success;
    } on SocketException catch(_) {
      return FirebaseResponse.noInternet;
    } on TimeoutException catch(_) {
      return FirebaseResponse.timeout;
    } catch (e) {
      return e.toString(); // Propagate the error to the calling code
    }
  }
}
