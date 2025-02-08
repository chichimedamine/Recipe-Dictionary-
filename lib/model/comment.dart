class Comment {
  int id;
  int recipeId;
  int userId;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  String message;
  String username;

  Comment({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.message,
    required this.username,

  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']??0,
      recipeId: json['recipe_id']??0,
      userId: json['user_id']??0,
      content: json['content']??'',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      message: json['message']??'',
      username: json['username']??'',
    );
  }
}
