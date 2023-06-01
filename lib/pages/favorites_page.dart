import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/super_hero_pages.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../resources/super_heroes_images.dart';

/*
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


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Your Faforites",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        SuperHeroCard(
            name: "BATMAN",
            realName: "Bruce Wayne",
            iMageUrl: SuperHeroesImages.batmanUrl,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SuperHeroPage(
                  heroName: 'BATMAN',
                ),
              ));
            }),
        SuperHeroCard(
            name: "IRONMAN",
            realName: "Tony Stark",
            iMageUrl: SuperHeroesImages.ironmanUrl,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SuperHeroPage(
                  heroName: 'IRONMAN',
                ),
              ));
            }),


      ],
    );
  }
}
*/

class SuperHeroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperHeroesList({Key? key, required this.title, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final List<SuperheroInfo> superheroes = snapshot.data!;
          return ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: superheroes.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16 , top: 90, bottom: 12),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  );
                }

                final SuperheroInfo item = superheroes[index - 1];

                return SuperHeroCard(
        /*            name: item.name,
                    realName: item.realName,
                    iMageUrl: item.imageUrl,*/
                  superheroInfo: item,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SuperHeroPage(
                          heroName: item.name,
                        ),
                      ));
                    });
              },
              separatorBuilder: (BuildContext context, int index){
                return SizedBox(height: 8,);
          }

          );


        });
  }
}
