import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:medx/config/colors.dart';
import 'package:medx/providers/check_out_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CostomGoogleMap extends StatefulWidget {
  @override
  _GoogleMapState createState() => _GoogleMapState();
}
List<Marker> _markers = <Marker>[];

class _GoogleMapState extends State<CostomGoogleMap> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  
  GoogleMapController controller;
  Location _location = Location();
  
  void _onMapCreated(GoogleMapController _value) {
    controller = _value;
    _location.onLocationChanged.listen((event) {
      
      _markers.add(Marker(markerId: MarkerId('1'),position: LatLng(event.latitude, event.longitude)));
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(event.latitude, event.longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
      _markers.add(
        Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.5937,78.9629),
        infoWindow: InfoWindow(
        title: 'Your location'
        )
      )
    );
    CheckoutProvider checkoutProvider = Provider.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              GoogleMap(
                markers: Set<Marker>.of(_markers),
                initialCameraPosition: CameraPosition(
                  target: _initialcameraposition,
                ),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin:
                      EdgeInsets.only(right: 60, left: 10, bottom: 40, top: 40),
                  child: MaterialButton(
                    onPressed: () async {
                      await _location.getLocation().then((value) {
                        setState(() {
                          checkoutProvider.setLoaction = value;
                        });
                      });
                      Navigator.of(context).pop();
                    },
                    color: primaryColor,
                    child: Text("Set Location"),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
