import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/search_result_page.dart';
import 'package:superheroes/resources/super_heroes_images.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/search_widget.dart';

import 'favorites_page.dart';
import 'min_symbol_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
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
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainPageStateWidget(),
        /* Align(
          alignment: Alignment.bottomCenter,
          child: ActionButton(
            text: "NEXT STATE",
            onTap: () {
              bloc.nextState();
            },
          ),
        ),*/
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SearchWidget(),
        ),
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
            return Stack(
              children: [
                InfoWithButton(
                    title: "No favorities YET",
                    subtitle: "Search and  add",
                    buttonText: "SEARCH",
                    assetImage: SuperHeroesImages.ironManAccet,
                    imageHeith: 128,
                    imageWidth: 128,
                    imageTopPadding: 20),
                 Align(
                  alignment: Alignment.bottomCenter,
                  child: ActionButton(
                      text: "Remove Favorite", onTap: bloc.removeFavorite),
                ),
              ],
            );
          case MainPageState.favorites:
            /*return FavoritesPage();*/
            return Stack(
              children: [
                SuperHeroesList(
                    title: "Your Faforites",
                    stream: bloc.observFavoriteSuperHeroes()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ActionButton(
                      text: "Remove Favorite", onTap: bloc.removeFavorite),
                ),
              ],
            );

          case MainPageState.minSymbols:
            return MinSymbolPage();

          case MainPageState.searchResult:
            /*return SearchResult();*/
            return SuperHeroesList(
                title: "Search Result",
                stream: bloc.observSearchedSuperHeroes());
          case MainPageState.nothingFound:
            return InfoWithButton(
                title: "Nothing found",
                subtitle: "Search for something else",
                buttonText: "SEARCH",
                assetImage: SuperHeroesImages.hulkAccet,
                imageHeith: 106,
                imageWidth: 128,
                imageTopPadding: 20);
          case MainPageState.loadingError:
            return InfoWithButton(
                title: "Error happened",
                subtitle: "Please, try agayn",
                buttonText: "RETRY",
                assetImage: SuperHeroesImages.supermenAccet,
                imageHeith: 106,
                imageWidth: 128,
                imageTopPadding: 20);

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
      /*    alignment: Alignment.topCenter,*/
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
