import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:recipe_dictionary/model/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/Api.dart';
import '../../../helpers/fonthelper.dart';

part 'newrecipe_event.dart';
part 'newrecipe_state.dart';

class NewrecipeBloc extends Bloc<NewrecipeEvent, NewrecipeState> {
  NewrecipeBloc() : super(NewrecipeInitial(const [])) {
    on<NewrecipeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<NewrecipeStarted>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      List<CategoryRecipe> categories = await Api.getCategories(token!);
      emit(NewrecipeInitial(categories));
    });
    on<NewrecipeAdded>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print("All request: $event");
      


      final response = await Api.createRecipe(event.title, event.description,
          event.ingredients, event.category, event.image , event.username , token!);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
          content: Text(
            'Recipe created',
            style: FontHelper.getHeading5(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
        Navigator.pop(event.context);
       
      } else {
         ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
          content: Text(
            'Failed to create recipe',
            style: FontHelper.getHeading5(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
       
      }
    });
  }
}
