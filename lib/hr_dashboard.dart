import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_altaoss/admin_leave-module.dart';
import 'package:flutter_altaoss/emp_directory_list.dart';
import 'package:flutter_altaoss/employee_attendance.dart';
import 'package:flutter_altaoss/login_register.dart';
import 'package:flutter_altaoss/my_profile.dart';
import 'package:flutter_altaoss/track_user_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';

class DrawerItem {

  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class MainMenu2 extends StatefulWidget {

  MainMenu2({Key key, this.userId,this.depart})
      : super(key: key);


   String userId;
  final String depart;
  //final VoidCallback signOut;
  //MainMenu(this.signOut);

  final drawerItems = [

    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("Reset Password", Icons.lock),
    new DrawerItem("Sign Out", Icons.exit_to_app)
  ];



  @override
  _MainMenu2State createState() => _MainMenu2State();

}
enum ConfirmAction { NO, YES }

class _MainMenu2State extends State<MainMenu2> {
  FirebaseDatabase db=FirebaseDatabase.instance;
  Query query;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int _selectedDrawerIndex = 0;
  _onSelectItem(int index) {
    // setState(() => _selectedDrawerIndex = index);
    switch (index) {
      case 0:
        return new Settings();
      case 1:

        return showDialog<ConfirmAction>(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Reset Password ?'),
              content: const Text(
                  'Are you sure want to change password.'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmAction.NO);
                  },
                ),
                FlatButton(
                  child: const Text('YES'),
                  onPressed: () async {
                    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

                    await _firebaseAuth.sendPasswordResetEmail(email: email);
                    pr.show();

                    Future.delayed(Duration(seconds: 3)).then((value){
                      pr.hide().whenComplete((){
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Reset Password'),
                              content: const Text('Reset Link has been sent to the Registered Email'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    });

                  },
                )
              ],
            );
          },
        );



      case 2:
        signOut();
        break;

      default:
        return new Text("Error");
    }

    Navigator.of(context).pop(); // close the drawer
  }
  ToastMessage(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }
  signOut() async  {
    try{
      await _firebaseAuth.signOut();
      setState(() {
        widget.userId="";
        pr.show();
        Future.delayed(Duration(seconds: 3)).then((value){
          pr.hide().whenComplete((){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  Login(),
              ),
            );
          });
        });
        ToastMessage("User Successfully LoggedOut");
      });
    } catch (e) {
      print(e);
    }
  }
  int currentIndex = 0;
  String selectedIndex = 'TAB: 0';
  String email = "", name = "", id = "",empid = "",imageUrl="",lastname="",middlename="";
  TabController tabController;
  ProgressDialog pr;

  final databaseReference = FirebaseDatabase.instance.reference();
  GoogleMapController mapController;
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubcription;
  Location location = new Location();
  String error;

  void UpdateDatabase(){
    databaseReference.child("Tracking").child(empid).set({
      'empid': empid,
      'latitude': currentLocation['latitude'],
      'longitude': currentLocation['longitude'],
    });
  }


  /*getPref() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");
      empid = preferences.getString("empid");
    });

    print("user" + email);
    print("name" + name);
    print("empid"+empid);
    print("imageUrl"+imageUrl);
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getPref();
    query=db.reference().child("Users").orderByChild("userId").equalTo(widget.userId);
    query.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {

        setState(() {
          email=values["email"];
          name=values["name"];
          empid=values["empid"];
          imageUrl=values["imageURL"];
          lastname=values["lastname"];
          middlename=values["middlename"];
        });
        print("user" + email);
        print("name" + name);
        print("empid"+empid);
        print("imageURL"+imageUrl);
        print("lastname"+lastname);
        print("middlename"+middlename);
      });
    });

    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
    locationSubcription = location.onLocationChanged().listen((Map<String, double> result){
      setState(() {
        currentLocation = result;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(currentLocation['latitude'], currentLocation['longitude']), zoom: 17),
          ),
        );
      });
      UpdateDatabase();
    });
  }
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void initPlatformState() async {
    Map<String, double> my_location;
    try{
      my_location = await location.getLocation();
      error = "";
    }on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Permission denied - please ask the user to enable it from the app settings';
      my_location = null;
    }
    setState(() {
      currentLocation = my_location;
    });
  }


  @override
  Widget build(BuildContext context) {


    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
      message: "Loading...!",
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),child: CircularProgressIndicator(),
      ),
      progressTextStyle: TextStyle(
          color:Colors.black,fontSize: 13.0,fontWeight: FontWeight.w400
      ),
      messageTextStyle: TextStyle(color: Colors.black,fontSize: 19.0,fontWeight: FontWeight.w600),
    );

    if((empid!=null) && (email!=null) && (name!=null) && (imageUrl!=null)){

      var drawerOptions = <Widget>[];
      for (var i = 0; i < widget.drawerItems.length; i++) {
        var d = widget.drawerItems[i];
        drawerOptions.add(
            new ListTile(
              leading: new Icon(d.icon),
              title: new Text(d.title),
              selected: i == _selectedDrawerIndex,
              onTap: () => _onSelectItem(i),
            )
        );
      }

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
         /* actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open),
            )
          ],*/
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(

                accountName: middlename==null?new Text(name+" "+lastname):new Text(name+" "+middlename+" "+lastname),
                accountEmail: new Text(email),
                currentAccountPicture: new CircleAvatar(backgroundImage: NetworkImage(imageUrl),),),
              new Text(empid),

              new Column(children: drawerOptions)
            ],
          ),
        ),



        body:
        new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("Welcome to HR dashboard",style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/15, color: Colors.black,),textAlign: TextAlign.center,),
              SizedBox(
                height: 8.0,
              ),
              new Text(empid,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.lightBlue,),textAlign: TextAlign.center,),
              middlename==null?new Text(name+" "+lastname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.lightBlueAccent,),textAlign: TextAlign.center,):new Text(name+" "+middlename+" "+lastname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.lightBlueAccent,),textAlign: TextAlign.center,),


              Visibility(
                child: Text('Lat/Lng: ${currentLocation['latitude']}/${currentLocation['longitude']}'),
                maintainSize: false,
                maintainAnimation: true,
                maintainState: true,
                visible: false, ),

              Visibility(
                child: SizedBox(
                  width: double.infinity,
                  height: 350.0,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: LatLng(currentLocation['latitude'], currentLocation['longitude']),
                        zoom: 17),
                    onMapCreated: _onMapCreated,
                  ),
                ),
                maintainSize: false,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
              ),

              new Expanded(

                child:Container(
                  padding: EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 16),

                  child: new Center(
                      child:  new GridView.count(crossAxisCount: 2,
                        childAspectRatio: .90,
                        //padding: const EdgeInsets.all(4.0),

                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,

                        children: <Widget>[
                          new FlatButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyProfile(
                                userId: widget.userId,
                              )
                              ),
                            );

                           },
                            color: Colors.white,
                            //padding: EdgeInsets.all(10.0),

                            child: Column(
                              children: <Widget>[
                                Expanded(child:Image.asset('assets/images/profile.jpg'),),
                                new Text("My Profile"),
                              ],
                            ),
                          ),
                          new FlatButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmployeeAttendance(),
                              ),
                            );
                           },
                            color: Colors.white,

                            //padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(child:Image.asset('assets/images/attendance.png'),),
                                new Text("Attendance"),
                              ],
                            ),
                          ),

                          new FlatButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Register(),
                              ),
                            );
                           },
                            color: Colors.white,

                            //padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(child:Image.asset('assets/images/employeeadd.jpg'),),
                                new Text("New Employee Form"),
                              ],
                            ),
                          ),

                          new FlatButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmployeeDirectory(),
                              ),
                            );
                           },
                            color: Colors.white,

                            //padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(child:Image.asset('assets/images/employeeinfo.png'),),
                                new Text("Employee Directory"),
                              ],
                            ),
                          ),
                          new FlatButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminLeaveModule(),
                              ),
                            );
                           },
                            color: Colors.white,

                            //padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(child:Image.asset('assets/images/listicon.png'),),
                                new Text("Leave Module"),
                              ],
                            ),
                          ),

                          new FlatButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TrackList(),
                              ),
                            );
                            },
                            color: Colors.white,
                            //padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(child:Image.asset('assets/images/track.png'),),
                                new Text("Tracking"),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                )


              )
            ],
          ),
        ),




       /* bottomNavigationBar: BottomNavyBar(
          backgroundColor: Colors.black,
          iconSize: 30.0,
//        iconSize: MediaQuery.of(context).size.height * .60,
          currentIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
            });
            selectedIndex = 'TAB: $currentIndex';
//            print(selectedIndex);
            reds(selectedIndex);
          },

          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeColor: Color(0xFFf7d426)),
            BottomNavyBarItem(
                icon: Icon(Icons.view_list),
                title: Text('List'),
                activeColor: Color(0xFFf7d426)),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeColor: Color(0xFFf7d426)),
          ],
        ),*/
      );

    }
    else{

      return Scaffold(
        appBar: AppBar(
          title: Text('AltaOSS'),
        ),
        body: new Center(
          child:const CircularProgressIndicator(),
        ),
      );    }
  }

  //  Action on Bottom Bar Press
  void reds(selectedIndex) {
//    print(selectedIndex);

    switch (selectedIndex) {
      case "TAB: 0":
        {
          callToast("Tab 0");
        }
        break;

      case "TAB: 1":
        {
          callToast("Tab 1");
        }
        break;

      case "TAB: 2":
        {
          callToast("Tab 2");
        }
        break;
    }
  }

  callToast(String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}



