import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:recipe_dictionary/view/login.dart';

import '../bloc/login_bloc.dart';
import '../helpers/colorshelper.dart';
import '../helpers/fonthelper.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _nameController = TextEditingController();
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
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      prefixIcon: const Icon(
                        LucideIcons.atSign,
                        color: ColorHelper.primaryColor,
                      ),
                      hintText: 'Email',
                      hintStyle: FontHelper.getBodyText(
                        color: ColorHelper.primaryColor,
                      ),
                      labelStyle: const TextStyle(
                        color: ColorHelper.primaryColor,
                      ),
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
                    onChanged: (value) {
                      /*  context.read<AuthBloc>().add(
                            EmailChangedEvent(email: value),
                          );*/
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        LucideIcons.lock,
                        color: ColorHelper.primaryColor,
                      ),
                      labelStyle: const TextStyle(
                        color: ColorHelper.primaryColor,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: ColorHelper.primaryColor),
                      ),
                      hintText: 'Password',
                      hintStyle: FontHelper.getBodyText(
                        color: ColorHelper.primaryColor,
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
                    onChanged: (value) {
                      /* context.read<AuthBloc>().add(
                            PasswordChangedEvent(password: value),
                          );*/
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      prefixIcon: const Icon(
                        LucideIcons.user,
                        color: ColorHelper.primaryColor,
                      ),
                      hintText: 'Full Name',
                      hintStyle: FontHelper.getBodyText(
                        color: ColorHelper.primaryColor,
                      ),
                      labelStyle: const TextStyle(
                        color: ColorHelper.primaryColor,
                      ),
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
                    onChanged: (value) {
                      /* context.read<AuthBloc>().add(
                            NameChangedEvent(name: value),
                          );*/
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  backgroundColor: ColorHelper.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  /* context.read<AuthBloc>().add(
                        RegisterSubmitEvent(),
                      );*/
                  context.read<AuthBloc>().add(RegisterStarted(
                        context: context,
                        email: _emailController.text,
                        password: _passwordController.text,
                        fullname: _nameController.text,
                      ));
                },
                child: Text(
                  'Register',
                  style: FontHelper.getBodyText(color: ColorHelper.white),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                  );
                },
                child: Text(
                  'Login',
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
