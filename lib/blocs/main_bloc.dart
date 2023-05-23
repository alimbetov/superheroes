import 'dart:async';

import 'package:rxdart/rxdart.dart';

class MainBloc {


  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();

  StreamSubscription<MainPageState>? streamSubscription;

   MainBloc(){
     stateSubject.add(MainPageState.noFavorites);
   }

  Stream<MainPageState> observeMainPageState () => stateSubject;
/*  {
return Stream.periodic(Duration(seconds: 2), (tick) => tick )
.map((tick) => MainPageState.values[(tick % MainPageState.values.length )]);
  }*/

  void nextState(){
    print("TAP");
final currentState =stateSubject.value;
final nextState = MainPageState.values[
(MainPageState.values.indexOf(currentState) + 1) %
    MainPageState.values.length];

stateSubject.add(nextState);
    }

   





  void dispose(){
    stateSubject.close();
    streamSubscription?.cancel();
  }
}

enum  MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResult,
  favorites,

}