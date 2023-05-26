import 'package:flutter/material.dart';
import 'package:superheroes/pages/super_hero_pages.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../resources/super_heroes_images.dart';

/*
class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 114,
        ),
        Text(
          "Search Result",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
        ),

        SuperHeroCard(name: "BATMAN",realName: "Bruce Wayne", iMageUrl: SuperHeroesImages.batmanUrl,onTap: (){


            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SuperHeroPage(heroName: 'BATMAN',),
            ));


        },),
        SuperHeroCard(name: "VENOM",realName: "Eddie Brock", iMageUrl: SuperHeroesImages.venomUrl,onTap: (){

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SuperHeroPage(heroName: 'VENOM',),
          ));

        }),


      ],
    );
  }
}
*/
