class Reaction {
  final String type;

  Reaction({required this.type});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      type: json['type'],
    );
  }
}

