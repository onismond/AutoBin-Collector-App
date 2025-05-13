import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:autobin_collector/utils/constants.dart';
import 'package:autobin_collector/data/services/api_controller.dart';
import 'package:autobin_collector/data/models/pickup.dart';
import 'package:autobin_collector/screens/home/scan_bin_qr.dart';
import 'package:autobin_collector/utils/eye_less.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Pickup> pickups = [];

  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late LatLng _currentPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool locationGranted = false;

  static const CameraPosition UCCLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  @override
  void initState() {
    checkLocationPermissions();
    super.initState();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  void checkLocationPermissions() async {
    var location = new Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services are disabled.");
        return;
      }
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission denied.");
        return;
      }
    }
    locationGranted = true;
    showMyLocation();
  }

  Future<void> drawRoute(LatLng destination) async {
    EasyLoading.show(status: 'Fetching route...');
    var location = Location();
    try {
      var currentLocation = await location.getLocation();
      LatLng origin = LatLng(currentLocation.latitude!, currentLocation.longitude!);

      // await APIController().getRoute(
      //   start: "${origin.latitude},${origin.longitude}",
      //   end: "${destination.latitude},${destination.longitude}"
      // ).then(
      //   (Response<dynamic> response) async {
      //     final data = response.data;
      //     print(data);
      //
      //     final encodedPoints = data['routes'][0]['geometry'];
      //     polylineCoordinates = _decodePolyline(encodedPoints);
      //
      //     setState(() {
      //       polylines.clear();
      //       polylines.add(
      //         Polyline(
      //           polylineId: PolylineId('route'),
      //           points: polylineCoordinates,
      //           color: Colors.blue,
      //           width: 5,
      //         ),
      //       );
      //     });
      //   },
      //   onError: (e) {
      //     EasyLoading.showError('Failed to fetch route');
      //   }
      // );

      final response = await Dio().get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': Confident.MAPS_API,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        final encodedPoints = data['routes'][0]['overview_polyline']['points'];
        polylineCoordinates = _decodePolyline(encodedPoints);

        setState(() {
          polylines.clear();
          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      } else {
        EasyLoading.showError('Failed to fetch route');
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError('Error fetching route');
    } finally {
      EasyLoading.dismiss();
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  void loadPickups() async{
    await APIController().loadPickups().then(
      (Response<dynamic> response) async {
        pickups.clear();
        List pickupData = APIController.decodeListData(response);
        for (var pickup in pickupData) {
          pickups.add(Pickup.fromMap(pickup));
        }
        markers.clear();
        for (var pickup in pickups) {
          final MarkerId markerId = MarkerId(markers.length.toString());
          final marker = Marker(
            markerId: markerId,
            position: LatLng(pickup.latitude, pickup.longitude),
            infoWindow: InfoWindow(
                title: '${pickup.currentLevel}%',
                snippet: '${pickup.userName} - ${pickup.userContact}'
            ),
            onTap: () async {
              await drawRoute(LatLng(pickup.latitude, pickup.longitude));
            }
          );
          setState(() {
            markers[markerId] = marker;
          });
        }
      },
      onError: (e) {
        print(e.toString());
      }
    );
  }

  void showPickupBottomSheet() async{
    EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
    );
    await APIController().loadPickups().then(
      (Response<dynamic> response) async {
        EasyLoading.dismiss();
        pickups.clear();
        List pickupData = APIController.decodeListData(response);
        for (var pickup in pickupData) {
          pickups.add(Pickup.fromMap(pickup));
        }
        markers.clear();
        for (var pickup in pickups) {
          final MarkerId markerId = MarkerId(markers.length.toString());
          final marker = Marker(
            markerId: markerId,
            position: LatLng(pickup.latitude, pickup.longitude),
            infoWindow: InfoWindow(
                title: '${pickup.currentLevel}%',
                snippet: '${pickup.userName} - ${pickup.userContact}'
            ),
            onTap: () async {
              await drawRoute(LatLng(pickup.latitude, pickup.longitude));
            }
          );
          setState(() {
            markers[markerId] = marker;
          });
        }
        if (pickups.isEmpty) {
          EasyLoading.showInfo(
            "No pickups available",
            duration: const Duration(hours: 1),
            maskType: EasyLoadingMaskType.black,
            dismissOnTap: true,
          );
          return;
        }
        showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
                padding: EdgeInsets.all(16.0),
                height: 200,
                // height: MediaQuery.of(context).size.height * 0.5, // Adjust the height
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(pickups.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              animateCameraToLocation(
                                  latitude: pickups[index].latitude,
                                  longitude: pickups[index].longitude
                              );
                            },
                            borderRadius: BorderRadius.circular(5),
                            splashColor: Colors.blue.withOpacity(0.1),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[200]?.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 47,
                                          height: 47,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child:Center(
                                              child: Text(
                                                "${pickups[index].currentLevel}%",
                                                style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontSize: 15,
                                                ),
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text("Name: ${pickups[index].userName}"),
                                        const SizedBox(height: 5,),
                                        Text(pickups[index].userContact),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                )
            );
          },
        );
      },
      onError: (e) {
        EasyLoading.dismiss();
        EasyLoading.showInfo(
          APIController.errorMessage(e, context),
          duration: const Duration(hours: 1),
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: true,
        );
      }
    );


  }

  void animateCameraToLocation({required latitude, required longitude}) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17.0,
      ),
    ));
  }

  void showMyLocation() async {
    LocationData currentLocation;
    var location = new Location();

    if (!locationGranted) {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print("Location services are disabled.");
          return;
        }
      }
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print("Location permission denied.");
          return;
        }
      }
    }

    try {
      currentLocation = await location.getLocation();
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: 17.0,
        ),
      ));
      locationGranted = true;
      loadPickups();
    } on Exception {
      print('Location permission denied');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' AutoBin Collector'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanBinQr())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              label: const Text(
                "Scan Bin",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: UCCLocation,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(markers.values),
            polylines: polylines,
          ),
          Positioned(
            right: 20,
            bottom: 95,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              onPressed: () {
                showMyLocation();
              },
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                showPickupBottomSheet();
              },
              child: const Icon(Icons.fire_truck_rounded),
            ),
          ),

        ],
      ),
    );
  }
}
