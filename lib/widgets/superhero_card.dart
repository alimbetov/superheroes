import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';

class SuperHeroCard extends StatelessWidget {
 // String name;
//  String realName;
 // String iMageUrl;
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  SuperHeroCard({ required this.superheroInfo,
    required this.onTap}); // SuperHeroCard({required this.name, required this.realName, required this.iMageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 70,
        clipBehavior: Clip.antiAlias,
       // padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SuperHeroesColors.indigo,
        ),
        child: Row(
          children: [
            Image.network(
              width: 70,
              height: 70,
              superheroInfo.imageUrl,
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
                        "${superheroInfo.name}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      Text(
                        "${superheroInfo.realName}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
