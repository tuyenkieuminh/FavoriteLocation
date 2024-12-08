import 'package:favorite_places_new/models/place.dart';
import 'package:favorite_places_new/screens/map_screen.dart';
import 'package:favorite_places_new/widgets/preview_map.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as locate;
import 'package:latlong2/latlong.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.getLocation});

  final void Function(PlaceLocation placeLocation) getLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _currentLocation;
  var _isGettingLocation = false;
  final locate.Location location = locate.Location();

  Future<bool> _checkServiceAndPermission() async {
    bool serviceEnabled;
    locate.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == locate.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != locate.PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void _getCurrentLocation() async {
    locate.LocationData locationData;

    if (_checkServiceAndPermission() == false) {
      return;
    }

    setState(() {
      _currentLocation = null;
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;
    if (lat == null && lon == null) {
      return;
    }
    List<geocoding.Placemark> placemarkList =
        await geocoding.placemarkFromCoordinates(lat!, lon!);
    if (placemarkList.isEmpty) {
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    setState(() {
      _currentLocation = PlaceLocation(
        latitude: lat,
        longitude: lon,
        address:
            "${placemarkList[0].street}, ${placemarkList[0].subAdministrativeArea}, ${placemarkList[0].administrativeArea}",
      );
      _isGettingLocation = false;
    });

    widget.getLocation(_currentLocation!);
  }

  void _getPickedLocation(double lat, double lon) async {
    setState(() {
      _currentLocation = null;
      _isGettingLocation = true;
    });

    List<geocoding.Placemark> placemarkList =
        await geocoding.placemarkFromCoordinates(lat, lon);
    if (placemarkList.isEmpty) {
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    setState(() {
      _currentLocation = PlaceLocation(
        latitude: lat,
        longitude: lon,
        address:
            "${placemarkList[0].street}, ${placemarkList[0].subAdministrativeArea}, ${placemarkList[0].administrativeArea}",
      );
      _isGettingLocation = false;
    });

    widget.getLocation(_currentLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location chosen",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );

    if (_isGettingLocation == true) {
      previewContent = const CircularProgressIndicator();
    }

    if (_currentLocation != null) {
      previewContent = PreviewMap(
        location: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
        zoom: 15,
      );
    }

    return Column(
      children: [
        Container(
          height: 150,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: previewContent,
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text("Get Current Location"),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      isSelect: true,
                      getLocation: (latitude, longitude) {
                        _getPickedLocation(latitude, longitude);
                      },
                      zoom: 15,
                      location: _currentLocation,
                    ),
                  ),
                );
              },
              label: const Text("Select on Map"),
              icon: const Icon(Icons.map),
            )
          ],
        ),
      ],
    );
  }
}
