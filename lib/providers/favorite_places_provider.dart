import 'package:favorite_places_new/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePlacesNotifier extends StateNotifier<List<Place>> {
  FavoritePlacesNotifier() : super([]);

  void addNewPlace(Place place) {
    state = [...state, place];
  }

  void deletePlace(Place place) {
    state = [...state]..remove(place);
  }
}

final favoritePlacesNotifier =
    StateNotifierProvider<FavoritePlacesNotifier, List<Place>>((ref) {
  return FavoritePlacesNotifier();
});
