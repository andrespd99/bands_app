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
        id: data['id'],
        name: data['name'],
        votes: data['votes'],
      );
}
