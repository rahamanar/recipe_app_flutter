import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:http/http.dart' as http;
import 'package:recipeapp/secrets.dart';
import 'package:recipeapp/views/recipe_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Recipe> recipes = List<Recipe>();

  String ingredient;
  bool loading = false;

  getRecipes() async {
    setState(() {
      loading = false;
    });
    var recipeData = await http.get(
        "https://api.edamam.com/search?q=$ingredient&app_id=$appId&app_key=$appKey&from=0&to=3&calories=591-722&health=alcohol-free");

    Map<String, dynamic> jsonData = jsonDecode(recipeData.body);

    jsonData["hits"].forEach((recipeInfo) {
      Recipe recipe = Recipe();
      recipe = Recipe.fromMap(recipeInfo["recipe"]);
      recipes.add(recipe);
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // getRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RecipeBook🥘"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What will you cook today?",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                  "Just Enter ingredients you have and we show the best recipe for you",
                  style: TextStyle(
                    fontSize: 15,
                  )),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    onChanged: (value) => {ingredient = value},
                    decoration:
                        InputDecoration(hintText: "enter ingredient name"),
                  )),
                  GestureDetector(
                      onTap: () {
                        if (ingredient != "") {
                          recipes = [];
                          getRecipes();
                        }
                      },
                      child: Icon(Icons.search)),
                ],
              ),
              loading
                  ? Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : GridView(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      children: List.generate(recipes.length, (index) {
                        return RecipeTile(
                          imgUrl: recipes[index].imgUrl,
                          label: recipes[index].label,
                          source: recipes[index].source,
                          url: recipes[index].url,
                        );
                      }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final String label, source, imgUrl, url;

  RecipeTile({this.label, this.source, this.imgUrl, this.url});

  @override
  Widget build(BuildContext context) {
    print("$url $label $imgUrl $source");

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeView(url),
            ));
      },
      child: Container(
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imgUrl)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    source,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
