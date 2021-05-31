import 'package:flutter/material.dart';
import 'PokeHub.dart';
import 'PokeDetail.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

void main(List<String> args) {
  return runApp(MaterialApp(
      title:"Pokemon App",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));
}

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  var url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  PokeHub pokeHub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(Uri.parse(url));
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("PokeMon Hub"),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body:pokeHub==null?
      Center(child: CircularProgressIndicator(),)
      :GridView.count(
        crossAxisCount: 2,
        children: pokeHub.pokemon.map(
          (poke)=>Padding(padding: EdgeInsets.all(2),
            child: InkWell(
              onTap:()=>{
                Navigator.push(context,MaterialPageRoute(builder: (context)=>PokeDetail(pokemon:poke)))
              },
              child:Hero(
                tag:poke.img,
                child: Card(
                    child: Column(
                      children:[Text(
                                    poke.name,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    decoration:BoxDecoration(
                                      image:DecorationImage(fit: BoxFit.cover,image: NetworkImage(poke.img))
                                    )
                                  )
                                ],
                              ),
                            ),
              ),
            )
          )
          ).toList()
      )
    );
  }
}