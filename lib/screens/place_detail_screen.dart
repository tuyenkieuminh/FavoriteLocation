import 'package:favorite_places_new/models/place.dart';
import 'package:favorite_places_new/screens/map_screen.dart';
import 'package:favorite_places_new/widgets/preview_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    void _navigateToMapScreen() async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(
            location: place.location,
            isSelect: false,
            getLocation: (latitude, longitude) {
              
            },
            zoom: 15,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _navigateToMapScreen();
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: PreviewMap(
                        location: LatLng(place.location.latitude, place.location.longitude),
                        zoom: 15,
                      ),
                    ),
                  )
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
