import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Locations{
   final String key = 'AIzaSyDEHmjyJCDhghPzpYi7XOh3GBk2AK1US_A';

   Future<String> getPlaceID(String input) async {
     final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
     var response = await http.get(Uri.parse(url));
     var json = convert.jsonDecode(response.body);
     var placeId = json['candidates'][0]['place_id'] as String;
     print(placeId);
     return placeId;
   }

   Future<Map<String, dynamic>> getPlace(String input) async{
     final placeId = await getPlaceID(input);
     final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
     print(url);
     var response = await http.get(Uri.parse(url));
     var json = convert.jsonDecode(response.body);
     var results = json['result'] as Map<String, dynamic>;
     print(results);
     getPosition();
     return results;

   }

   Future<String> nextDirection(Position cur, LatLng des) async{
     final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${cur.latitude},${cur.longitude}&destination=${des.latitude},${des.longitude}&mode=walking&avoidHighways=false&avoidFerries=true&avoidTolls=false&key=$key';
     var response = await http.get(Uri.parse(url));
     var json = convert.jsonDecode(response.body);
     var results = json['routes'][0]['legs'][0]['steps'][0]['html_instructions'] as String;
     print(results);
     //getPosition();
     return results;
   }

   Future<Position> getPosition() async{
     bool serviceEnabled;
     LocationPermission permission;

     serviceEnabled = await Geolocator.isLocationServiceEnabled();

     if (!serviceEnabled) {
       return Future.error('Location services are disabled');
     }

     permission = await Geolocator.checkPermission();

     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();

       if (permission == LocationPermission.denied) {
         return Future.error("Location permission denied");
       }
     }

     if (permission == LocationPermission.deniedForever) {
       return Future.error('Location permissions are permanently denied');
     }

     Position position = await Geolocator.getCurrentPosition();

     print(position);
     return position;
   }

}