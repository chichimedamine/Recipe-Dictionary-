part of 'newrecipe_bloc.dart';

@immutable
sealed class NewrecipeEvent {}

class NewrecipeStarted extends NewrecipeEvent {}

class NewrecipeAdded extends NewrecipeEvent {
  final String title;
  final String description;
  final String ingredients;
  final int category;
  final dynamic image;
  final String username;
  final BuildContext context;


  NewrecipeAdded(
      {required this.title,
      required this.description,
      required this.ingredients,
      required this.category ,
      required this.image ,
      required this.username ,
      required this.context
        });
}

