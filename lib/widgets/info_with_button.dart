import 'package:flutter/material.dart';
import 'package:superheroes/resources/super_heroes_images.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class InfoWithButton extends StatelessWidget {


  final String title;
  final String subtitle;
  final String buttonText;
  final String assetImage;
  double imageHeith;
  double imageWidth;
  double imageTopPadding;
  final VoidCallback onTap;

  InfoWithButton(
      { required this.title, required this.subtitle, required this.buttonText,
        required this.assetImage, required this.imageHeith, required this.imageWidth,
        required this.imageTopPadding, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: imageHeith,
                        width: imageWidth,
                        decoration: BoxDecoration(
                          color: SuperHeroesColors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        top: imageTopPadding,
                        child: Container(
                          height: imageHeith,
                          width: imageWidth,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(assetImage,
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
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ActionButton(text: buttonText, onTap: onTap),
                ],
              ),
            ],
          ),
        ));
  }

}
