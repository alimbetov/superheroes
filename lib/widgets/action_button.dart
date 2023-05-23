

import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';

class ActionButton extends StatelessWidget {

  final String text;
  final VoidCallback onTap;

  const ActionButton({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 30,
        color: SuperHeroesColors.circColor,
        child: Center(
          child: Text(
            '${text}',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
