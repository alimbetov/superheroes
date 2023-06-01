import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController txtcontroller = TextEditingController();
  bool haveSearhText = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      txtcontroller.addListener(() {
        bloc.updateText(txtcontroller.text);
        final haveText=txtcontroller.text.isNotEmpty;
        if (haveSearhText!=haveText){
          setState(() {
            haveSearhText=haveText;
          });

        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return TextField(
      controller: txtcontroller,
      // onChanged: (text) {},
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white),
      decoration: InputDecoration(
          filled: true,
          fillColor: SuperHeroesColors.indigo75,
          isDense: true,
          prefixIcon: Icon(Icons.search, color: Colors.white54, size: 24),
          suffix: GestureDetector(
            child: Icon(Icons.clear, color: Colors.white, size: 24),
            onTap: () {
              setState(() {
                txtcontroller.clear();
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:haveSearhText
                  ? BorderSide( color: Colors.white, width: 2,)
                  : BorderSide( color: Colors.white24,),

          )),
      cursorColor: Colors.white,
    );
  }
}
