// ignore_for_file: file_names

class Todo {
  final int? id;
  final String name;
  final String date;
  final String description;
  bool isComplete;

  Todo({
    this.id,
    required this.name,
    required this.date,
    required this.description,
    this.isComplete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'description': description,
      'isComplete': isComplete ? 1 : 0,
    };
  }
}
