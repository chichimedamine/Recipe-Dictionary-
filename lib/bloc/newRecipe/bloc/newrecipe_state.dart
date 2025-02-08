part of 'newrecipe_bloc.dart';

@immutable
sealed class NewrecipeState {}

final class NewrecipeInitial extends NewrecipeState {
   final List<CategoryRecipe> categories;

  NewrecipeInitial(this.categories);
}

final class NewrecipeLoading extends NewrecipeState {}

final class NewrecipeLoaded extends NewrecipeState {
 
}

final class NewrecipeError extends NewrecipeState {}

final class NewrecipeSuccess extends NewrecipeState {}

final class NewrecipeFailure extends NewrecipeState {}
