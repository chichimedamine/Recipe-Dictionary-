import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:recipe_dictionary/model/allrecipe.dart';
import 'package:recipe_dictionary/model/category.dart';
import 'package:recipe_dictionary/view/homepage.dart';
import 'package:recipe_dictionary/view/recipe.dart';
import 'package:recipe_dictionary/view/register.dart';

import '../bloc/recipe/bloc/recipe_bloc.dart';
import '../helpers/colorshelper.dart';
import '../helpers/fonthelper.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryColor,
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryColor,
        leading: const SizedBox(),
        title: Text(
          "Favorite Recipes",
          style: FontHelper.getTitleAppbar(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocProvider(
          create: (context) => RecipeBloc()..add(GetFavoriteRecipesEvent()),
          child: BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) {
              if (state is RecipeByCategoryLoading) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 50,
                  ),
                );
              } else if (state is RecipeFavoriteLoaded) {
                return ListView.builder(
                  itemCount: state.recipes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RecipeView(
                              recipe: state.recipes[index],
                            ),
                          ),
                        );
                      },
                      child: RecipeItem(
                        recipe: state.recipes[index],
                      )
                          .animate()
                          .moveX(
                              duration: const Duration(seconds: 1),
                              begin: -1,
                              end: 10,
                              curve: Curves.easeInOutCubic)
                          .fade(duration: const Duration(seconds: 1)),
                    );
                  },
                );
              } else if (state is RecipeFavoriteLoading) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 50,
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                        child: Icon(
                          LucideIcons.starOff,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      Text('No favorite recipes found',
                          style: FontHelper.getHeading3(
                            color: Colors.white,
                          )),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class RecipeItem extends StatelessWidget {
  final AllRecipe recipe;

  const RecipeItem({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: CachedNetworkImageProvider(
              recipe.image!,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorHelper.primaryColor.withOpacity(0.5),
          ),
          height: 10,
          width: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: BlocProvider(
                  create: (context) =>
                      RecipeBloc()..add(GetFavStatusEvent(recipe.id)),
                  child: BlocBuilder<RecipeBloc, RecipeState>(
                    builder: (context, state) {
                      if (state is RecipeFavStatusLoaded) if (state
                              .favStatus.fav ==
                          true) {
                        return IconButton(
                            onPressed: () {
                              context.read<RecipeBloc>().add(
                                  DeleteRecipeFavEvent(recipe.id, context));
                            },
                            icon: const Icon(
                              LucideIcons.star,
                              color: ColorHelper.yellow,
                            ));
                      } else {
                        return IconButton(
                            onPressed: () {
                              context
                                  .read<RecipeBloc>()
                                  .add(AddFavoriteEvent(recipe.id, context));
                            },
                            icon: const Icon(
                              LucideIcons.star,
                              color: Colors.white,
                            ));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 2),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 3,
                        color: ColorHelper.white,
                      ),
                      color: ColorHelper.primaryColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 10),
                        child: Column(
                          children: [
                            Text(
                              recipe.title,
                              style: FontHelper.getBodyText(
                                color: ColorHelper.white,
                              ),
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat('MMM yyyy HH:mm')
                                  .format(recipe.createdAt),
                              style: FontHelper.getSmallText(
                                color: ColorHelper.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 33),
            ],
          ),
        ),
      ),
    );
  }
}
