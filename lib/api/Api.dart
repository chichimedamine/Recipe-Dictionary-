import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:recipe_dictionary/model/reaction.dart';
import 'package:recipe_dictionary/model/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/allrecipe.dart';
import '../model/category.dart';
import '../model/comment.dart';
import '../model/favorite.dart';
import '../model/favstatus.dart';
import '../model/login.dart';

class Api {
  static const String baseUrl = 'http://192.168.100.5:8000/api';
//
  static const String loginEndpoint = '/login';
  static const String categoriesEndpoint = '/categories';
  static const String registerEndpoint = '/register';
  static const String recipesEndpoint = '/recipes';
  static const String searchEndpoint = '/search';
  static const String reactionEndpoint = '/reaction';
  static const String commentEndpoint = '/comment';
  static const String favoritesEndpoint = '/favs';
  static const String favoritesStatusEndpoint = '/favs/status';

  static Future<LoginResponse> login(String email, String password) async {
    const url = '$baseUrl$loginEndpoint';
    final data = {'email': email, 'password': password};

    print('Requesting: $url');
    print('Body: $data');

    final response = await http.post(Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
        body: data);

    if (response.statusCode == 302) {
      print('Redirect occurred: ${response.headers['location']}');
      throw Exception('Redirected to ${response.headers['location']}');
    } else if (response.statusCode != 200) {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception(
          'Failed to login with status code: ${response.statusCode}');
    }
    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  static Future<http.Response> register( String name ,
      String email, String password) async {
    final response =
        await http.post(Uri.parse('$baseUrl$registerEndpoint'), headers: {
      'Accept': 'application/json',
    }, body: {
      'name': name,
      'email': email,
      'password': password
    });
    return response;
  }

  static Future<http.Response> logout(String token) async {
    final response =
        await http.post(Uri.parse('$baseUrl$loginEndpoint/logout'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return response;
  }

  static Future<List<AllRecipe>> getRecipes(String token) async {
    final response =
        await http.get(Uri.parse('$baseUrl$recipesEndpoint'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // Check if the response is a List
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((recipe) => AllRecipe.fromJson(recipe)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  static Future<AllRecipe> getRecipe(int id , String token) async {
    
    final response = await http.get(Uri.parse('$baseUrl$recipesEndpoint/$id' ,),headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print("status code : ${response.statusCode}");
    if(response.statusCode != 200){
      
    }else{
      print("recipe response : ${jsonDecode(response.body)}");
    }
    return AllRecipe.fromJson(jsonDecode(response.body));
  }

  static Future<http.Response> createRecipe(
      String title,
      String description,
      String ingredients,
      int categoryid,
      File image,
      String username,
      String token) async {
    var pic = http.MultipartFile.fromPath(
      'image',
      image.path,
    );
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl$recipesEndpoint' ,))
          ..fields['title'] = title
          ..fields['description'] = description
          ..fields['ingredients'] = ingredients
          ..fields['instructions'] = 'test' // Ensure this is set correctly
          ..fields['category_id'] = categoryid.toString()
          ..fields['username'] = username // Ensure this is correctly passed
          ..files.add(await pic)
          ..headers['Authorization'] = 'Bearer $token'
          ..headers['Accept'] = 'application/json';

    final response = await request.send();

    return http.Response.fromStream(response);
  }

  static Future<http.Response> updateRecipe(int id, String title,
      String description, List<String> ingredients) async {
    final response =
        await http.put(Uri.parse('$baseUrl$recipesEndpoint/$id'), headers: {
      'Accept': 'application/json',
    }, body: {
      'title': title,
      'description': description,
      'ingredients': ingredients
    });
    return response;
  }

  static Future<http.Response> deleteRecipe(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl$recipesEndpoint/$id'));
    return response;
  }

  static Future<List<CategoryRecipe>> getCategories(String token) async {
    final response =
        await http.get(Uri.parse('$baseUrl$categoriesEndpoint'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print("status categroy code: ${response.statusCode}");
    if (response.statusCode == 200) {
      // Check if the response is a List
      print(response.body);
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((category) => CategoryRecipe.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<AllRecipe>> getRecipesByCategory(
      int categoryId, String token) async {
    final response = await http.get(headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, Uri.parse('$baseUrl$recipesEndpoint/category/$categoryId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((recipe) => AllRecipe.fromJson(recipe)).toList();
    } else {
      throw Exception('Failed to load recipes by category');
    }
  }

  static Future<Reaction> reaction(
      int recipeId, int userId, String type, String token) async {
    final response = await http.post(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      Uri.parse('$baseUrl$reactionEndpoint/$recipeId'),
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'recipe_id': recipeId,
        'type': type
      }),
    );
    return Reaction.fromJson(jsonDecode(response.body));
  }

  static Future<Reaction> GetReaction(
      int recipeId, int userId, String token) async {
    print("parameters : $recipeId , $token");
    final response = await http.get(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      Uri.parse('$baseUrl$reactionEndpoint/$recipeId?user_id=$userId'),
    );
    print("status code : ${response.statusCode}");
    if (response.statusCode == 200) {
      print("reaction : ${jsonDecode(response.body)}");
    }

    return Reaction.fromJson(jsonDecode(response.body));
  }

  static Future<List<AllRecipe>> searchRecipes(
      String query, String token) async {
    final response = await http.get(headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, Uri.parse('$baseUrl$searchEndpoint?search=$query'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((recipe) => AllRecipe.fromJson(recipe)).toList();
    } else {
      throw Exception('Failed to search recipes');
    }
  }
  static Future<List<Comment>> getCommentByRecipe(int recipeId, String token) async {
    final response = await http.get(headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, Uri.parse('$baseUrl$commentEndpoint/$recipeId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((comment) => Comment.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to get comments by recipe');
    }
  }

  static Future<Comment> createComment(
      int recipeId, String content, String token) async {
    final response = await http.post(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      Uri.parse('$baseUrl$commentEndpoint'),
      body: jsonEncode(<String, dynamic>{
        'recipe_id': recipeId,
        'comment': content
      }),
    );
    return Comment.fromJson(jsonDecode(response.body));
  }

  static Future<List<Favorite>> getFavoriteByUser( String token) async {
    final response = await http.get(headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, Uri.parse('$baseUrl$favoritesEndpoint'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((favorite) => Favorite.fromJson(favorite)).toList();
    } else {
      throw Exception('Failed to get favorite by user');
    }
  }
  static Future<Favorite> addFav(int recipeId, String token) async {
    final response = await http.post(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      Uri.parse('$baseUrl$favoritesEndpoint/$recipeId'),
    );

   
      return Favorite.fromJson(jsonDecode(response.body));
    
  }

  static Future<http.Response> deleteFav(int recipeId, String token) async {
    final response = await http.delete(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      Uri.parse('$baseUrl$favoritesEndpoint/$recipeId'),
    );
    if (response.statusCode == 200) {
      return response;
      
    }else{
      throw Exception('Failed to delete favorite');
    }
    
  }
  static Future<FavStatus> getFavStatus(int recipeId, String token) async {
    final response = await http.get(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      Uri.parse('$baseUrl$favoritesStatusEndpoint/$recipeId'),
    );

      return FavStatus.fromJson(jsonDecode(response.body));
    
  }
  


}
