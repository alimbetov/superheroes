import 'package:flutter/material.dart';
import 'package:superheroes/resources/super_heroes_images.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class NoFavoritesPage extends StatelessWidget {
  const NoFavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 108.0,
                    width: 108.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFe0f2f1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            SuperHeroesImages.ironManAccet,
                          ),
                          fit: BoxFit.contain,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "No favorities YET",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Search and  add",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              ActionButton(text: "SEARCH", onTap: () {}),
            ],
          ),
        ],
      ),
    ));
  }

}
