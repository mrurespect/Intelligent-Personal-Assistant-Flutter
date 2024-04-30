class Conversation {
  final int id;
  final String name;

  Conversation({
    required this.id,
    required this.name,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] ?? 0,
      name: map['nom'] ?? '',
    );
  }
}
