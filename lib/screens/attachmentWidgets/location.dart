import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  LatLng? currentLatLng;
  final Completer<GoogleMapController> _controller = Completer();

  Future<void> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: GoogleMap(
          onTap: (argument) {
            print("++++++++++++ ON TAP +++++++++++++");
            print(argument);
          },
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
              target: LatLng(8.196207, 77.149917), zoom: 1),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: <Marker>{
            if (currentLatLng != null)
              Marker(
                draggable: true,
                markerId: const MarkerId("1"),
                position: currentLatLng!,
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: const InfoWindow(
                  title: 'My Location',
                ),
              )
          },
        ),
        floatingActionButton: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                  child: Center(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        Text('Current Location',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )),
            ],
          ),
          onTap: () {
            _goToCurrentLocation();

            Navigator.pop(context, currentLatLng);
          },
        ));
  }

  Future<void> _goToCurrentLocation() async {
    await _determinePosition();
    final GoogleMapController controller = await _controller.future;
    if (currentLatLng != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLng!, zoom: 16)));
    }
  }
}

class OwnLocationCard extends StatefulWidget {
  const OwnLocationCard({super.key, required this.path, required this.time});
  final String path;
  final String time;

  @override
  State<OwnLocationCard> createState() => _OwnLocationCardState();
}

class _OwnLocationCardState extends State<OwnLocationCard> {
  @override
  Widget build(BuildContext context) {
    String a = widget.path.replaceAll("LatLng(", "");
    a = a.replaceAll(")", "");
    LatLng? loc =
        LatLng(double.parse(a.split(",")[0]), double.parse(a.split(",")[1]));
    return Stack(children: [
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Container(
            height: MediaQuery.of(context).size.width / 1.5,
            width: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 15, top: 3, left: 3, right: 3),
              child: Card(
                child: GoogleMap(
                  markers: <Marker>{
                    Marker(
                      draggable: true,
                      markerId: const MarkerId("1"),
                      position: loc,
                      icon: BitmapDescriptor.defaultMarker,
                      infoWindow: const InfoWindow(
                        title: 'My Location',
                      ),
                    )
                  },
                  initialCameraPosition: CameraPosition(
                    target: loc,
                    zoom: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 4,
        // left: 5,
        right: 17,
        child: Container(
          width: 65,
          color: Colors.transparent,
          child: Center(
            child: Row(
              children: [
                Text(
                  widget.time,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const Expanded(
                  child: Icon(
                    Icons.done_all,
                    color: Colors.white,
                    size: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ]);

    //   child: Container(
    //     height: 150,
    //     width: 300,
    //     color: Colors.blue,
    //     child: GoogleMap(
    //       markers: <Marker>{
    //         Marker(
    //           draggable: true,
    //           markerId: const MarkerId("1"),
    //           position: loc,
    //           icon: BitmapDescriptor.defaultMarker,
    //           infoWindow: const InfoWindow(
    //             title: 'My Location',
    //           ),
    //         )
    //       },
    //       initialCameraPosition: CameraPosition(
    //         target: loc,
    //         zoom: 16,
    //       ),
    //     ),
    //   ),
    // ),
  }
}

class ReplyLocationCard extends StatefulWidget {
  const ReplyLocationCard({
    super.key,
    required this.path,
    required this.time,
  });
  final String path;
  final String time;

  @override
  State<ReplyLocationCard> createState() => _ReplyLocationCardState();
}

class _ReplyLocationCardState extends State<ReplyLocationCard> {
  @override
  Widget build(BuildContext context) {
    String a = widget.path.replaceAll("LatLng(", "");
    a = a.replaceAll(")", "");
    LatLng? loc =
        LatLng(double.parse(a.split(",")[0]), double.parse(a.split(",")[1]));
    return Stack(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Container(
            height: MediaQuery.of(context).size.width / 1.5,
            width: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.green),
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 15, top: 3, left: 3, right: 3),
              child: Card(
                child: GoogleMap(
                  markers: <Marker>{
                    Marker(
                      draggable: true,
                      markerId: const MarkerId("1"),
                      position: loc,
                      icon: BitmapDescriptor.defaultMarker,
                      infoWindow: const InfoWindow(
                        title: 'My Location',
                      ),
                    )
                  },
                  initialCameraPosition: CameraPosition(
                    target: loc,
                    zoom: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 6,
        left: 140,
        child: Container(
          width: 65,
          color: Colors.transparent,
          child: Center(
            child: Text(
              widget.time,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
