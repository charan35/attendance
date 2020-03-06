/*
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_altaoss/login_register.dart';
import 'package:flutter_altaoss/services/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String dept,depart;
  String department,empid;



  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Query query;


  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          depart=dept;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback(String dep) {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
      dept=dep;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new Login(
          auth: widget.auth,
          loginback: loginCallback,

        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          query=_database.reference().child("Users").orderByChild("userid").equalTo(_userId);
          query.once().then((DataSnapshot snapshot){
            Map<dynamic, dynamic> values = snapshot.value;
            values.forEach((key,values) {
              setState(() {
                department=values["department"];
                empid=values["empid"];
                print(values["department"]);
                empid=values["empid"];
              });
            });
          });

          if(dept=="Employee"&&empid.startsWith("E")){
            */
/*return new MainMenu(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
              depart: dept,
            );*//*

            Fluttertoast.showToast(
                msg: "Welcome to "+dept + empid ,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white);

          }
          if((dept=="HR") && (empid.startsWith("E"))||(empid.startsWith("H"))){

            Fluttertoast.showToast(
                msg: "Welcome to "+dept + empid ,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white);

          }
          if((dept=="Admin") && (empid.startsWith("E"))||(empid.startsWith("H"))||(empid.startsWith("E"))){

            Fluttertoast.showToast(
                msg: "Welcome to "+dept + empid ,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white);

          }




        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
*/
