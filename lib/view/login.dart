import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:recipe_dictionary/view/homepage.dart';
import 'package:recipe_dictionary/view/index.dart';
import 'package:recipe_dictionary/view/register.dart';

import '../bloc/login_bloc.dart';
import '../helpers/colorshelper.dart';
import '../helpers/fonthelper.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/applogo.webp',
                width: 180,
                height: 180,
              ),
              AnimatedCrossFade(
                firstChild: Text(
                  'Welcome to Recipe Dictionary',
                  style: FontHelper.getLargeText(color: Colors.white),
                  textAlign: TextAlign.center,
                  key: const ValueKey('large'),
                ),
                secondChild: Text(
                  'Welcome to Recipe Dictionary',
                  style: FontHelper.getHeading1(color: Colors.white),
                  textAlign: TextAlign.center,
                  key: const ValueKey('heading'),
                ),
                crossFadeState: MediaQuery.of(context).size.width > 600
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 500),
              ),
              const SizedBox(height: 20),
              buildForm(context),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: FontHelper.getBodyText(
                    color: ColorHelper.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterView(),
                    ),
                  );
                },
                child: Text(
                  'Register',
                  style: FontHelper.getBodyText(
                    color: ColorHelper.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildForm(BuildContext context) {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  return BlocProvider(
    create: (context) =>    AuthBloc(),
    child: Column(
      children: [
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.center,
            prefixIcon: const Icon(
              LucideIcons.atSign,
              color: ColorHelper.primaryColor,
            ),
            hintText: 'Email',
            hintStyle: FontHelper.getBodyText(color: ColorHelper.primaryColor),
            labelStyle: const TextStyle(color: ColorHelper.primaryColor),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: ColorHelper.primaryColor),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: ColorHelper.primaryColor),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              LucideIcons.lock,
              color: ColorHelper.primaryColor,
            ),
            labelStyle: const TextStyle(color: ColorHelper.primaryColor),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: ColorHelper.primaryColor),
            ),
            hintText: 'Password',
            hintStyle: FontHelper.getBodyText(color: ColorHelper.primaryColor),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: ColorHelper.primaryColor),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<  AuthBloc, AuthState>(
          builder: (context, state) {
            print("state login now: $state");
            if (state is LoginLoading) {
              return LoadingAnimationWidget.waveDots(
                color: Colors.white,
                size: 100,
              );
            } else {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  backgroundColor: ColorHelper.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.read< AuthBloc>().add(LoginStarted(
                      context: context,
                      username: usernameController.text,
                      password: passwordController.text));
                  if (state is LoginSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Index(),
                      ),
                    );
                  }
                },
                child: Text(
                  'Login',
                  style: FontHelper.getBodyText(color: ColorHelper.white),
                ),
              );
            }
          },
        ),
      ],
    ),
  );
}
