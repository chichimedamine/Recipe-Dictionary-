class Recipe {
  int id;
  String title;
  String description;
  String ingredients;
  String instructions;
  int categoryId;
  DateTime createdAt;
  DateTime updatedAt;
  String imagePath;
  String image;
  String username;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
    required this.image,
    required this.username,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      ingredients: json['ingredients'],
      instructions: json['instructions'],
      categoryId: json['category_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      imagePath: json['image_path'],
      image: json['image'],
      username: json['username'],
    );
  }
}
