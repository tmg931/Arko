import 'package:arko/SelectBondedDevicePage.dart';
import 'package:arko/home.dart';
import 'package:arko/add.dart';
import 'package:arko/phone.dart';
import 'package:arko/remove.dart';
import 'package:arko/settings.dart';
import 'package:arko/unsaved.dart';
import 'package:arko/map.dart';
import 'package:flutter/material.dart';
//import './MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  get server => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      initialRoute: '/device',
      debugShowCheckedModeBanner: false,
      routes:{
        //'/': (context) => Loading(),
        '/home': (context) => Home(server: server),
        '/map': (context) => MapSample(),
        '/add': (context) => Add(),
        '/remove': (context) => Remove(),
        '/settings': (context) => Settings(),
        '/unsaved': (context) => Unsaved(),
     //   '/bluetooth': (context) => MainPage(),
        '/device': (context) => SelectBondedDevicePage(checkAvailability: false),
        '/phone': (context) => Phone(),
      }
    );
  }
}
