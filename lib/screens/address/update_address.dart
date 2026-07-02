import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../controller/address_controller.dart';
import '../../model/address/address_model.dart';
import 'address.dart';

class UpdateAddress extends StatefulWidget {
  final String docId;
  final LatLng latLng;
  final String landMark;
  const UpdateAddress({Key? key,required this.docId,required this.latLng,required this.landMark}) : super(key: key);

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  GoogleMapController? _controller;
  Set<Marker> _markers = Set<Marker>();
  LatLng? latLng;
  bool firstTime = true;
  AddressController addressController=Get.find<AddressController>();
  @override
  void initState() {
    latLng=widget.latLng;
    _markers.add(Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng!,
      infoWindow: InfoWindow(
        title: 'Selected Locations',
      ),
    ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LocationData?>(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()),);
            } else if (snapshot.hasData) {
              print('_determinePosition');
              print(snapshot.data);
              return SingleChildScrollView(
                child: Column(
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
                          await showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController landmarkController=TextEditingController(text: widget.landMark);
                              bool isChecked=false;
                              return SizedBox(
                                height: 120,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text("Update Address"),
                                      content: Container(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: landmarkController,
                                              // initialValue: controller.quantity.toString(),
                                              keyboardType: TextInputType.name,),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            MaterialButton(
                                              onPressed: () async{
                                                if (landmarkController.text.isNotEmpty) {
                                                  AddressModel addressModel=AddressModel();
                                                  addressModel.landMark=landmarkController.text;
                                                  addressModel.lat=latLng!.latitude;
                                                  addressModel.lang=latLng!.longitude;
                                                  await addressController.updateAddress(addressModel,widget.docId);
                                                  Get.offAll(()=>AddressScreen());
                                                }else{
                                                  Get.snackbar('INFORMATION', 'Please enter the landmark');
                                                }
                                                Get.back();

                                              },
                                              // padding: EdgeInsets.symmetric(
                                              //     horizontal: 5, vertical: 10),
                                              color: Get.theme.colorScheme.secondary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.horizontal(
                                                      left: Radius.circular(10),
                                                      right: Radius.circular(10))),
                                              child: Text('Update'),
                                              elevation: 0,
                                            ),
                                          ],
                                        ),),
                                    );
                                  },
                                ),
                              );
                            },
                          );

                          // if (_markers.length > 0) {
                          //   Get.to(() => CartDetailScreen(
                          //     userLatLng: latLng!,
                          //   ));
                          // } else {
                          //   Get.snackbar(
                          //       'ALERT', 'Please select a location on map');
                          // }
                          // print(_markers.length);
                        },
                        child: Text('Update Location'),
                      ),
                    ),
                  ],
                ),
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
