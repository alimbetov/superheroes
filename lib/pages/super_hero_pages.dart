import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/power_stats.dart';
import 'package:superheroes/resources/super_heroes_images.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:http/http.dart' as http;

import '../resources/super_heroes_icons.dart';

class SuperHeroPage extends StatefulWidget {
  final http.Client? client;
  final String id;

  const SuperHeroPage({Key? key, this.client, required this.id})
      : super(key: key);

  @override
  State<SuperHeroPage> createState() => _SuperHeroPageState();
}

class _SuperHeroPageState extends State<SuperHeroPage> {
  late SuperHeroBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = SuperHeroBloc(client: widget.client, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperHeroesColors.background,
        body: SuperHeroContent(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
  }
}

class SuperHeroContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperHeroBloc>(context, listen: false);

    return StreamBuilder(
        stream: bloc.observeSuperHero(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot == null) {
            return SizedBox.shrink();
          }

          final superHero = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SuperHeroAppBar(superHero: superHero),
              SliverToBoxAdapter(
                child: Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  if (superHero.isNotNull())
                    PowerStatsWidget(powerstats: superHero.powerstats),
                  BiographyWidget(biography: superHero.biography)
                ]),
              ),
            ],
          );
        });
  }
}

class SuperHeroAppBar extends StatelessWidget {
  final superHero;

  const SuperHeroAppBar({
    super.key,
    required this.superHero,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      primary: true,
      stretch: true,
      pinned: true,
      floating: true,
      expandedHeight: 348,
      actions: [
        /* StreamBuilder<bool>(
            stream: bloc.observeIsFavorite(),
            initialData: false,
            builder: (context, snapshot) {
              final favorite =
                  !snapshot.hasData || snapshot.data == null || snapshot.data!;
              return GestureDetector(
                onTap: () =>
                    favorite ? bloc.removeFromFavorite() : bloc.addToFavorite(),
                child: Container(
                  height: 52,
                  width: 52,
                  alignment: Alignment.center,
                  child: Image.asset(favorite
                      ? SuperHeroesIcons.starFulled
                      : SuperHeroesIcons.starEmpty,
                  height: 32,
                  width: 32,),
                ),
              );
            }),*/
        FavoriteButton(),
      ],
      backgroundColor: SuperHeroesColors.background,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(superHero.name,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 22)),
        centerTitle: true,
        background: CachedNetworkImage(
            imageUrl: superHero.image.url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color:  Colors.transparent,
              height: 62,
              width: 20,
            ),
            errorWidget: (context, url, error) {
              return Center(
                child: Image.asset(
                  SuperHeroesImages.unknownAccet,
                  height: 62,
                  width: 20,
                  fit: BoxFit.cover,
                ),
              );
            }),
      ),
    );
  }
}


class Placeholder extends StatelessWidget {
  const Placeholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperHeroBloc>(context, listen: false);

    return StreamBuilder<bool>(
        stream: bloc.observeIsFavorite(),
        initialData: false,
        builder: (context, snapshot) {
          final favorite =
              !snapshot.hasData || snapshot.data == null || snapshot.data!;
          return GestureDetector(
            onTap: () =>
                favorite ? bloc.removeFromFavorite() : bloc.addToFavorite(),
            child: Container(
              height: 52,
              width: 52,
              alignment: Alignment.center,
              child: Image.asset(
                favorite
                    ? SuperHeroesIcons.starFulled
                    : SuperHeroesIcons.starEmpty,
                height: 32,
                width: 32,
              ),
            ),
          );
        });
  }
}

class PowerStatsWidget extends StatelessWidget {
  final Powerstats powerstats;

  const PowerStatsWidget({Key? key, required this.powerstats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Text(
          "Powerstats".toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
        )),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Center(
                    child: PowerstatWidget(
              name: "intelligence",
              value: powerstats.intelligencePercent,
            ))),
            Expanded(
                child: Center(
                    child: PowerstatWidget(
              name: "strength",
              value: powerstats.strengthPercent,
            ))),
            Expanded(
                child: Center(
                    child: PowerstatWidget(
              name: "speed",
              value: powerstats.speedPercent,
            ))),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: Center(
                    child: PowerstatWidget(
              name: "durability",
              value: powerstats.durabilityPercent,
            ))),
            Expanded(
                child: Center(
                    child: PowerstatWidget(
              name: "power",
              value: powerstats.powerPercent,
            ))),
            Expanded(
                child: Center(
                    child: PowerstatWidget(
              name: "combat",
              value: powerstats.combatPercent,
            ))),
            const SizedBox(
              height: 36,
            ),
          ],
        ),
      ],
    );
  }
}

class PowerstatWidget extends StatelessWidget {
  final String name;
  final double value;

  const PowerstatWidget({Key? key, required this.name, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        ArcWidget(
          value: value,
          color: claculateColorByValue(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 17),
          child: Text(
            "${(value * 100).toInt()}",
            style: TextStyle(
                color: claculateColorByValue(),
                fontSize: 18,
                fontWeight: FontWeight.w800),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 44),
          child: Text(
            name.toUpperCase(),
            style: TextStyle(
                color: claculateColorByValue(),
                fontSize: 12,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ));
  }

  Color claculateColorByValue() {
    if (value <= 0.5) {
      return Color.lerp(Colors.red, Colors.orangeAccent, value / 0.5)!;
    } else {
      return Color.lerp(
          Colors.orangeAccent, Colors.green, (value - 0.5) / 0.5)!;
    }
  }
}

class ArcWidget extends StatelessWidget {
  final Color color;
  final double value;

  const ArcWidget({Key? key, required this.color, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArcCustumPainter(color, value),
      size: Size(66, 33),
    );
  }
}

class ArcCustumPainter extends CustomPainter {
  final double value;
  final Color color;

  ArcCustumPainter(this.color, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final paintbackgraund = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    canvas.drawArc(rect, pi, pi, false, paintbackgraund);
    canvas.drawArc(rect, pi, pi * value, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ArcCustumPainter) {
      return oldDelegate.value != value && oldDelegate.color != color;
    }
    return true;
  }
}

class BiographyWidget extends StatelessWidget {
  final Biography biography;

  const BiographyWidget({Key? key, required this.biography}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 300,
        alignment: Alignment.center,
        child: Text(
          biography.toJson().toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
