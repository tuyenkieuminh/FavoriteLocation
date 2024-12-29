import 'dart:io';

import 'package:favorite_places_new/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'place.db'), onCreate: (db, numb) {
      return db.execute("CREATE TABLE user_place(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)");
    },
    version: 1,
  );
  return db;
}

class FavoritePlacesNotifier extends StateNotifier<List<Place>> {
  FavoritePlacesNotifier() : super([]);

  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final data = await db.query("user_place");
    List<Place> placeList = data.map((row) => Place(title: row['title'] as String, image: File(row['image'] as String), location: PlaceLocation(latitude: row['lat'] as double, longitude: row['lng'] as double, address: row['address'] as String))).toList();
    state=placeList;
  }

  void addNewPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final imageDir = await image.copy("${appDir.path}/$filename");
    Place place = Place(title: title, image: imageDir, location: location);

    final db = await _getDatabase();

    db.insert('user_place', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address,
    });

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
