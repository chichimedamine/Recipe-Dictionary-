part of 'recipe_bloc.dart';

@immutable
sealed class RecipeEvent {}

class GetRecipeEvent extends RecipeEvent {}

class GetRecipesByCategoryEvent extends RecipeEvent {
  final int categoryId;
  GetRecipesByCategoryEvent(this.categoryId);
}

class SearchRecipeEvent extends RecipeEvent {
  final String query;
  SearchRecipeEvent(this.query);
}

class RecipeLikeEvent extends RecipeEvent {
  final int recipeId;
  final int userId;
  final String type;
  RecipeLikeEvent(this.recipeId, this.userId, this.type);
}

class RecipeDislikeEvent extends RecipeEvent {
  final int recipeId;
  final int userId;
  final String type;
  RecipeDislikeEvent(this.recipeId, this.userId, this.type);
}

class GetReactionEvent extends RecipeEvent {
  final int recipeId;

  GetReactionEvent(this.recipeId);
}

class GetCommentByRecipeEvent extends RecipeEvent {
  final int recipeId;
  GetCommentByRecipeEvent(this.recipeId);
}

class CreateCommentEvent extends RecipeEvent {
  final int recipeId;
  final String content;
  CreateCommentEvent(this.recipeId, this.content);
}

class GetFavoriteRecipesEvent extends RecipeEvent {
  GetFavoriteRecipesEvent();
}

class AddFavoriteEvent extends RecipeEvent {
  final int recipeId;
  final BuildContext context;

  AddFavoriteEvent(
    this.recipeId,
    this.context,
  );
}

class ToggleFavoriteRecipeEvent extends RecipeEvent {
  final AllRecipe recipe;

  ToggleFavoriteRecipeEvent(this.recipe);
}

class GetFavStatusEvent extends RecipeEvent {
  final int recipeId;
  GetFavStatusEvent(this.recipeId);
}

class DeleteRecipeFavEvent extends RecipeEvent {
  final int recipeId;
  final BuildContext context;

  DeleteRecipeFavEvent(this.recipeId , this.context);
}
