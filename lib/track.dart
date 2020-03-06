import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Track extends StatefulWidget{
  Track({Key key,this.empid,}):super(key:key);
  String empid;
  @override
  _Track createState() => _Track();
}
class _Track extends State<Track> {
  static final databaseReference = FirebaseDatabase.instance.reference();
  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;
  StreamSubscription subscription;
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubcription;
  Location location = new Location();
  String error;

  final Set<Marker> _markers = Set();
  final double _zoom = 20;
  CameraPosition _initialPosition = CameraPosition(target: LatLng(26.8206, 30.8025));
  MapType _defaultMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subscription = databaseReference.child("Tracking").child(widget.empid).onValue.listen((event) {
      setState(() {
        currentLatitude = event.snapshot.value['latitude'];
        currentLongitude = event.snapshot.value['longitude'];
        _goToNewYork();
      });
    });
//    _goToNewYork();
  }

  Future<void> _goToNewYork() async {
    double lat = 40.7128;
    double long = -74.0060;
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(currentLatitude, currentLongitude), _zoom));
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
            markerId: MarkerId('newyork'),
            position: LatLng(currentLatitude, currentLongitude),
            infoWindow: InfoWindow(title: widget.empid)
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    if (('$currentLatitude'!=null) && ('$currentLongitude'!=null)) {
      return new Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: new Text("Tracking"),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                Visibility(
                  child: new Text("latitude:"+'$currentLatitude',style: new TextStyle(fontSize: _width/25,color: Colors.blue),),
                  visible: false, maintainSize: false, maintainState: true,),
                Visibility(
                  child: new Text("longitude:"+'$currentLongitude',style: new TextStyle(fontSize: _width/25,color: Colors.blue),),
                  visible: false, maintainSize: false,maintainState: true,),
                Visibility(
                  child: new Text("longitude:"+widget.empid,style: new TextStyle(fontSize: _width/25,color: Colors.blue),),
                  visible: false, maintainSize: false,maintainState: true,),
                SizedBox(
                  height: _height/1.15,
                  child: GoogleMap(
                    markers: _markers,
                    mapType: _defaultMapType,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _initialPosition,
                  ),
                ),
              ],
            ),
          )
      );
    }
    else{
      return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: new Text("Tracking"),
        ),
        body: new Center(
          child: const CircularProgressIndicator(),
        ),
      );
    }
  }
}