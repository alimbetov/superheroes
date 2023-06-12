

import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';

class AlignmentInfo {
  final String name;
  final Color color;

  const AlignmentInfo._(this.name, this.color);


  static const bad = AlignmentInfo._("bad",  SuperHeroesColors.red);
  static const good = AlignmentInfo ._("good",  SuperHeroesColors.green);
  static const neutral = AlignmentInfo ._("neutral",  SuperHeroesColors.grey);


  static AlignmentInfo? fromAlignment(final String alignment){
    if (alignment=="bad"){
return bad;
    }else if (alignment=="good"){
      return good;
    }else if (alignment=="neutral"){
      return neutral;
    }
    return null;
  }
}