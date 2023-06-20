
import 'package:flutter/material.dart';
import 'package:superheroes/model/alignment_Info.dart';



class AlignmentWiget extends StatelessWidget {
  final AlignmentInfo alignmentinfo;
final BorderRadius borderRadius;
  const AlignmentWiget({Key? key, required this.alignmentinfo, required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: 1,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          height: 24,
          width: 70,
          decoration: BoxDecoration(
            color: alignmentinfo.color,
            borderRadius: borderRadius
          ),
          alignment: Alignment.center,
          child: Text(
            alignmentinfo.name,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ));
  }
}
