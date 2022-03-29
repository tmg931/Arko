import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Address> savedLoc = [];
 // TextEditingController _locationEntry = TextEditingController();
 // TextEditingController _titleEntry = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSavedLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen',), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/settings');
                  setState(() {getSavedLocations();});
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[600],
                  size: 48.0,),
                label: Text('Change Settings or Add Location', style: TextStyle(fontSize: 32.0,color: Colors.grey[900]),),
                style: ElevatedButton.styleFrom(primary: Colors.amber[200]),
              ),
            ),
            Column(
              children: savedLoc.map((e) {
                return Card(
                    child: ListTile(
                      onTap: (){
                        Navigator.pushNamed(context, '/map', arguments: {
                          'location': e.location,
                        });
                      },
                      title: Text('Go to ${e.title}'),
                      tileColor: Colors.red[200],
                    ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  void getSavedLocations() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> loc = (prefs.getStringList('loc') ?? List<String>.empty(growable: true));
    List<String> title = (prefs.getStringList('title') ?? List<String>.empty(growable: true));
    savedLoc.clear();
    for(int i = 0; i < loc.length; i++){
      savedLoc.add(Address(title: title[i], location: loc[i]));
    }
  }

}

class Address {
  String title='';
  String location='';

  Address({this.title='',this.location=''});
}