class Band {
  final String id;
  final String name;
  int? votes;

  Band({
    required this.id,
    required this.name,
    this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> data) => Band(
        id: data['id'] ?? 'no-id',
        name: data['name'] ?? 'Unnamed',
        votes: data['votes'] ?? 0,
      );
}
