


import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_altaoss/attendance_history.dart';
import 'package:flutter_altaoss/employee_list.dart';
import 'package:flutter_altaoss/my_profile.dart';

class EmployeeAttendance extends StatefulWidget{



  @override
  State<StatefulWidget> createState() => new _EmployeeAttendanceState();

}

class _EmployeeAttendanceState extends State<EmployeeAttendance>{


  List<EmployeeList> _employeeList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Query query;

  StreamSubscription<Event> _onEmployeeAddedSubscription;
  StreamSubscription<Event> _onEmployeeChangedSubscription;

  @override
  void initState() {

    _employeeList = new List();

    query=_database.reference().child("Users");

    _onEmployeeAddedSubscription = query.onChildAdded.listen(onEntryAdded);
    _onEmployeeChangedSubscription=query.onChildChanged.listen(onEntryChanged);

  }

  @override
  void dispose() {
    _onEmployeeChangedSubscription.cancel();
    _onEmployeeAddedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event){
    var oldEntry = _employeeList.singleWhere((employee)=>employee.userid==event.snapshot.key);
    setState(() {
      _employeeList[_employeeList.indexOf(oldEntry)]=new EmployeeList.fromSnapshot(event.snapshot);
    });

  }

  onEntryAdded(Event event){
    setState(() {
      _employeeList.add(new EmployeeList.fromSnapshot(event.snapshot));
    });
  }

  Widget showEmployeeList(){

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if(_employeeList.length>0){
      return  ListView.builder(shrinkWrap:true,

          itemCount: _employeeList.length,
          itemBuilder: (BuildContext context,int index){

            String userid = _employeeList[index].key;
            String empid=_employeeList[index].empid;
            String name=_employeeList[index].name;
            String lastname=_employeeList[index].lastname;
            String middlename=_employeeList[index].middlename;
            String department=_employeeList[index].department;
            String imageUrl=_employeeList[index].imageurl;
            String userId=_employeeList[index].userid;

            return new InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttendanceHistory(userId: userId,empid: empid,),
                  ),
                );
              },

              child: new Card(
                child: new Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: <Widget>[

                        SizedBox(
                          height: 25,
                        ),

                        new CircleAvatar(radius:25.0,backgroundImage: NetworkImage(imageUrl),),

                        SizedBox(
                          height: 25,
                        ),

                        new VerticalDivider(width: _width/30,color: Colors.black,),

                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            SizedBox(
                              height: 10,
                            ),
                            middlename==null?new Text(name+" "+lastname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.teal,),textAlign: TextAlign.start,):new Text(name+" "+middlename+" "+lastname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.teal,),textAlign: TextAlign.start,),
                            new Text(empid,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30, color: Colors.blue,),textAlign: TextAlign.start,),
                            new Text(department,style: TextStyle(fontWeight: FontWeight.w300,fontSize: _width/30, color: Colors.deepOrangeAccent,),textAlign: TextAlign.start,),

                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],

                    ),

                    //new Divider(height: _height/30,color: Colors.black),
                  ],
                ),
              ),
            );
          });

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

      body: showEmployeeList(),

    );
  }


}