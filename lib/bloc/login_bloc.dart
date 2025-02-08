import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:meta/meta.dart';
import 'package:recipe_dictionary/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/Api.dart';
import '../helpers/colorshelper.dart';
import '../helpers/fonthelper.dart';
import '../view/homepage.dart';

part 'login_event.dart';
part 'login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoginInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoginStarted>((event, emit) async {
      emit(LoginLoading());
      try {
        print("${event.username} ${event.password}");
        final loginResponse = await Api.login(event.username, event.password);

        print("after login");
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', loginResponse.token);
        await prefs.setString('username', loginResponse.user.name);
        await prefs.setString('email', loginResponse.user.email);
        await prefs.setInt('id_user', loginResponse.user.id);

        emit(LoginSuccess());
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } on Exception catch (e) {
        print(e);
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text('Login failed, please check your credentials',
                style: FontHelper.getBodyText(color: Colors.white)),
            elevation: 10,
            backgroundColor: ColorHelper.primaryColor,
          ),
        );
        emit(LoginError());
      }
    });
    on<LoginLogout>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final logoutResponse = await Api.logout(token!).whenComplete(() {
        Navigator.pushAndRemoveUntil(
            event.context,
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ),
            (route) => false);
        prefs.remove('token');
        prefs.remove('username');
        prefs.remove('email');
        prefs.remove('id_user');

        emit(LoginLoggedOut());
      });
    });
    on<RegisterStarted>((event, emit) async {
      try {
        final response =
            await Api.register(event.fullname, event.email, event.password);
        emit(RegisterSuccess());
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.check, color: Colors.white),
                Text('Register success',
                    style: FontHelper.getBodyText(color: Colors.white)),
              ],
            ),
            elevation: 10,
            backgroundColor: ColorHelper.primaryColor,
          ),
        );
        Navigator.pop(event.context);
      } on Exception catch (e) {
        emit(RegisterError());
      }
    });
  }
}
