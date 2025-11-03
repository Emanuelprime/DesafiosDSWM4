import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';
import '../../domain/usecases/addTodo_usecase.dart';
import '../../domain/usecases/deleteTodo.usecase.dart';
import '../../domain/usecases/getTodos_usecase.dart';
import '../../domain/usecases/updateTodo_usecase.dart';

class TodoProvider extends ChangeNotifier {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  TodoProvider({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  }) {
    loadTodos();
  }

  // Validação do título
  String? validateTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'O título não pode estar vazio';
    }

    if (title.trim().length < 3) {
      return 'O título deve ter pelo menos 3 caracteres';
    }

    if (title.trim().length > 50) {
      return 'O título deve ter no máximo 50 caracteres';
    }

    // Validar caracteres especiais indesejados
    final invalidChars = RegExp(r'[<>{}[\]\\\/]');
    if (invalidChars.hasMatch(title)) {
      return 'O título contém caracteres inválidos';
    }

    return null;
  }

  Future<void> loadTodos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todos = await getTodosUseCase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(String title) async {
    // Validar título antes de adicionar
    final validationError = validateTitle(title);
    if (validationError != null) {
      _error = validationError;
      notifyListeners();
      return;
    }

    try {
      final newTodo = Todo(id: DateTime.now().toString(), title: title.trim());
      await addTodoUseCase(newTodo);
      await loadTodos();
      _error = null; // Limpar erro em caso de sucesso
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    // Validar título antes de atualizar
    final validationError = validateTitle(todo.title);
    if (validationError != null) {
      _error = validationError;
      notifyListeners();
      return;
    }

    try {
      final updatedTodo = Todo(
        id: todo.id,
        title: todo.title.trim(),
        isCompleted: todo.isCompleted,
      );
      await updateTodoUseCase(updatedTodo);
      await loadTodos();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await deleteTodoUseCase(id);
      await loadTodos();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Limpar mensagens de erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
