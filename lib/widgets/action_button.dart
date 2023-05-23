import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  ActionButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: SuperHeroesColors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),

        width: 150,
        height: 40,

        child: Text(
          text.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 14,
              color: Colors.white),
        ),
      ),
    );
  }
}
