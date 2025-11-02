import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

// o que é um usecase?
// um usecase é uma acao que o usuario pode realizar no sistema

// se o usecase é classe abstrata, como que o usecase utiliza o método já implementado?
// na prática estamos usando o código feito no data/repositories só que de forma indireta (atraves da classe abstrata)

// o usecase de pegar todos os to-dos do sistema
class GetTodosUseCase {
  // dependencia da interface
  final TodoRepository repository;

  // metodo construtor recebe a interface
  GetTodosUseCase(this.repository);

  // metodo call deixa a gente usar a classe como uma funcao
  Future<List<Todo>> call() async {
    return await repository.getTodos();
  }
}