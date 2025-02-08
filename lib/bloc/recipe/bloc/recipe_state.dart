part of 'recipe_bloc.dart';

@immutable
sealed class RecipeState {}

final class RecipeInitial extends RecipeState {}

final class RecipeLoaded extends RecipeState {
  final List<AllRecipe> recipes;
  RecipeLoaded(this.recipes);
}

final class RecipeLoading extends RecipeState {}

final class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}

class RecipeByCategoryLoading extends RecipeState {}

class RecipeByCategoryLoaded extends RecipeState {
  final List<AllRecipe> recipes;
  RecipeByCategoryLoaded(this.recipes);
}

final class RecipeByCategoryError extends RecipeState {
  final String message;
  RecipeByCategoryError(this.message);
}

class RecipeByCategoryEmpty extends RecipeState {}

class RecipeBySearchLoading extends RecipeState {}

class RecipeBySearchLoaded extends RecipeState {
  final List<AllRecipe> recipes;
  RecipeBySearchLoaded(this.recipes);
}

final class RecipeBySearchError extends RecipeState {
  final String message;
  RecipeBySearchError(this.message);
}

class RecipeLiked extends RecipeState {}

class RecipeNotliked extends RecipeState {}

class RectionLoaded extends RecipeState {
  final Reaction reaction;
  RectionLoaded(this.reaction);
}

class CommentLoaded extends RecipeState {
  final List<Comment> comment;
  CommentLoaded(this.comment);
}

class CommentLoading extends RecipeState {}

class CommentCreated extends RecipeState {}

class CommentEmpty extends RecipeState {}

class RecipeFavoriteStatus extends RecipeState {
  final bool isFavorite;
  RecipeFavoriteStatus({required this.isFavorite});
}

class RecipeFavoriteEmpty extends RecipeState {}

class RecipeFavoriteLoaded extends RecipeState {
  final List<AllRecipe> recipes;
  RecipeFavoriteLoaded(this.recipes);
}

class RecipeFavoriteLoading extends RecipeState {}

class RecipeFavoriteAdded extends RecipeState {}
class RecipeFavStatusLoaded extends RecipeState {
  final FavStatus favStatus;
  RecipeFavStatusLoaded(this.favStatus);
}