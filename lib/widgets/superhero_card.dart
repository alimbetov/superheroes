import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/model/alignment_Info.dart';
import 'package:superheroes/resources/super_heroes_images.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:superheroes/widgets/alignment_wiget.dart';

class SuperHeroCard extends StatelessWidget {
  // String name;
//  String realName;
  // String iMageUrl;
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  SuperHeroCard(
      {required this.superheroInfo,
      required this.onTap}); // SuperHeroCard({required this.name, required this.realName, required this.iMageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            _AvatarWidget(superheroInfo: superheroInfo),
           SizedBox(height: 12,),
           Expanded(child: DecoratedBox(
              decoration: const BoxDecoration(
                color: SuperHeroesColors.backgroundfaforites,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: NameAndRealNameWiget(superheroInfo: superheroInfo),
              ),
            ),
           ),
            if (superheroInfo.alignmentInfo != null)
              AlignmentWiget(alignmentinfo: superheroInfo.alignmentInfo!,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )),
          ],
        ),
      ),
    );
  }
}


class NameAndRealNameWiget extends StatelessWidget {
  const NameAndRealNameWiget({
    super.key,
    required this.superheroInfo,
  });

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${superheroInfo.name}",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Text(
            "${superheroInfo.realName}",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    super.key,
    required this.superheroInfo,
  });

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      height: 70,
      width: 70,
      child: CachedNetworkImage(
          imageUrl: superheroInfo.imageUrl,
          progressIndicatorBuilder: (context, url, progress) {
            return Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: SuperHeroesColors.blue,
                value: progress.progress,
              ),
            );
          },
          height: 70,
          width: 70,
          fit: BoxFit.fitWidth,
          errorWidget: (context, url, error) {
            return Center(
                child: Image.asset(
              SuperHeroesImages.unknownAccet,
              height: 62,
              width: 20,
              fit: BoxFit.cover,
            ));
          }),
    );
  }
}
