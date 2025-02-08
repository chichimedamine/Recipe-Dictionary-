import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:recipe_dictionary/helpers/extension.dart';
import 'package:recipe_dictionary/model/allrecipe.dart';
import 'package:recipe_dictionary/view/homepage.dart';
import 'package:recipe_dictionary/view/register.dart';
import 'package:recipe_dictionary/view/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/recipe/bloc/recipe_bloc.dart';
import '../helpers/colorshelper.dart';
import '../helpers/fonthelper.dart';

class RecipeView extends StatelessWidget {
  final AllRecipe recipe;

  const RecipeView({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryColor,
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            LucideIcons.arrowLeft,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 3, color: Colors.white),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        recipe.image!,
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedCrossFade(
                firstChild: Text(
                  recipe.title,
                  style: FontHelper.getLargeText(color: Colors.white),
                  textAlign: TextAlign.center,
                  key: const ValueKey('large'),
                ),
                secondChild: Text(
                  recipe.title,
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
              buildRecipeInfo(context, recipe).animate().slide(
                    duration: const Duration(seconds: 2),
                  ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildRecipeInfo(BuildContext context, AllRecipe recipe) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: BlocProvider(
      create: (context) => RecipeBloc(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.chefHat,
                        color: ColorHelper.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Recipe by",
                        style: FontHelper.getHeading4(
                          color: ColorHelper.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      recipe.username,
                      style: FontHelper.getHeading4(
                        color: ColorHelper.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              buildRectionButton(recipe.id, context),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Description',
            style: FontHelper.getHeading2(
              color: ColorHelper.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              recipe.description,
              style: FontHelper.getBodyText(
                color: ColorHelper.black,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.fade,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ingredients',
            style: FontHelper.getHeading2(
              color: ColorHelper.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              recipe.ingredients,
              style: FontHelper.getBodyText(
                color: ColorHelper.black,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
          ),
          const SizedBox(height: 20),
          /*   Text(
            'Cooking Method:',
            style: FontHelper.getBodyText(
              color: ColorHelper.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            recipe.cookingMethod,
            style: FontHelper.getBodyText(
              color: ColorHelper.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Cooking Time:',
            style: FontHelper.getBodyText(
              color: ColorHelper.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            recipe.cookingTime,
            style: FontHelper.getBodyText(
              color: ColorHelper.white,
            ),
          ),*/
        ],
      ),
    ),
  );
}

Widget buildRectionButton(int recipeId, BuildContext context) {
  return BlocProvider(
    create: (context) => RecipeBloc()..add(GetReactionEvent(recipeId)),
    child: Column(
      children: [
        BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLiked) {
              return GestureDetector(
                onTap: () async {
                  final sharedPreferences =
                      await SharedPreferences.getInstance();
                  final userId = sharedPreferences.getInt('id_user');
                  context
                      .read<RecipeBloc>()
                      .add(RecipeLikeEvent(recipeId, userId!, 'not_like'));
                },
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: ColorHelper.primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.heart,
                        color: ColorHelper.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Like",
                        style: FontHelper.getBodyText(color: ColorHelper.red),
                      ),
                    ],
                  ),
                ),
              ).animate().shake();
            }
            if (state is RecipeNotliked) {
              return GestureDetector(
                onTap: () async {
                  final sharedPreferences =
                      await SharedPreferences.getInstance();
                  final userId = sharedPreferences.getInt('id_user');
                  context
                      .read<RecipeBloc>()
                      .add(RecipeLikeEvent(recipeId, userId!, 'like'));
                },
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: ColorHelper.primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.heart,
                        color: ColorHelper.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Like",
                        style: FontHelper.getBodyText(color: ColorHelper.white),
                      ),
                    ],
                  ),
                ).animate().shake(),
              );
            }

            return const SizedBox(height: 10);
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => buildBottomSheetComment(recipeId, context),
          child: Container(
            height: 50,
            width: 120,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: ColorHelper.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.messageCircle,
                  color: ColorHelper.white,
                ),
                const SizedBox(width: 10),
                Text(
                  "Comment",
                  style: FontHelper.getBodyText(color: ColorHelper.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        BlocProvider<RecipeBloc>(
          create: (context) => RecipeBloc()..add(GetFavStatusEvent(recipeId)),
          child: BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) {
              if (state is RecipeFavStatusLoaded) {
                if (state.favStatus.fav == false) {
                  return GestureDetector(
                    onTap: () async {
                      context
                          .read<RecipeBloc>()
                          .add(AddFavoriteEvent(recipeId, context));
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: ColorHelper.primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            LucideIcons.star,
                            color: ColorHelper.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Favorite",
                            style: FontHelper.getBodyText(
                                color: ColorHelper.white),
                          ),
                        ],
                      ),
                    ).animate().shake(),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      context
                          .read<RecipeBloc>()
                          .add(DeleteRecipeFavEvent(recipeId, context));
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: ColorHelper.primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            LucideIcons.star,
                            color: ColorHelper.yellow,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Favorite",
                            style: FontHelper.getBodyText(
                                color: ColorHelper.yellow),
                          ),
                        ],
                      ),
                    ).animate().shake(),
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    ),
  );
}

buildBottomSheetComment(int recipeId, BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: ColorHelper.primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      final commentController = TextEditingController();
      return SizedBox(
          height: 600,
          child: BlocProvider(
            create: (context) =>
                RecipeBloc()..add(GetCommentByRecipeEvent(recipeId)),
            child: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                print("state now : $state");
                if (state is CommentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CommentLoaded) {
                  return Center(
                      child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Comment",
                        style: FontHelper.getHeading1(
                          color: ColorHelper.white,
                        ),
                      ),
                      const Divider(
                        color: ColorHelper.white,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                            itemCount: state.comment.length,
                            itemBuilder: (context, index) => Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            ColorHelper.primaryColor,
                                        radius: 30,
                                        child: CircleAvatar(
                                          backgroundColor: ColorHelper.white,
                                          radius: 25,
                                          child: Text(
                                            state.comment[index].username
                                                .toString()[0],
                                            style: FontHelper.getHeading1(
                                              color: ColorHelper.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        state.comment[index].username
                                            .toString()
                                            .capitalize(),
                                        style: FontHelper.getBodyText(
                                          color: ColorHelper.white,
                                        ),
                                      ),
                                      subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.comment[index].content,
                                              style: FontHelper.getBodyText(
                                                  color: ColorHelper.white),
                                              maxLines: 99,
                                            ),
                                            Text(
                                              DateFormat('dd MMMM yyyy hh:mm')
                                                  .format(DateTime.parse(state
                                                      .comment[index].createdAt
                                                      .toString())),
                                              style: FontHelper.getSmallText(
                                                  color: ColorHelper.black),
                                            )
                                          ]),
                                    ),
                                    const Divider(
                                      color: ColorHelper.white,
                                    ),
                                  ],
                                )),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: ColorHelper.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: TextField(
                                    controller: commentController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Comment",
                                      hintStyle: TextStyle(
                                          color: ColorHelper.primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: const Icon(
                                    LucideIcons.send,
                                    color: ColorHelper.primaryColor,
                                  ),
                                  onPressed: () {
                                    context.read<RecipeBloc>().add(
                                        CreateCommentEvent(
                                            recipeId, commentController.text));
                                    commentController.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ));
                } else if (state is CommentEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Comment",
                          style: FontHelper.getHeading1(
                            color: ColorHelper.white,
                          ),
                        ),
                        const Divider(
                          color: ColorHelper.white,
                        ),
                        const SizedBox(height: 20),
                        const Expanded(
                          child: Icon(
                            LucideIcons.messageCircleOff,
                            color: ColorHelper.white,
                            size: 100,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No comment yet",
                          style:
                              FontHelper.getHeading1(color: ColorHelper.white),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: ColorHelper.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: TextField(
                                      controller: commentController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Comment",
                                        hintStyle: TextStyle(
                                            color: ColorHelper.primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      LucideIcons.send,
                                      color: ColorHelper.primaryColor,
                                    ),
                                    onPressed: () {
                                      context.read<RecipeBloc>().add(
                                          CreateCommentEvent(recipeId,
                                              commentController.text));
                                      commentController.clear();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox(height: 10);
                }
              },
            ),
          ));
    },
  );
}
