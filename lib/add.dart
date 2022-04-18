import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {

  TextEditingController _locationEntry = TextEditingController();
  TextEditingController _titleEntry = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Location'), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: TextFormField(
                controller: _locationEntry,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'Enter Address To Save', hintStyle: TextStyle(fontSize: 28.0)),
                style: TextStyle(fontSize: 28.0),
              ))
            ],),
            Row(children: [
              Expanded(child: TextFormField(
                controller: _titleEntry,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'Enter Name To Save', hintStyle: TextStyle(fontSize: 28.0)),
                style: TextStyle(fontSize: 28.0),
              ))
            ],),
            ElevatedButton(
              child: Text('Save Location', style: TextStyle(fontSize: 28.0,color: Colors.grey[900]),),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String> loc = (prefs.getStringList('loc') ?? List<String>.empty(growable: true));
                List<String> title = (prefs.getStringList('title') ?? List<String>.empty(growable: true));
                loc.add(_locationEntry.text);
                title.add(_titleEntry.text);
                prefs.setStringList('loc', loc);
                prefs.setStringList('title', title);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.green[400]),
            ),
            ElevatedButton(
              child: Text('Cancel', style: TextStyle(fontSize: 28.0,color: Colors.grey[900]),),
              onPressed: () async {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.grey[400]),
            ),
          ],
        ),
      )
    );
  }
}

class Address {
  String title='';
  String location='';

  Address({this.title='',this.location=''});
}