import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phone extends StatefulWidget {

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {

  TextEditingController _numEntry = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Change Emergency Contact'), centerTitle: true,),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                Expanded(child: TextFormField(
                  controller: _numEntry,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: 'Enter Phone Number', hintStyle: TextStyle(fontSize: 28.0)),
                  style: TextStyle(fontSize: 28.0),
                ))
              ],),
              ElevatedButton(
                child: Text('Save Number', style: TextStyle(fontSize: 28.0,color: Colors.grey[900]),),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('num', _numEntry.text);
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
