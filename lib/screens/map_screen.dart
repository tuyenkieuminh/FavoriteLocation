import 'package:favorite_places_new/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location,
    required this.isSelect,
    required this.getLocation,
    required this.zoom,
  });

  final PlaceLocation? location;
  final bool isSelect;
  final void Function(
    double latitude,
    double longitude,
  ) getLocation;
  final double zoom;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static LatLng initialLocation =
      LatLng(10.760072341973988, 106.68224568678696);
  PlaceLocation? _pickedLocation;
  List<Marker> markers = [];

  @override
  void initState() {
    // TODO: implement initState
    _pickedLocation = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.isSelect == false
              ? const Text("Your location")
              : const Text("Select location"),
          actions: widget.isSelect
              ? [
                  IconButton(
                    onPressed: () {
                      if(_pickedLocation==null){
                        return;
                      } else {
                        widget.getLocation(_pickedLocation!.latitude, _pickedLocation!.longitude);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.save),
                  ),
                ]
              : null,
        ),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: widget.location == null
                ? LatLng(initialLocation.latitude, initialLocation.longitude)
                : LatLng(widget.location!.latitude, widget.location!.longitude),
            initialZoom: widget.zoom,
            onTap: (tapPosition, point) {
              if (widget.isSelect) {
                setState(() {
                  _pickedLocation = PlaceLocation(
                      latitude: point.latitude,
                      longitude: point.longitude,
                      address: "");
                  if(markers.isNotEmpty){
                    markers.removeAt(0);
                  }
                  markers.add(
                    Marker(
                      width: 50,
                      height: 50,
                      point: LatLng(point.latitude, point.longitude),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                  );
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: _pickedLocation == null ? markers : [
                Marker(
                      width: 50,
                      height: 50,
                      point: LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
              ],
            )
          ],
        ));
  }
}
