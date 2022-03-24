import 'package:geolocator/geolocator.dart';
import 'dart:async';
//import 'dart:html';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:arko/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _originLocation = TextEditingController();
  TextEditingController _destinationLocation = TextEditingController();
  final String key = 'AIzaSyDEHmjyJCDhghPzpYi7XOh3GBk2AK1US_A';
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers = Set<Marker>();
  PolylinePoints polylinePoints = PolylinePoints();

  static final CameraPosition _initialCameraPos = CameraPosition(
    target: LatLng(30.455000, -84.253334),
    zoom: 12,
  );

 /* @override
  void initState(){
    super.initState();
        _setMarker(LatLng(0.0, 0.0));
  }*/
  int _markerCounter = 1;

  void _setMarker(LatLng point){
    setState(() {
      final String markerIdVal = 'marker_$_markerCounter';
      //_markerCounter++;
      _markers.add(
        Marker(
          markerId: MarkerId(markerIdVal),
          position: point,
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Directions'),),
      body: Column(
        children: [
          /*Row(children: [
            Expanded(
                child: TextFormField(
                  controller: _originLocation,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Enter Current Location Address'),
                  onChanged: (value){
                    print(value);
                  },
                )
            ),
            IconButton(
                onPressed: () async {
                  var loc = await Locations().getPlace(_originLocation.text);
                  var latlong = await _getPlaceTest(loc);
                  //_setMarker(latlong);
                },
                icon: Icon(Icons.search),
            )
          ],
          ),*/
          Row(children: [
            Expanded(
                child: TextFormField(
                  controller: _destinationLocation,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Enter Destination Address'),
                  onChanged: (value){
                    print(value);
                  },
                )
            ),
            IconButton(
              onPressed: () async {
                var loc = await Locations().getPlace(_destinationLocation.text);
                var latlong = await _getPlaceTest(loc);
                _setMarker(latlong);
                print(await Locations().getPosition());
                print(loc);
                calcRoute(await Locations().getPosition(), latlong);
              },
              icon: Icon(Icons.search),
            )
          ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              markers: _markers,
              initialCameraPosition: _initialCameraPos,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),

      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          Position position = await Locations().getPosition();
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 14),
          ));
          var loc = await Locations().getPlace(_destinationLocation.text);
          var latlong = await _getPlaceTest(loc);
          calcRoute(position, latlong);
        },
        label: Text('Current Location'),
        icon: Icon(Icons.location_history),
      ),*/
    );
  }


  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng),zoom: 18),
    ));
    //_setMarker(LatLng(lat,lng));
  }

  Future<LatLng> _getPlaceTest(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng),zoom: 18),
    ));
    //_setMarker(LatLng(lat,lng));
    return LatLng(lat, lng);
  }

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 5);
    polylines[id] = polyline;
    setState(() {});
  }

  calcRoute(Position curPos, LatLng destination) async{
    //LatLng destLatLng = await _getPlaceTest(destination);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(key,
        PointLatLng(curPos.latitude, curPos.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.walking);
    if(result.points.isNotEmpty){
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
  }
}