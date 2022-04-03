//import 'dart:js';
import 'package:arko/home.dart';
import 'package:arko/add.dart';
import 'package:arko/remove.dart';
import 'package:arko/settings.dart';
import 'package:arko/location.dart';
import 'package:arko/unsaved.dart';
import 'package:arko/test.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
//import 'dart:html';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:styled_text/styled_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      initialRoute: '/home',
      routes:{
        //'/': (context) => Loading(),
        '/home': (context) => Home(),
        '/map': (context) => MapSample(),
        '/add': (context) => Add(),
        '/remove': (context) => Remove(),
        '/settings': (context) => Settings(),
        '/unsaved': (context) => Unsaved(),
      }
//      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  final String key = 'AIzaSyDEHmjyJCDhghPzpYi7XOh3GBk2AK1US_A';
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers = Set<Marker>();
  PolylinePoints polylinePoints = PolylinePoints();
  Map data = {};
  Timer? timer;
  double direction = 0.0;
  String dirStr = '';

  static final CameraPosition _initialCameraPos = CameraPosition(
    target: LatLng(30.455000, -84.253334),
    zoom: 12,
  );

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateUserPos();
    });
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      updateUserPos();
    });

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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

    data = ModalRoute.of(context)!.settings.arguments as Map;
    print(data['location']);

    //updateUserPos();
    //Future.delayed(Duration.zero, () => updateUserPos());
    //SchedulerBinding.instance.addPostFrameCallback((_) => updateUserPos());



    return Scaffold(
      appBar: AppBar(title: Text('Directions'), centerTitle: true,),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: StyledText(
                text: dirStr,
                style: TextStyle(fontSize: 28.0),
                tags: {'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold))}
              ),
              color: Colors.blue[300],
              padding: EdgeInsets.all(20.0),
              width: double.infinity,
            )
          ),
          Expanded(
            flex: 7,
            child: GoogleMap(
              mapType: MapType.hybrid,
              markers: _markers,
              initialCameraPosition: _initialCameraPos,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              buildingsEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }



  Future<void> updateUserPos() async{
    var loc = await Locations().getPlace(data['location']);
    var latlong = await _getPlaceTest(loc);
    var curpos = await Locations().getPosition();
    _setMarker(latlong);
    final GoogleMapController controller = await _controller.future;
    dirStr = await Locations().nextDirection(curpos, latlong);
    print(dirStr);
    dirStr = dirStr.split('<div')[0];
    await calcRoute(curpos, latlong);
    double angle = Geolocator.bearingBetween(polylineCoordinates[0].latitude, polylineCoordinates[0].longitude,
        polylineCoordinates[1].latitude, polylineCoordinates[1].longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(curpos.latitude, curpos.longitude),zoom: 19, tilt: 60.0, bearing: angle),
    ));
  }




  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng),zoom: 18, bearing: 270.0),
    ));
    //_setMarker(LatLng(lat,lng));
  }

  Future<LatLng> _getPlaceTest(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    /*final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng),zoom: 18),
    ));*/
    //_setMarker(LatLng(lat,lng));
    return LatLng(lat, lng);
  }

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 10);
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