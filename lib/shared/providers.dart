import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:pokedex/data/repositories/pokemon_repository_impl.dart';
import 'package:pokedex/domain/usecases/check_if_favourite.dart';
import 'package:pokedex/domain/usecases/get_favourite_list.dart';
import 'package:pokedex/domain/usecases/get_pokemon_by_name.dart';
import 'package:pokedex/domain/usecases/get_pokemons.dart';
import 'package:pokedex/domain/usecases/remove_from_favourites.dart';
import 'package:pokedex/domain/usecases/save_to_favourites.dart';
import 'package:pokedex/presentation/pages/home/home_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/local_datasource/local_datasource.dart';
import 'package:http/http.dart' as http;

final sharedPreferenceProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final localDataSourceProvider = Provider((ref) {
  return LocalDatasource(ref.watch(sharedPreferenceProvider));
});

final httpClient = Provider((ref) => http.Client());

final removeDataSourceProvider = Provider((ref) {
  return RemoteDataSource(ref.watch(httpClient));
});

final pokemonRepoProvider = Provider((ref) {
  return PokemonRepositoryImpl(
      dataSource: ref.watch(removeDataSourceProvider),
      localDatasource: ref.watch(localDataSourceProvider));
});

final getPokemonUseCaseProvider = Provider<GetPokemons>((ref) {
  return GetPokemons(ref.watch(pokemonRepoProvider));
});

final getPokemonByNameProvider = Provider<GetPokemonByName>((ref) {
  return GetPokemonByName(ref.watch(pokemonRepoProvider));
});

final checkIfFavoriteProvider = Provider<CheckIfFavourite>((ref) {
  return CheckIfFavourite(ref.watch(pokemonRepoProvider));
});

final saveToFavoritesProvider = Provider((ref) {
  return SaveToFavourites(ref.watch(pokemonRepoProvider));
});

final getFavoriteListProvider = Provider((ref) {
  return GetFavouriteList(ref.watch(pokemonRepoProvider));
});

final removeFromFavoritesProvider = Provider((ref) {
  return RemoveFromFavourites(ref.watch(pokemonRepoProvider));
});

final homeScreenControllerProvider = Provider.autoDispose((ref) {
  return HomeScreenController(ref,
      getPokemonsUsecase: ref.watch(getPokemonUseCaseProvider),
      getPokemonsByNameUsecase: ref.watch(getPokemonByNameProvider),
      getFavouriteListUsecase: ref.watch(getFavoriteListProvider));
});
