import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/Api.dart';
import '../../../model/category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CategoryLoad>((event, emit)  async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('token');

     
      emit(CategoryLoading());
     await  Api.getCategories(token!).then((value) {

        emit(CategoryLoaded(value));
      });
      
    });
  }
}
