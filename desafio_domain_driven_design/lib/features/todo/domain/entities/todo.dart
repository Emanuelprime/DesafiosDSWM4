class Todo {
  final String id;      // colocando id, nao sei se vai quebrar a estrutura do codigo depois, no main.dart do professor nao tem
  final String title;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Todo copyWith({       // metodo copyWith para facilitar a alteração de estados. Gera uma copia com os elementos novos
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
    id: id ?? this.id,
    title: title ?? this.title,
    isCompleted: isCompleted ?? this.isCompleted,
    );
  }   
}