import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:recipe_dictionary/bloc/recipe/bloc/recipe_bloc.dart';
import 'package:recipe_dictionary/helpers/colorshelper.dart';
import 'package:recipe_dictionary/helpers/fonthelper.dart';
import 'package:recipe_dictionary/model/allrecipe.dart';
import 'package:recipe_dictionary/model/category.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/login_bloc.dart';
import '../bloc/newRecipe/bloc/newrecipe_bloc.dart';

class NewRecipeView extends StatefulWidget {
  const NewRecipeView({super.key});

  @override
  _NewRecipeViewState createState() => _NewRecipeViewState();
}

class _NewRecipeViewState extends State<NewRecipeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'New Recipe',
          style: FontHelper.getTitleAppbar(color: Colors.white),
        ),
        backgroundColor: ColorHelper.primaryColor,
      ),
      body: BlocBuilder<NewrecipeBloc, NewrecipeState>(
        builder: (context, state) {
          if (state is NewrecipeInitial) {
            return buildForm(context, state.categories);
          } else if (state is NewrecipeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

Widget buildForm(BuildContext context, List<CategoryRecipe> categories) {
  print("List categroy: $categories");
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  String? selectedCategory =
      categories.isNotEmpty ? categories.first.name : null;
  int? selectedCategoryId = categories.isNotEmpty ? categories.first.id : null;

  final uniqueCategories = categories.toSet().toList();
  if (uniqueCategories.length != categories.length) {
    throw Exception('Category names must be unique.');
  }

  bool isCategorySelected = false;
  File? image;
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 5),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        image = File(pickedImage.path);
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        image != null ? FileImage(File(image!.path)) : null,
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? pickedImage = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (pickedImage != null) {
                              setState(() {
                                image = File(pickedImage.path);
                              });
                            }
                          },
                          child: image != null
                              ? const SizedBox()
                              : const Icon(
                                  LucideIcons.camera,
                                  size: 80,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Recipe Title',
                    hintStyle:
                        FontHelper.getBodyText(color: ColorHelper.primaryColor),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorHelper.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(10),
                          value: selectedCategory,
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: ColorHelper.primaryColor,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: FontHelper.getBodyText(
                              color: ColorHelper.primaryColor),
                          onChanged: (String? newValue) {
                            setState(() {
                              for (CategoryRecipe category in categories) {
                                if (newValue == category.name) {
                                  selectedCategoryId = category.id;
                                  selectedCategory = newValue!;
                                }
                              }
                            });
                          },
                          items: uniqueCategories.map<DropdownMenuItem<String>>(
                              (CategoryRecipe category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Text(category.name),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Recipe Description',
                    hintStyle:
                        FontHelper.getBodyText(color: ColorHelper.primaryColor),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: TextFormField(
                  controller: ingredientsController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Recipe Ingredients',
                    hintStyle:
                        FontHelper.getBodyText(color: ColorHelper.primaryColor),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String username = prefs.getString('username') ?? '';

                      context.read<NewrecipeBloc>().add(NewrecipeAdded(
                            title: titleController.text,
                            description: descriptionController.text,
                            ingredients: ingredientsController.text,
                            category: selectedCategoryId!,
                            image: image,
                            username: username,
                            context: context,
                          ));
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
                    child: Text(
                      "Create Recipe",
                      style: FontHelper.getBodyText(
                          color: ColorHelper.primaryColor),
                    ),
                  )),
            ],
          ),
        ),
      );
    },
  );
}
