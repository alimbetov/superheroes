import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';

class SuperHeroPage extends StatelessWidget {
  String heroName;

  SuperHeroPage({required this.heroName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperHeroesColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: SizedBox(
              height: 230,
            )),
            Center(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "${heroName}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
                child: SizedBox(
              height: 100,
            )),
            GestureDetector(
              child: Container(
                width: 200,
                height: 40,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    color: SuperHeroesColors.circColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 2,
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 20, right: 20),
                  child: Text("Back", style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700
                  ),),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
