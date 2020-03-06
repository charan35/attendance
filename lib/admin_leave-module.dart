


import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_altaoss/admin_leave_history.dart';
import 'package:flutter_altaoss/apply_leave_form_class.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AdminLeaveModule extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new _AdminLeaveModuleState();
}

class _AdminLeaveModuleState extends State<AdminLeaveModule> {

  bool buttonState=false;

  List<ApplyLeaveForm> _leavehistory;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Query query;

  ProgressDialog pr;


  StreamSubscription<Event> _onLeaveAddedSubscription;
  StreamSubscription<Event> _onLeaveChangedSubscription;

  @override
  void initState() {
    _leavehistory = new List();

    query=_database.reference().child("Leaves").orderByChild("status").equalTo("Leave Request");

    _onLeaveAddedSubscription = query.onChildAdded.listen(onEntryAdded);
    _onLeaveChangedSubscription=query.onChildChanged.listen(onEntryChanged);

  }

  @override
  void dispose() {
    _onLeaveChangedSubscription.cancel();
    _onLeaveAddedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event){
    var oldEntry = _leavehistory.singleWhere((leaves)=>leaves.key==event.snapshot.key);
    setState(() {
      _leavehistory[_leavehistory.indexOf(oldEntry)]=new ApplyLeaveForm.fromSnapshot(event.snapshot);
    });

  }

  onEntryAdded(Event event){
    setState(() {
      _leavehistory.add(new ApplyLeaveForm.fromSnapshot(event.snapshot));
    });
  }

  void _buttonChange(){
    setState(() {
      buttonState=true;
    });
  }


  Widget showEmployeeLeaveHistory(){

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if(_leavehistory.length>0){
      return  new Expanded( child:ListView.builder(shrinkWrap:true,
          //physics: AlwaysScrollableScrollPhysics(),
          itemCount: _leavehistory.length,
          itemBuilder: (BuildContext context,int index){
            String leavehistoryId = _leavehistory[index].key;
            String empid=_leavehistory[index].empid;
            String leavetype=_leavehistory[index].leavetype;
            String fromdate=_leavehistory[index].fromdate;
            String todate=_leavehistory[index].todate;
            String noofdays=_leavehistory[index].noofdays;
            String applyto=_leavehistory[index].applyto;
            String reason=_leavehistory[index].reason;
            String status=_leavehistory[index].status;
            String month=_leavehistory[index].month;
            String year=_leavehistory[index].year;
            String monthandyear=_leavehistory[index].monthandyear;
            String empidmonthandyear=_leavehistory[index].empidmonthandyear;
            String empidyear=_leavehistory[index].empidyear;
            String description=_leavehistory[index].description;


            return new Container(
              child: Card(
                child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                  new Text(empid,style: TextStyle(fontWeight: FontWeight.bold, fontSize: _width/20, color: Colors.blue,),textAlign: TextAlign.left,),
                  new Text("Leave type: "+leavetype,style: TextStyle(fontWeight: FontWeight.bold, fontSize: _width/25, color: Colors.teal),textAlign: TextAlign.left,),
                  new Text("From Date: "+fromdate,style: TextStyle(fontWeight: FontWeight.normal, fontSize: _width/30, color: Colors.black87),textAlign: TextAlign.left,),
                  new Text("To date: "+todate,style: TextStyle(fontWeight: FontWeight.normal, fontSize: _width/30, color: Colors.black87),textAlign: TextAlign.left,),
                  new Text("No.ofdays: "+noofdays,style: TextStyle(fontWeight: FontWeight.bold, fontSize: _width/30, color: Colors.black87),textAlign: TextAlign.left,),
                  new Text(applyto,style: TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25, color: Colors.black87),textAlign: TextAlign.left,),
                  new Text(description,style: TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25, color: Colors.deepOrangeAccent),textAlign: TextAlign.left,),
                  new Text(status,style: TextStyle(fontWeight: FontWeight.bold, fontSize: _width/25, color: Colors.lightBlue),textAlign: TextAlign.left,),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new FlatButton(onPressed: (){
                        pr.show();

                        Future.delayed(Duration(seconds: 3)).then((value){
                          pr.hide().whenComplete((){

                            setState(() {
                              _database.reference().child("Leaves").child(leavehistoryId).child("status").set("Approved");
                              initState();
                            });

                          });
                        });
                      },
                        color: Colors.green,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            new Text("Approve"),
                          ],
                        ),
                      ),
                      new FlatButton(onPressed: (){
                        pr.show();

                        Future.delayed(Duration(seconds: 3)).then((value){
                          pr.hide().whenComplete((){

                            setState(() {
                              _database.reference().child("Leaves").child(leavehistoryId).child("status").set("Rejected");
                              initState();
                            });

                          });
                        });
                      },
                        color: Colors.red,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text("Reject"),
                          ],
                        ),
                      ),
                    ],
                  ),
                 ],
              ),
            ),
              decoration: new BoxDecoration(boxShadow: [new BoxShadow(color: Colors.black,blurRadius: 20.0,)]),

            );
          }));

    }
    else{
      return Center(
        child:const CircularProgressIndicator(),

      );
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
      message: "Loading...!",
      progressWidget: Container(
        padding: EdgeInsets.all(6.0),child: CircularProgressIndicator(),
      ),
      progressTextStyle: TextStyle(
          color:Colors.black,fontSize: 13.0,fontWeight: FontWeight.w400
      ),
      messageTextStyle: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),

            Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
          ],
        ),      ),

      body: new Column(
        children: <Widget>[
          new RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15.0)),
              child: Text(
                "Applied Leaves",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.black,
              color: Colors.amberAccent,
              onPressed: () {
                _buttonChange();
              }),

          new RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15.0)),
              child: Text(
                "Leave History",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.black,
              color: Colors.amberAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLeaveHistory(),
                  ),
                );

              }),

          SizedBox(
            height: 25,
          ),

          new Divider(height: _height/25,color: Colors.black54),

          buttonState==true?showEmployeeLeaveHistory():new Column(),
        ],
      ),

       /*new ListView(
         physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                new Center(
                  child: new Container(
                    padding: const EdgeInsets.all(8.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15.0)),
                            child: Text(
                              "Applied Leaves",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            textColor: Colors.black,
                            color: Colors.amberAccent,
                            onPressed: () {
                              _buttonChange();
                            }),

                        new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15.0)),
                            child: Text(
                              "Leave History",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            textColor: Colors.black,
                            color: Colors.amberAccent,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AdminLeaveHistory(),
                                ),
                              );

                            }),

                        SizedBox(
                          height: 25,
                        ),

                        new Divider(height: _height/25,color: Colors.black54),

                       buttonState==true?showEmployeeLeaveHistory():new Column(),
                      ],

                    ),

                  ),
                ),
              ],
        ),*/


    );
  }


}