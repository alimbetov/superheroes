import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/pages/main_bloc.dart';
import 'package:superheroes/pages/no_favorites_page.dart';
import 'package:superheroes/pages/search_result_page.dart';
import 'package:superheroes/resources/super_heroes_images.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:superheroes/widgets/info_with_button.dart';

import 'favorites_page.dart';
import 'min_symbol_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

/*class MainBlocHolder extends InheritedWidget{
  final MainBloc bloc;

  MainBlocHolder({required final  Widget child, required this.bloc }): super(child: child) ;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)=> false;

  static MainBlocHolder of(final BuildContext context) {
    final InheritedElement element =
        context.getElementForInheritedWidgetOfExactType<MainBlocHolder>()!;
    return element.widget as MainBlocHolder;
  }
}*/




class _MainPageState extends State<MainPage> {
  final bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value:bloc,
      child: Scaffold(
        backgroundColor: SuperHeroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),

    );
  }

  @override
  void dispose() {
    bloc.dispose();
  }
}

class MainPageContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    MainBloc bloc = Provider.of<MainBloc>(context);

    return Stack(

      children: [
        MainPageStateWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(

            onTap: () {
              bloc.nextState();
            },





            child: ColoredBox(
              color: SuperHeroesColors.blue,
              child: Container(
                height: 30,
                width: 150,
                child: Center(
                  child: Text(
                    "Next State",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    MainBloc bloc = Provider.of<MainBloc>(context);

    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        }
        final MainPageState? state = snapshot.data;
        switch (state) {
          case MainPageState.loading:
            return LoadingIndicator();
          case MainPageState.noFavorites:
          /*  return NoFavoritesPage();*/
            return InfoWithButton(
                title: "No favorities YET",
                subtitle:"Search and  add" ,
                buttonText: "SEARCH",
                assetImage: SuperHeroesImages.ironManAccet,
                imageHeith: 128,
                imageWidth: 128,
                imageTopPadding: 20 );
          case MainPageState.minSymbol:
          return MinSymbolPage();
          case MainPageState.favorites:
            return FavoritesPage();
          case MainPageState.searchResult:
            return SearchResult();
          case MainPageState.nothingFound:
            return InfoWithButton(
                title: "Nothing found",
                subtitle:"Search for something else" ,
                buttonText: "SEARCH",
                assetImage: SuperHeroesImages.ironManAccet,
                imageHeith: 128,
                imageWidth: 128,
                imageTopPadding: 20 );
          case MainPageState.loadingError:
            return InfoWithButton(
                title: "Error happened",
                subtitle:"Please, try agayn" ,
                buttonText: "RETRY",
                assetImage: SuperHeroesImages.ironManAccet,
                imageHeith: 128,
                imageWidth: 128,
                imageTopPadding: 20 );

          default:
            return Center(
                child: Text(
              state.toString(),
              style: TextStyle(color: Colors.white),
            ));
        }
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          color: SuperHeroesColors.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
