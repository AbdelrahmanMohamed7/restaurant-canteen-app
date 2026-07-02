import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../cart_screen.dart';

class GetLocationFromGoogleMapScreen extends StatefulWidget {
  const GetLocationFromGoogleMapScreen({Key? key}) : super(key: key);

  @override
  _GetLocationFromGoogleMapScreenState createState() =>
      _GetLocationFromGoogleMapScreenState();
}

class _GetLocationFromGoogleMapScreenState
    extends State<GetLocationFromGoogleMapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = Set<Marker>();
  LatLng? latLng;
  bool firstTime = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LocationData?>(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CartDetailScreen(
                userLatLng: latLng,
              );
            } else if (snapshot.hasData) {
              print('_determinePosition');
              print(snapshot.data);
              if (firstTime) {
                LocationData? location = snapshot.data;
                if (location == null) {
                  latLng = LatLng(26.8206, 30.8025);
                } else {
                  latLng = LatLng(
                      location.latitude ?? 0.0, location.longitude ?? 0.0);
                }
                _markers.add(Marker(
                  markerId: MarkerId(latLng.toString()),
                  position: latLng!,
                  infoWindow: InfoWindow(
                    title: 'Selected Locations',
                  ),
                ));
                firstTime = false;
              }
              return Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.9,
                    child: GoogleMap(
                      markers: _markers,
                      initialCameraPosition:
                          CameraPosition(target: latLng!, zoom: 18),
                      onMapCreated: (GoogleMapController controller) {
                        //getting reference of google map controller
                        _controller = controller;
                      },
                      // when you tap on map _handleTap method will be called
                      onTap: _handleTap,
                      // child: Text('Location Screen'),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.1,
                    width: Get.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        if (_markers.length > 0) {
                          Get.to(() => CartDetailScreen(
                                userLatLng: latLng!,
                              ));
                        } else {
                          Get.snackbar(
                              'ALERT', 'Please select a location on map');
                        }
                        print(_markers.length);
                      },
                      child: Text('Select Location'),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Future<LocationData?> _determinePosition() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception("Location is disabled");
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception("Location is disabled");
      }
    }
    return _locationData = await location.getLocation();
  }

  _handleTap(LatLng point) {
    setState(() {
      //removing previous marker
      _markers.clear();
      print(point);
      latLng = point;
      print(latLng);
      //putting new marker on the googlemap
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Selected Locations',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });
  }
}
