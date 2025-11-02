import '../repositories/todo_repository.dart';

// o que é um usecase?
// um usecase é uma acao que o usuario pode realizar no sistema

// se o usecase é classe abstrata, como que o usecase utiliza o método já implementado?
// na prática estamos usando o código feito no data/repositories só que de forma indireta (atraves da classe abstrata)

// usecase para apagar uma to-do existente
class DeleteTodoUseCase {
  final TodoRepository repository;

  DeleteTodoUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteTodo(id);
  }
}