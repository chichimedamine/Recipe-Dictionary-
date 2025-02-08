import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:recipe_dictionary/components/Animatedbar.dart';
import 'package:recipe_dictionary/model/category.dart';
import 'package:recipe_dictionary/view/NewRecipe.dart';
import 'package:recipe_dictionary/view/login.dart';
import 'package:recipe_dictionary/view/recipe.dart';
import 'package:recipe_dictionary/view/recipesbycategory.dart';

import '../bloc/category/bloc/category_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/recipe/bloc/recipe_bloc.dart';
import '../helpers/colorshelper.dart';
import '../helpers/fonthelper.dart';
import '../model/allrecipe.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<RecipeBloc>().add(GetRecipeEvent());
        },
        color: ColorHelper.white,
        backgroundColor: ColorHelper.primaryColor,
        child: Scaffold(
          backgroundColor: ColorHelper.primaryColor,
          appBar: AppBar(
            titleSpacing: 30,
            backgroundColor: ColorHelper.primaryColor,
            title: AnimatedSwitcher(
              switchInCurve: Curves.easeIn,
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                'assets/images/applogo.webp',
                width: 90,
                height: 90,
              ),
            ),
            centerTitle: true,
            leading: const SizedBox(),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.logOut),
                color: Colors.white,
                onPressed: () {
                  context.read<AuthBloc>().add(LoginLogout(context: context));
                  // Perform logout action
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NewRecipeView()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.white,
                            ),
                            foregroundColor: ColorHelper.primaryColor,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.all(0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            minimumSize: const Size(40, 40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "New Recipe",
                                style: FontHelper.getBodyText(
                                    color: ColorHelper.primaryColor),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                LucideIcons.plus,
                                color: ColorHelper.primaryColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Categories',
                    style: FontHelper.getHeading2(),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoaded) {
                        return SizedBox(
                          height: 50,
                          width: 500,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemExtent: 120,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RecipesByCategory(
                                                  id: state
                                                      .categories[index].id,
                                                  categoryName: state
                                                      .categories[index].name),
                                        ),
                                      );
                                    },
                                    child: buildCategoryCard(
                                        state.categories[index])),
                              );
                            },
                          ),
                        );
                      }
                      return LoadingAnimationWidget.waveDots(
                        color: Colors.white,
                        size: 100,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Last Recipes',
                    style: FontHelper.getHeading2(),
                  ),
                  const SizedBox(height: 10),
                  AnimatedBar(),
                  const SizedBox(height: 10),
                  BlocBuilder<RecipeBloc, RecipeState>(
                    builder: (context, state) {
                      if (state is RecipeLoaded) {
                        if (state.recipes.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                const Icon(
                                  LucideIcons.ban,
                                  size: 60,
                                  color: ColorHelper.black,
                                ),
                                Text(
                                  'No recipes found',
                                  style: FontHelper.getHeading3(),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: 300,
                            width: 500,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemExtent: 120,
                              itemCount: state.recipes.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RecipeView(
                                                        recipe: state
                                                            .recipes[index]),
                                              ),
                                            );
                                          },
                                          child: buildRecipeCard(
                                              state.recipes[index]))
                                      .animate()
                                      .moveX(
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      )
                                      .shake(
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      ),
                                );
                              },
                            ),
                          );
                        }
                      }
                      return Center(
                        child: LoadingAnimationWidget.waveDots(
                          color: Colors.white,
                          size: 100,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildRecipeCard(AllRecipe recipe) {
  return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            '${recipe.image}',
            scale: 2,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 3,
          color: ColorHelper.white,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Card(
                    child: Center(
                      child: Text(
                        recipe.title,
                        style: FontHelper.getHeading5(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                /*  Text(
                  'By ${recipe.title}',
                  style: FontHelper.getSmallText(color: Colors.white),
                ),*/
              ],
            ),
          ),
        ],
      ));
}

Widget buildCategoryCard(CategoryRecipe category) {
  return Container(
    height: 30,
    decoration: BoxDecoration(
      color: ColorHelper.primaryColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        width: 3,
        color: ColorHelper.white,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: FontHelper.getHeading6(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
