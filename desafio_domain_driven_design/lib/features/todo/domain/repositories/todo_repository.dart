import '../entities/todo.dart';

abstract class TodoRepository {     // interface que lista as operações que conseguimos fazer com os to-dos, não é implementação, apenas definição
  Future<List<Todo>> getTodos();    // future diz pra nos que a função é assincrona
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}