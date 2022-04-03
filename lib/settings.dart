import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/add');
                  //setState(() {getSavedLocations();});
                },
                icon: Icon(
                  Icons.add_location,
                  color: Colors.green[800],
                  size: 48.0,),
                label: Text('Add Locations',style: TextStyle(fontSize: 32.0, color: Colors.grey[900]),),
                style: ElevatedButton.styleFrom(primary: Colors.green[200]),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/remove');
                  //setState(() {getSavedLocations();});
                },
                icon: Icon(
                  Icons.location_off,
                  color: Colors.red[800],
                  size: 48.0,),
                label: Text('Remove Locations',style: TextStyle(fontSize: 32.0, color: Colors.grey[900]),),
                style: ElevatedButton.styleFrom(primary: Colors.red[200]),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
