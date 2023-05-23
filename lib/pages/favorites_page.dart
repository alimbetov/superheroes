import 'package:flutter/material.dart';
import 'package:superheroes/pages/super_hero_pages.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../resources/super_heroes_images.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 114,
        ),
        Text(
          "Your Faforites",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
        ),

        SuperHeroCard(name: "BATMAN",realName: "Bruce Wayne", iMageUrl: SuperHeroesImages.batmanUrl,onTap: (){

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SuperHeroPage(heroName: 'BATMAN',),
          ));


        }),
        SuperHeroCard(name: "IRONMAN",realName: "Tony Stark", iMageUrl: SuperHeroesImages.ironmanUrl,onTap: (){

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SuperHeroPage(heroName: 'IRONMAN',),
          ));


        }),

 /*       Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 16),
          child: Row(
            children: [
              Image.network(
                width: 70,
                height: 70,
                'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 70,
                width: 258,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: SuperHeroesColors.backgroundfaforites,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "BATMAN",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text(
                            "Bruce Wayne",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ],),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 16),
          child: Row(
            children: [
              Image.network(
                width: 70,
                height: 70,
                'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 70,
                width: 258,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: SuperHeroesColors.backgroundfaforites,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "IRONMAN",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text(
                            "Tony Stark",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      */
      ],
    );
  }
}
