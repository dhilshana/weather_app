import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  GoogleMapScreen({
    super.key,
    required this.latlong,
  });
  final LatLng latlong;
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
   String? _currentAddress; // This will store the location name

  LatLng? _initialPosition;
  @override
  void initState() {
    _initialPosition = widget.latlong;
    _getAddressFromLatLng(_initialPosition!);
    // TODO: implement initState
    super.initState();
  }



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Function to fetch the address using reverse geocoding
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      // Use the geocoding package to get the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0]; // Get the first placemark result

      setState(() {
        // Format the address using the placemark fields
        _currentAddress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      print("Error occurred while fetching location: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: MapType.normal, // Keep it simple
              // Reduce layers if not necessary
              trafficEnabled: false,
              buildingsEnabled: false, //
              initialCameraPosition: CameraPosition(
                target: _initialPosition!,
                zoom: 10.0,
                // Set the zoom level
              ),
              markers: {
                Marker(
                  markerId: MarkerId('initialMarker'),
                  position: _initialPosition!,
                  infoWindow: InfoWindow(
                    title: _currentAddress ?? '',
                  ),
                ),
              }, // Optionally add markers
            ),
          ),
        ],
      ),
    );
  }
}
