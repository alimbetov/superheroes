


import 'package:flutter/material.dart';

class MinSymbolPage extends StatelessWidget {
  const MinSymbolPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only( left: 16, top: 134, right: 16),
   child: Align(
     alignment: Alignment.topCenter,
     child: Text("Enter aty least 3 symbols",
     style: TextStyle( fontWeight: FontWeight.w600,
       fontSize: 20,
       color: Colors.white,

     ),),
   ),
    );
  }
}
