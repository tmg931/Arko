import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Address> savedLoc = [];

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
                label: Text('Change Settings or Add New Location', style: TextStyle(fontSize: 32.0,color: Colors.grey[900]),),
                style: ElevatedButton.styleFrom(primary: Colors.amber[200]),
              ),
            ),
            Card(
              child: ListTile(
                onTap: (){
                  Navigator.pushNamed(context, '/unsaved');
                },
                title: Text('Search for Location', style: TextStyle(fontSize: 28.0),),
                tileColor: Colors.teal[100],
                leading: Icon(
                  Icons.search,
                  size: 40.0,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: savedLoc.length,
                      itemBuilder: (context,index){
                        return Card(
                          child: ListTile(
                            onTap: (){
                              Navigator.pushNamed(context, '/map', arguments: {
                                'location': savedLoc[index].location,
                              });
                            },
                            title: Text('Go to ${savedLoc[index].title}', style: TextStyle(fontSize: 28.0),),
                            tileColor: Colors.blue[200],
                            leading: Icon(
                              Icons.location_pin,
                              size: 40.0,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward,
                            ),
                          ),
                        );
                      },
                      
                    ),
                  ),
                ],
              ),
            ),
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
    setState(() {});
  }

}

class Address {
  String title='';
  String location='';

  Address({this.title='',this.location=''});
}