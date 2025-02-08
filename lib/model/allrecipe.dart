class AllRecipe {
  int id;
  String title;
  String description;
  String ingredients;
  String instructions;
  int categoryId;
  DateTime createdAt;
  DateTime updatedAt;
  String? imagePath;
  String? image;
  String username;

  AllRecipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.imagePath,
    this.image,
    required this.username,
  });

  factory AllRecipe.fromJson(Map<String, dynamic> json) {
    return AllRecipe(
      id: json['id']??0,
      title: json['title']??'',
      description: json['description']??'',
      ingredients: json['ingredients']??'',
      instructions: json['instructions']??'',
      categoryId: json['category_id']??0,
      createdAt: DateTime.parse(json['created_at']??'1990-01-01T00:00:00.000000Z'),
      updatedAt: DateTime.parse(json['updated_at']??'1990-01-01T00:00:00.000000Z'),
      imagePath: json['image_path'] as String?,
      image: json['image'] as String?,
      username: json['username']??'',
    );
  }
}
