import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Home extends StatefulWidget {
  final BluetoothDevice server;
  Home({required this.server/*=const BluetoothDevice(address: "0")*/});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //BluetoothDevice server = BluetoothDevice(address: "0");
  List<Address> savedLoc = [];

//  static final clientID = 0;
  BluetoothConnection? connection;

 // List<_Message> messages = List<_Message>.empty(growable: true);
 // String _messageBuffer = '';

//  final TextEditingController textEditingController =
//  new TextEditingController();
 // final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  bool inMap = false;

  @override
  void initState() {
    super.initState();
    //server = ModalRoute.of(context)!.settings.arguments;
    getSavedLocations();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
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

  void _onDataReceived(Uint8List data) async{
    // Allocate buffer for parsed data
    print(data[0]);
    if(data[0] == 48 && inMap == false){
      inMap = true;
      await Navigator.pushNamed(context, '/map', arguments: {
        'location': savedLoc[0].location,
      });
      inMap = false;
      //Navigator.popUntil(context, ModalRoute.withName('/home'));
    }
    if(data[0] == 49){
      /*inMap = true;
      await Navigator.pushNamed(context, '/map', arguments: {
        'location': savedLoc[1].location,
      });
      inMap = false;*/
      //Navigator.popUntil(context, ModalRoute.withName('/home'));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String num = prefs.getString('num') ?? '123';
      await FlutterPhoneDirectCaller.callNumber(num);
    }
    if(data[0] == 50 && inMap == false){
      inMap = true;
      await Navigator.pushNamed(context, '/map', arguments: {
        'location': savedLoc[1].location,
      });
      inMap = false;
      //Navigator.popUntil(context, ModalRoute.withName('/home'));
    }
  }


}

class Address {
  String title='';
  String location='';

  Address({this.title='',this.location=''});
}