class CategoryRecipe {
  int id;
  String name;
  String? description;
  DateTime createdAt;
  DateTime updatedAt;

  CategoryRecipe({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryRecipe.fromJson(Map<String, dynamic> json) {
    return CategoryRecipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
