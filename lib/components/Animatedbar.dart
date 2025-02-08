import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_dictionary/bloc/recipe/bloc/recipe_bloc.dart';

import 'package:recipe_dictionary/helpers/colorshelper.dart';

class AnimatedBar extends StatelessWidget {
  AnimatedBar({
    super.key,
  });

  final TextEditingController? searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        height: 50,
        child: AnimSearchBar(
          helpText: 'Search',
          color: ColorHelper.primaryColor,
          boxShadow: true,
          closeSearchOnSuffixTap: true,
          searchIconColor: Colors.white,
          rtl: true,
          onSubmitted: (String value) {
            context.read<RecipeBloc>().add(SearchRecipeEvent(value));
          },
          width: 400,
          textController: searchController!,
          onSuffixTap: () {
            context.read<RecipeBloc>().add(GetRecipeEvent());
            setState(() {
              searchController!.clear();
            });
          },
        ),
      );
    });
  }
}
