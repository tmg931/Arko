import 'package:flutter/material.dart';

class Unsaved extends StatefulWidget {

  @override
  _UnsavedState createState() => _UnsavedState();
}

class _UnsavedState extends State<Unsaved> {
  TextEditingController _locationEntry = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Go to Unsaved Location'), centerTitle: true,),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                Expanded(child: TextFormField(
                  controller: _locationEntry,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Enter Location', hintStyle: TextStyle(fontSize: 28.0)),
                  style: TextStyle(fontSize: 28.0),
                ))
              ],),
              ElevatedButton(
                child: Text('Go to Location', style: TextStyle(fontSize: 28.0,color: Colors.grey[900])),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/map', arguments: {
                    'location': _locationEntry.text,
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(primary: Colors.green[400]),
              ),
              ElevatedButton(
                child: Text('Cancel', style: TextStyle(fontSize: 28.0, color: Colors.grey[900]), ),
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
