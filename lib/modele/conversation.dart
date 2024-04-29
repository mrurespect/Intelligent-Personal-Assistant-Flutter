class Conversation {
  final int id;
  final String name;

  Conversation({
    required this.id,
    required this.name,
  });
  factory Conversation.fromMap(Map<dynamic, dynamic> map) {
    return Conversation(
      id: map['id'],
      name: map['name'],
    );
  }
}
