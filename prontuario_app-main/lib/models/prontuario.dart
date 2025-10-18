import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Prontuario {
  String? id;
  final String paciente;
  final String descricao;
  final DateTime data;

  Prontuario({
    this.id,
    required this.paciente,
    required this.descricao,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'paciente': paciente,
      'descricao': descricao,
      // store as Firestore Timestamp
      'data': Timestamp.fromDate(data),
    };
  }

  factory Prontuario.fromMap(String id, Map<String, dynamic> map) {
    final raw = map['data'];

    DateTime parsedDate;
    if (raw is Timestamp) {
      parsedDate = raw.toDate();
    } else if (raw is String) {
      parsedDate = DateTime.parse(raw);
    } else if (raw is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(raw);
    } else {
      parsedDate = DateTime.now();
    }

    return Prontuario(
      id: id,
      paciente: map['paciente'] ?? '',
      descricao: map['descricao'] ?? '',
      data: parsedDate,
    );
  }
}
