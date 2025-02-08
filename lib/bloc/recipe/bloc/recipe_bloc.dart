import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:recipe_dictionary/model/allrecipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/Api.dart';
import '../../../helpers/fonthelper.dart';
import '../../../model/comment.dart';
import '../../../model/favstatus.dart';
import '../../../model/reaction.dart';
import '../../../model/recipe.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc() : super(RecipeInitial()) {
    on<RecipeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetRecipeEvent>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');

      final response = Api.getRecipes(
        token!,
      );
      List<AllRecipe> recipes = [];
      final responseValue = await response;
      recipes = responseValue;
      emit(RecipeLoaded(recipes));
    });
    on<GetRecipesByCategoryEvent>((event, emit) async {
      print("get recipes by category");
      emit(RecipeByCategoryLoading());
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = Api.getRecipesByCategory(
        event.categoryId,
        token!,
      );
      List<AllRecipe> recipes = [];
      final responseValue = await response;
      recipes = responseValue;
      if (recipes.isEmpty) {
        print("recipes is empty");
        emit(RecipeByCategoryEmpty());
      } else {
        emit(RecipeByCategoryLoaded(recipes));
      }

      print("recipes : $recipes");
    });
    on<SearchRecipeEvent>((event, emit) async {
      emit(RecipeLoading());
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = Api.searchRecipes(event.query, token!);
      List<AllRecipe> recipes = [];
      final responseValue = await response;
      recipes = responseValue;
      emit(RecipeLoaded(recipes));
    });

    on<RecipeLikeEvent>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = Api.reaction(
        event.recipeId,
        event.userId,
        event.type,
        token!,
      );
      final responseValue = await response;
      if (responseValue.type == "like") {
        emit(RecipeLiked());
      } else {
        emit(RecipeNotliked());
      }
    });
    on<GetReactionEvent>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final userId = sharedPreferences.getInt('id_user');
      final response = Api.GetReaction(
        event.recipeId,
        userId!,
        token!,
      );
      final responseValue = await response;
      print("reaction : $responseValue");
      if (responseValue.type == "notexists") {
        emit(RecipeNotliked());
      } else {
        if (responseValue.type == "like") {
          emit(RecipeLiked());
        } else {
          emit(RecipeNotliked());
        }
      }
    });
    on<GetCommentByRecipeEvent>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = Api.getCommentByRecipe(
        event.recipeId,
        token!,
      );
      final responseValue = await response;
      print("responseValue : ${responseValue.isEmpty}");
      if (responseValue.isEmpty) {
        emit(CommentEmpty());
        return;
      } else {
        print("comment : $responseValue");
        emit(CommentLoaded(responseValue));
      }
    });
    on<CreateCommentEvent>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = Api.createComment(
        event.recipeId,
        event.content,
        token!,
      );
      final responseValue = await response;

      add(GetCommentByRecipeEvent(
        event.recipeId,
      ));
    });
    on<GetFavoriteRecipesEvent>((event, emit) async {
      emit(RecipeFavoriteLoading());
      final sharedPreferences = await SharedPreferences.getInstance();
      List<AllRecipe> recipes = [];
      final token = sharedPreferences.getString('token');
      final response = Api.getFavoriteByUser(
        token!,
      );
      final responseValue = await response;
      if (responseValue.isEmpty) {
        emit(RecipeFavoriteEmpty());
      } else {
        final List<int> recipesId =
            responseValue.map((recipe) => recipe.recipeId).toList();
        for (int id in recipesId) {
          final response = await Api.getRecipe(
            id,
            token,
          );
          AllRecipe data = await response;
          print("data : $data");
          recipes.add(data);
        }

        emit(RecipeFavoriteLoaded(recipes));
      }
    });
    on<AddFavoriteEvent>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = Api.addFav(
        event.recipeId,
        token!,
      );
      final responseValue = await response;

      add(GetFavoriteRecipesEvent());
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
            content: Text(
          'Added to favorites',
          style: FontHelper.getHeading6(color: Colors.white),
        )),
      );
     add(GetFavStatusEvent(event.recipeId));
    });
    on<DeleteRecipeFavEvent>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = Api.deleteFav(
        event.recipeId,
        token!,
      );
      final responseValue = await response;
      add(GetFavoriteRecipesEvent());
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
            content: Text(
          'Removed from favorites',
          style: FontHelper.getHeading6(color: Colors.white),
        )),
        
      );
       add(GetFavStatusEvent(event.recipeId));
    });
    on<GetFavStatusEvent>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');
      final response = await Api.getFavStatus(
        event.recipeId,
        token!,
      );
     
      emit(RecipeFavStatusLoaded(response));
    });
  }
}
