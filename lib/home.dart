import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:recipe_app/RecipeView.dart';
import 'package:recipe_app/modal.dart';
import 'package:recipe_app/search.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel> [];
  TextEditingController searchController = new TextEditingController();
  List reciptCatList = [{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"}];

  void getRecipe(String query) async{
    String url = "https://api.edamam.com/search?q=$query&app_id=ac822531&app_key=c870d47ac38564939586093483332b03&from=0&to=3&calories=591-722&health=alcohol-free";
    Response response = await get(Uri.parse(url) as Uri);
    Map data = jsonDecode(response.body);

    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel =  RecipeModel();
        recipeModel = (RecipeModel.fromMap(element["recipe"]));
        recipeList.add(recipeModel);
        setState(() {
          isLoading = false;
        });
        log(recipeList.toString());

      });
    });
    recipeList.forEach((Recipe){
      print(Recipe.applabel);
      print(Recipe.appcalories);

    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("Ladoo");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffb9d0c7),Color(0xffcfd193),Color(0xffbdaccc)]
              )
            ),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: Container( //Search wala Container
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      margin: EdgeInsets.fromLTRB(15, 20, 14, 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              if((searchController.text).replaceAll(" ","") == ""){
                                print("Blank Search");
                              }else{
                                Navigator.push(context,MaterialPageRoute(builder: (context) => Search(searchController.text)));
                              }
                            },
                            child: Container(child: Icon(Icons.search,color: Colors.white,),
                              margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Let's Cook Recipe Name",
                                hintStyle: TextStyle(fontSize: 20,color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("WHAT DO YOU WANT TO COOK TODAY?",
                          style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6,),
                        Text("Let's Cook Something New!",
                          style: TextStyle(fontSize: 24,color: Colors.white,),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: isLoading ? CircularProgressIndicator() : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: recipeList.length,
                        itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => RecipeView(recipeList[index].appurl)));

                            },
                            child: Card(
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 46.0,
                              child: Stack(
                                children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      recipeList[index].appimgUrl,
                                      fit:BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),

                                  Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.black26
                                          ),
                                          child: Text(recipeList[index].applabel,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                      )
                                  ),

                                  Positioned(
                                      right: 0,
                                      width: 80,
                                      height: 40,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)
                                            )
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.local_fire_department,size: 20,),
                                                Text(recipeList[index].appcalories.toString().substring(0,7)),
                                              ],
                                            ),
                                          )
                                      )
                                  ),

                                ],
                              ),
                            ),
                          );
                        }),
                  ),

                  Container(
                    height: 100,
                    child: ListView.builder(
                        itemCount: reciptCatList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => Search(reciptCatList[index]["heading"])));
                                },
                                child: Card(
                                    margin: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    elevation: 0.0,
                                    child:Stack(
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(18.0),
                                            child: Image.network(reciptCatList[index]["imgUrl"], fit: BoxFit.cover,
                                              width: 200,
                                              height: 250,)
                                        ),
                                        Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            top: 0,
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.black26),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      reciptCatList[index]["heading"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 28),
                                                    ),
                                                  ],
                                                ))),
                                      ],
                                    )
                                ),
                              )
                          );
                        }),
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}






/*




            InkWell ---- Tap,DoubleTap (hover- change color,Splash color on Tap) [show off jyada karta h kaam kam]
            Gesture Detector ---- swipe && other etc [kaam jyada karta show off kam]
            Card ---- elevation ,background color, radius child
            ClipRRect ---- Clip Round Rectangle (Frame - photo)
            ClipPath ---- other frame like circle, triangle etc bana sakte h isme ham [Custom Clip]
            Positioned ---- (Use in Stack) topleft,topright etc

 */