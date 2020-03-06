


import 'dart:ffi';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_altaoss/apply_leave.dart';
import 'package:flutter_altaoss/attendance_add.dart';
import 'package:flutter_altaoss/attendance_history.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart' as prefix0;
import 'package:flutter/services.dart';




class EmployeeAttendanceLogin extends StatefulWidget{

  EmployeeAttendanceLogin({Key key,  this.userId, })
      : super(key: key);

  String userId;

  @override
  State<StatefulWidget> createState() => new _EmployeeAttendanceLoginState();


}

class _EmployeeAttendanceLoginState extends State<EmployeeAttendanceLogin>{
  GoogleMapController mapController;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Query query;
  String empid,note;
  final _addnotecontroller = TextEditingController();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final Geocoder geocoder=Geocoder();
  Position _currentPosition;
  String _currentAddress;
  double _currentlatitude;
  double _currentlongitude;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  static final DeviceInfoPlugin deviceInfoPlugin=new DeviceInfoPlugin();
  int _markerIdCounter=1;
  String dateformat;
  var monthanddate;
  var time;
  var modelno;
  var serviceno;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    initPlatformState();

    DateTime date=new DateTime.now();
    dateformat =  DateFormat('yyyy-MM-dd').format(date);
    monthanddate=DateFormat('yyyy-MM').format(date);
    time=DateFormat('hh:mm:ss aa').format(date);


    query=_database.reference().child("Users").orderByChild("userId").equalTo(widget.userId);

    query.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        setState(() {

          empid=values["empid"];

          print(values["empid"]);

        });


      });
    });

  }

  Future<Null> initPlatformState()  async{

    try{
      if(Platform.isAndroid){
        AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
        modelno=androidDeviceInfo.manufacturer+" "+androidDeviceInfo.model+" "+androidDeviceInfo.version.release;
        serviceno=androidDeviceInfo.androidId;


      }
      else if(Platform.isIOS){
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;

        modelno=iosDeviceInfo.name+" "+iosDeviceInfo.model+" "+iosDeviceInfo.systemVersion;
        serviceno=iosDeviceInfo.identifierForVendor;

      }
    } on PlatformException{

    }
    if(!mounted)return;

  }



  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: prefix0.LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _currentlatitude=position.latitude;
        _currentlongitude=position.longitude;

      });
      _getAddressFromLatLng();
      _add();

    }).catchError((e) {
      print(e);
    });
  }
  void _intime(){


    String Id=empid+dateformat.toString();
    String InTime=time.toString();
    String Empid=empid;
    String Lat=_currentlatitude.toString();
    String Longi=_currentlongitude.toString();
    String OutTime="not logged out";
    String Date=dateformat.toString();
    String Address=_currentAddress;
    String Status="Present";
    String MonthandYear=monthanddate.toString();
    String Outlat="0.000";
    String Outlongi="0.000";
    String Outaddress="address";
    String Note=note.toString();
    String OutNote="not yet logged out";
    String Serviceno=serviceno.toString();
    String Modelno=modelno.toString();
    String OutServiceno="serviceno";
    String OutModelno="modelno";

    Attendance login=new Attendance(
        Id,InTime,Empid,Lat,Longi,OutTime,Date,Address,Status,MonthandYear,Outlat,Outlongi,
        Outaddress,Note,OutNote,Serviceno,Modelno,OutServiceno,OutModelno);


    _database.reference().child("Attendance Details").child(Empid).child(Id).set(login.toJson());
    Fluttertoast.showToast(
        msg: "Logged-In Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);



  }
  void _outtime(){
    String Id=empid+dateformat.toString();
    String Empid=empid;
    String OutTime=time.toString();
    String Outlat=_currentlatitude.toString();
    String Outlongi=_currentlongitude.toString();
    String Outaddress=_currentAddress.toString();
    String OutServiceno=serviceno.toString();
    String OutModelno=modelno.toString();
    String OutNote=note.toString();


    _database.reference().child("Attendance Details").child(Empid).child(Id).child("outtime").set(OutTime);
    _database.reference().child("Attendance Details").child(Empid).child(Id).child("outlat").set(Outlat);
    _database.reference().child("Attendance Details").child(Empid).child(Id).child("outlongi").set(Outlongi);
    _database.reference().child("Attendance Details").child(Empid).child(Id).child("outaddress").set(Outaddress);
    _database.reference().child("Attendance Details").child(Empid).child(Id).child("outserviceno").set(OutServiceno);
    _database.reference().child("Attendance Details").child(Empid).child(Id).child("outmodelno").set(OutModelno);
    _database.reference().child("Attendance Details").child(Empid).child(Id).child("outnote").set(OutNote);


    Fluttertoast.showToast(
        msg: "Logged-Out Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  void _add(){

    markers.clear();

    final int markerCount=markers.length;
    if(markerCount == 12){
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;

    final MarkerId markerId=MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(_currentlatitude,_currentlongitude),
      infoWindow: InfoWindow(title: markerIdVal,snippet: '*'),

    );

    setState(() {
      markers[markerId]=marker;
    });


  }
  _calculateTime(){
    String firstTime=time.toString();
    String secondTime="09:30:00 AM";
    String thirdTime="03:00:00 PM";

    var date1=DateFormat("hh:mm:ss aa").parse(firstTime);
    var date2=DateFormat("hh:mm:ss aa").parse(secondTime);
    var date3=DateFormat("hh:mm:ss aa").parse(thirdTime);

    var diff=date2.difference(date1).toString();

    if(diff.startsWith("-")){
      _addnote();
    }
    else{
      setState(() {
        note="In-Time";
        _intime();
      });
    }

  }
  _calculateOutTime(){

    String firstTime=time.toString();
    String secondTime="09:30:00 AM";
    String thirdTime="06:30:00 PM";

    var date1=DateFormat("hh:mm:ss aa").parse(firstTime);
    var date2=DateFormat("hh:mm:ss aa").parse(secondTime);
    var date3=DateFormat("hh:mm:ss aa").parse(thirdTime);

    var diff2=date1.difference(date3).toString();

    if(diff2.startsWith("-")){
      _addOutnote();
    }
    else{
      setState(() {
        note="In-Time";
        _outtime();
      });
    }
  }
  _addnote(){
    _addnotecontroller.clear();
    showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password ?'),
          content: new Row(
            children: <Widget>[
              new Expanded(child: new TextField(
                controller: _addnotecontroller,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Enter Note'
                ),
              ))
            ],
          ),
          actions: <Widget>[

            FlatButton(
              child: const Text('OK'),
              onPressed: ()  {
                setState(() {
                  note=_addnotecontroller.text.toString();
                  _intime();
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );

  }
  _addOutnote(){
    _addnotecontroller.clear();
    showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password ?'),
          content: new Row(
            children: <Widget>[
              new Expanded(child: new TextField(
                controller: _addnotecontroller,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Enter Note'
                ),
              ))
            ],
          ),
          actions: <Widget>[

            FlatButton(
              child: const Text('OK'),
              onPressed: ()  {
                setState(() {
                  note=_addnotecontroller.text.toString();
                  _outtime();
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );

  }
  _getAddressFromLatLng() async {
    try {

      final coordinates = new Coordinates(_currentPosition.latitude, _currentPosition.longitude);

      var address= await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first= address.first;


      setState(() {

        _currentAddress=
        "${first.addressLine},${first.adminArea},${first.locality},${first.subLocality}";
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if((_currentPosition != null)&&(_currentAddress!=null)){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),
              Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplyLeave(empid: empid,),
                  ),
                );
              },
              icon: Icon(Icons.assignment),
            )
          ],
        ),
        body:
        new Column(
          children: <Widget>[
            new Text(
                "LAT: ${_currentlatitude}, LNG: ${_currentlongitude}"),
            new Text(_currentAddress),

            SizedBox(
              height: 25,
            ),

            new Expanded(child: new GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _getCurrentLocation(),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentlatitude,_currentlongitude),
                zoom: 11.0,
              ),
              markers: Set<Marker>.of(markers.values),
            ),
            ),
            SizedBox(
              height: 25,
            ),


            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new FlatButton(onPressed: (){

                 _calculateTime();
                 },
                  color: Colors.greenAccent,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Icon(Icons.call_missed,color: Colors.white,),

                        new Text("Log-In"),
                      ],
                    ),
                ),
                new FlatButton(onPressed: (){
                  _calculateOutTime();
                 },
                  color: Colors.redAccent,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Icon(Icons.call_missed_outgoing,color: Colors.white,),
                      new Text("Log-Out"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),

            new FloatingActionButton.extended(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttendanceHistory(userId: widget.userId,empid: empid,),
                ),
              );
              }, label: Text("Attendance History"),backgroundColor: Colors.amber,),


          ],
        ),


      );
    }
    else{
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),

              Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
            ],
          ),          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplyLeave(),
                  ),
                );
              },
              icon: Icon(Icons.assignment,color: Colors.white,),
            )
          ],
        ),
        body: new Center(
          child:const CircularProgressIndicator(),
        ),
      );
    }


  }


}