import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/shared/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalDatasource {
  SharedPreferences sharedPreferences;
  LocalDatasource(this.sharedPreferences);

  final String listKey = 'favourites';

  List<String> fetchFavouritesList() {
    return sharedPreferences.getStringList(listKey) ?? [];
  }

  Future<bool> saveToFavouritesList(String id) async {
    List<String> list = fetchFavouritesList();
    if (!list.contains(id)) {
      list.add(id);
    }

    return await sharedPreferences.setStringList(listKey, list);
  }

  bool checkIfFavourite(String id) =>
      sharedPreferences.getStringList(listKey)?.contains(id) ?? false;

  Future<bool> removeFromFavourites(String id) async {
    List<String> list = fetchFavouritesList();
    if (list.contains(id)) {
      list.remove(id);
    }

    return await sharedPreferences.setStringList(listKey, list);
  }
}
