import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PreviewMap extends StatelessWidget {
  const PreviewMap({
    super.key,
    required this.location,
    required this.zoom,
  });
  final LatLng location;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(location.latitude, location.longitude),
          initialZoom: zoom,
          interactionOptions: InteractionOptions(
            cursorKeyboardRotationOptions:
                CursorKeyboardRotationOptions.disabled(),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 50,
                height: 50,
                point: LatLng(location.latitude, location.longitude),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
