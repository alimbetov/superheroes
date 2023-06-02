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

import 'package:http/http.dart' as http;
class MainPage extends StatefulWidget {

  final http.Client? client;

  const MainPage({Key? key, this.client}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late MainBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   bloc=MainBloc(client: widget.client);

  }



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

class MainPageContent extends StatefulWidget {
  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  late FocusNode searchFieldFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchFieldFocusNode= FocusNode();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainPageStateWidget(searchFieldFocusNode: searchFieldFocusNode,),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SearchWidget(searchFieldFocusNode: searchFieldFocusNode,),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchFieldFocusNode.dispose();
  }
}

class MainPageStateWidget extends StatelessWidget {
  final FocusNode searchFieldFocusNode;

  const MainPageStateWidget({super.key, required this.searchFieldFocusNode});

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
            return NoFavoritesWiget(searchFieldFocusNode: searchFieldFocusNode,);
            /*  return NoFavoritesPage();*/
         /*   return Stack(
              children: [
                InfoWithButton(
                    title: "No favorities YET",
                    subtitle: "Search and  add",
                    buttonText: "SEARCH",
                    assetImage: SuperHeroesImages.ironManAccet,
                    imageHeith: 128,
                    imageWidth: 128,
                    imageTopPadding: 20,
                    onTap: (){},),
                 Align(
                  alignment: Alignment.bottomCenter,
                  child: ActionButton(
                      text: "Remove Favorite", onTap: bloc.removeFavorite),
                ),
              ],
            );
        */
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
            return NothingFoundWidget(searchFieldFocusNode: searchFieldFocusNode,);
          case MainPageState.loadingError:
            return loadingErrorWidget(searchFieldFocusNode: searchFieldFocusNode,);

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

class NothingFoundWidget extends StatelessWidget {
  final FocusNode searchFieldFocusNode;
  const NothingFoundWidget({Key? key, required this.searchFieldFocusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child:    InfoWithButton(
      title: "Nothing found",
      subtitle: "Search for something else",
      buttonText: "SEARCH",
      assetImage: SuperHeroesImages.hulkAccet,
      imageHeith: 106,
      imageWidth: 128,
      imageTopPadding: 20,
      onTap: ()=>searchFieldFocusNode.requestFocus(),),
    );
  }
}


class loadingErrorWidget extends StatelessWidget {
  final FocusNode searchFieldFocusNode;
  const loadingErrorWidget({Key? key, required this.searchFieldFocusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return  Center(
      child:    InfoWithButton(
        title: "Error happened",
        subtitle: "Please, try agayn",
        buttonText: "RETRY",
        assetImage: SuperHeroesImages.supermenAccet,
        imageHeith: 106,
        imageWidth: 128,
        imageTopPadding: 20,
        onTap: bloc.retry,),
    );
  }
}

class NoFavoritesWiget extends StatelessWidget {
  final FocusNode searchFieldFocusNode;
  const NoFavoritesWiget({Key? key, required this.searchFieldFocusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = Provider.of<MainBloc>(context);
    return  Center(
      child:
      Stack(
        children: [
          InfoWithButton(
            title: "No favorities YET",
            subtitle: "Search and  add",
            buttonText: "SEARCH",
            assetImage: SuperHeroesImages.ironManAccet,
            imageHeith: 128,
            imageWidth: 128,
            imageTopPadding: 20,
            onTap: (){},),
          Align(
            alignment: Alignment.bottomCenter,
            child: ActionButton(
                text: "Remove Favorite",
                onTap: () => searchFieldFocusNode.requestFocus()),
          ),
        ],
      ),
    );
  }
}
