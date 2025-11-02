import 'package:flutter/material.dart';
import 'features/todo/data/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/getTodos_usecase.dart';
import 'features/todo/domain/usecases/addTodo_usecase.dart';
import 'features/todo/domain/usecases/updateTodo_usecase.dart';
import 'features/todo/domain/usecases/deleteTodo.usecase.dart';
import 'features/todo/presentation/pages/todo_page.dart';

void main() {
  // criando dependencias
  final repository = TodoRepositoryImpl();

  // criando usecases
  final getTodosUseCase = GetTodosUseCase(repository);
  final addTodoUseCase = AddTodoUseCase(repository);
  final updateTodoUseCase = UpdateTodoUseCase(repository);
  final deleteTodoUseCase = DeleteTodoUseCase(repository);

  runApp(MyApp(
    getTodosUseCase: getTodosUseCase,
    addTodoUseCase: addTodoUseCase,
    updateTodoUseCase: updateTodoUseCase,
    deleteTodoUseCase: deleteTodoUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  const MyApp({
    Key? key,
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de To-Do List com DDD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoPage(
        getTodosUseCase: getTodosUseCase,
        addTodoUseCase: addTodoUseCase,
        updateTodoUseCase: updateTodoUseCase,
        deleteTodoUseCase: deleteTodoUseCase,
      ),
    );
  }
}