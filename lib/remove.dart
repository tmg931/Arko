import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Remove extends StatefulWidget {

  @override
  _RemoveState createState() => _RemoveState();
}

class _RemoveState extends State<Remove> {
  List<String> loc=[];
  List<String> title=[];

  @override
  void initState() {
    super.initState();
    getSavedLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Remove Locations'), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: title.length,
                itemBuilder: (context,index){
                  return Card(
                    child: ListTile(
                      onTap: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        title.removeAt(index);
                        loc.removeAt(index);
                        prefs.setStringList('loc', loc);
                        prefs.setStringList('title', title);
                        Navigator.pop(context);
                      },
                      title: Text('Remove ${title[index]}', style: TextStyle(fontSize: 28.0),),
                      tileColor: Colors.red[200],
                      trailing: Icon(
                        Icons.delete_forever,
                      ),
                    ),
                  );
                },

              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  child: Text('Delete All', style: TextStyle(fontSize: 28.0),),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                ),
                ElevatedButton(
                  child: Text('Cancel', style: TextStyle(fontSize: 28.0, color: Colors.grey[900]),),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.grey[400]),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ],
        ),
      ),
    );
  }

  void getSavedLocations() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loc = (prefs.getStringList('loc') ?? List<String>.empty(growable: true));
    title = (prefs.getStringList('title') ?? List<String>.empty(growable: true));
    setState(() {});
  }
}
