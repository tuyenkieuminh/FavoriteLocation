import 'package:favorite_places_new/models/place.dart';
import 'package:favorite_places_new/providers/favorite_places_provider.dart';
import 'package:favorite_places_new/screens/new_place_screen.dart';
import 'package:favorite_places_new/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceListScreen extends ConsumerStatefulWidget {
  const PlaceListScreen({super.key});

  @override
  ConsumerState<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends ConsumerState<PlaceListScreen> {
  List<Place> _placeList = [];

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "No place added yet.",
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.white,
            ),
      ),
    );
    _placeList = ref.watch(favoritePlacesNotifier);
    if (_placeList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _placeList.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(_placeList[index].id),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8),
                // child: ClipRRect(
                //   borderRadius: BorderRadius.circular(5),
                //   child: Image.file(_placeList[index].image),
                // ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(_placeList[index].image),
                ),
              ),
              title: Text(
                _placeList[index].title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Text(_placeList[index].location.address, style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>
                        PlaceDetailScreen(place: _placeList[index]),
                  ),
                );
              },
            ),
            onDismissed: (direction) {
              ref
                  .read(favoritePlacesNotifier.notifier)
                  .deletePlace(_placeList[index]);
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const NewItemScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
