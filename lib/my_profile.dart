import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_dialog/progress_dialog.dart';


class MyProfile extends StatefulWidget{

  MyProfile({Key key,  this.userId, })
      : super(key: key);

  String userId;

  @override
  State<StatefulWidget> createState() => new _MyProfileState();

    // TODO: implement createState
  }

class _MyProfileState extends State<MyProfile> {

  String name="",email="",imageUrl="",empid="",mobile="",department="",designation="",lastname="",middlename="";

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Query query;

  bool _saving  = false;
  ProgressDialog pr;




  @override
  void initState() {
    super.initState();

    query=_database.reference().child("Users").orderByChild("userId").equalTo(widget.userId);

    query.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        setState(() {
          email=values["email"];
          name=values["name"];
          empid=values["empid"];
          imageUrl=values["imageURL"];
          mobile=values["phone"];
          department=values["department"];
          designation=values["designation"];
          lastname=values["lastname"];
          middlename=values["middlename"];


          print(values["name"]);
          print(values["email"]);
          print(values["empid"]);
          print(values["imageURL"]);
          print(values["mobile"]);
          print(values["department"]);
          print(values["designation"]);
          print(values["middlename"]);
          print(values["lastname"]);
        });


      });
    });
  }



  @override
  Widget build(BuildContext context) {


    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if((empid!=null) && (email!=null) && (name!=null) && (imageUrl!=null) && (department!=null)&&(designation!=null)){
      return new Stack(children: <Widget>[
        new Container(color: Colors.blue,),
        new Image.network(imageUrl, fit: BoxFit.fill,),
        new BackdropFilter(
            filter: new ui.ImageFilter.blur(
              sigmaX: 6.0,
              sigmaY: 6.0,
            ),
            child: new Container(
              decoration: BoxDecoration(
                color:  Colors.transparent.withOpacity(0.9),
                // borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),)),
        new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.blueGrey,
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),

                Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
              ],
            ),            centerTitle: false,
            elevation: 0.0,
          ),
          backgroundColor: Colors.transparent,
          body:
          new Center(

            child: new Column(

              children: <Widget>[
                new SizedBox(height: _height/12,),
                new CircleAvatar(radius:_width<_height? _width/4:_height/4,backgroundImage: NetworkImage(imageUrl),),
                new SizedBox(height: _height/25.0,),
                new Text(empid, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.white),),
                new SizedBox(height: _height/25.0,),
                middlename==null?new Text(name+" "+lastname, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.white),):new Text(name+" "+middlename+" "+lastname, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.white),),

                new Padding(padding: new EdgeInsets.only(top: _height/30, left: _width/8, right: _width/8),
                  child:new Text(email,
                    style: new TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25,color: Colors.white),textAlign: TextAlign.center,) ,),
                new Divider(height: _height/30,color: Colors.white,),
                new Row(
                  children: <Widget>[
                    rowCell(Icons.assignment,"Department", department,_width,_height),
                    rowCell(Icons.settings_applications,"Designation", designation,_width,_height),
                    rowCell(Icons.phone, "Phone", mobile, _width, _height),
                  ],
                ),
                new Divider(height: _height/30,color: Colors.white),
              ],
            ),
          ),
        ),
      ],
      );
    }
    else{
      return Scaffold(
        appBar: AppBar(
          title: Text('Alta Attendance'),
        ),
        body: new Center(
          child:const CircularProgressIndicator(),
        ),
      );    }



  }



  }

Widget rowCell(IconData icon,String dept, String type,double width,double height) => new Expanded(child: new Column(children: <Widget>[

  new Icon(icon,color: Colors.lightBlue,),
  //new Text('$dept',style: new TextStyle(fontWeight: FontWeight.normal,fontSize: width/25, color: Colors.white),),
  new Text(type,style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.white,))
],
)
);



