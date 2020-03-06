import 'dart:async';

import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_altaoss/attendance_add.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:url_launcher/url_launcher.dart';


class  AllEmployeeAttendance extends StatefulWidget{
  AllEmployeeAttendance({Key key, })
      : super(key: key);



  @override
  State<StatefulWidget> createState() => new _AllEmployeeAttendanceState();

}

class _AllEmployeeAttendanceState  extends State<AllEmployeeAttendance>{



  List<Attendance> _attendanceList;


  List<Attendance> itemsattendanceList;


  Attendance temporalattendance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
   DatabaseReference rootref;

  Query query;

  String workinghours=" ";

  StreamSubscription<Event> _onAttendanceAddedSubscription;
  StreamSubscription<Event> _onAttendanceChangedSubscription;

  final DateTime now = DateTime.now();
  DateTime _selectedDate;

  String monthyear,searchdate;





  @override
  void initState() {
    _attendanceList = new List();
    itemsattendanceList = new List();

    rootref=_database.reference().child("Attendance Details");
    query=rootref.reference();


    _onAttendanceAddedSubscription = query.onChildAdded.listen(onEntryAdded);
    _onAttendanceChangedSubscription=query.onChildChanged.listen(onEntryChanged);


    _selectedDate = now;
    monthyear="";
    searchdate="";


  }
  Future<DateTime> selectDateWithDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(0),
      lastDate: DateTime(9999),
    );
  }



  @override
  void dispose() {
    _onAttendanceChangedSubscription.cancel();
    _onAttendanceAddedSubscription.cancel();


    super.dispose();
  }


  onEntryChanged(Event event){
    var oldEntry = _attendanceList.singleWhere((attendance)=>attendance.id==event.snapshot.key);

    setState(() {
      _attendanceList[_attendanceList.indexOf(oldEntry)]=new Attendance.fromSnapshot(event.snapshot);

    });

  }

  onEntryAdded(Event event){
    setState(() {
      _attendanceList.add(new Attendance.fromSnapshot(event.snapshot));
      itemsattendanceList.addAll(_attendanceList);

    });


  }

  void filterMonthYearSerach(String query) {
    List<Attendance> dummySearchList = List<Attendance>();
    dummySearchList.addAll(_attendanceList);
    if(query.isNotEmpty){
      List<Attendance> dummyListData = List<Attendance>();
      dummySearchList.forEach((item){
        DateTime dateTime=DateFormat("yyyy-MM").parse(item.monthandyear.toLowerCase());
        final String text=DateFormat("yyyy-MM").format(dateTime);
        if(text.startsWith(query)){
          dummyListData.add(item);
        }
      });
      setState(() {
        itemsattendanceList.clear();
        itemsattendanceList.addAll(dummyListData);
      });
      return;
    }else{
      Fluttertoast.showToast(
          msg: "Not Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }
  }

  void filterDateSearch(String query) {
    List<Attendance> dummySearchList = List<Attendance>();
    dummySearchList.addAll(_attendanceList);
    if(query.isNotEmpty){
      List<Attendance> dummyListData = List<Attendance>();
      dummySearchList.forEach((item){

        DateTime dateTime=DateFormat("yyyy-MM-dd").parse(item.date.toLowerCase());
        final String text=DateFormat("yyyy-MM-dd").format(dateTime);


        if(text.startsWith(query)){
          dummyListData.add(item);
        }
      });
      setState(() {
        itemsattendanceList.clear();
        itemsattendanceList.addAll(dummyListData);
      });
      return;
    }else{
      Fluttertoast.showToast(
          msg: "Not Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }
  }

  Widget showAttendanceList(){



    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;




    if(itemsattendanceList.length>0){

      setState(() {
        itemsattendanceList.sort((a,b)=>DateFormat("yyyy-MM-dd").parse(a.date).compareTo(DateFormat("yyyy-MM-dd").parse(b.date)));
      });



      return Expanded(
        child: ListView.builder(shrinkWrap:true,
            itemCount: itemsattendanceList.length,
            itemBuilder: (BuildContext context,int index){
              String attendaceId = itemsattendanceList[index].key;
              String empid=itemsattendanceList[index].empid;
              String date=itemsattendanceList[index].date;
              String intime=itemsattendanceList[index].intime;
              String lat=itemsattendanceList[index].lat;
              String longi=itemsattendanceList[index].longi;
              String model=itemsattendanceList[index].modelno;
              String service=itemsattendanceList[index].serviceno;
              String address=itemsattendanceList[index].address;
              String note=itemsattendanceList[index].note;


              String outlat=itemsattendanceList[index].outlat;
              String outlongi=itemsattendanceList[index].outlongi;
              String outmodel=itemsattendanceList[index].outmodelno;
              String outservice=itemsattendanceList[index].outserviceno;
              String outtime=itemsattendanceList[index].outtime;
              String outaddress=itemsattendanceList[index].outaddress;
              String outnote=itemsattendanceList[index].outnote;

              if(outtime!="not logged out"){
                var date1=DateFormat("hh:mm:ss aa").parse(intime.toUpperCase());
                var date2=DateFormat("hh:mm:ss aa").parse(outtime.toUpperCase());

                var diff=date2.difference(date1).toString();
                workinghours=diff.toString();
              }



              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(date,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/25, color: Colors.black87),),

                  new Container(
                    child:  new Card(
                      color: Colors.blueGrey,
                      child:new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //new Text(date,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/25, color: Colors.black87),),
                            new InkWell(
                              onTap: (){
                                MapUtils.openMap(double.tryParse(lat), double.tryParse(longi));
                              },
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Logged-In:", style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20,color: Colors.amber),),
                                      new Text(intime,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),),
                                    ],
                                  ),
                                  new Text(address,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color:Colors.white70),),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Note:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20,color: Colors.redAccent),),
                                      Flexible(child: note==null?new Text("note",overflow: TextOverflow.clip,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),):new Text(note,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),),)

                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("ModelNo:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/30,color: Colors.brown),),
                                      model==null?new Text("modelno",style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),):new Text(model,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),),
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("ServiceNo:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/30,color: Colors.brown),),
                                      service==null?new Text("serviceno",style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),):new Text(service,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            new Divider(height: _height/30,color: Colors.black),
                            outtime=="not logged out"?new InkWell(
                              onTap: (){
                                Fluttertoast.showToast(
                                    msg: "Not Logged Out",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Logged-Out:", style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20,color: Colors.amber),),
                                      new Text(outtime,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),),
                                    ],
                                  ),
                                  new Text(outaddress,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color:Colors.white70),),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Note:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20,color: Colors.redAccent),),
                                      outnote==null?new Text("note",overflow: TextOverflow.ellipsis,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),):new Text(outnote,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),),
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("ModelNo:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/30,color: Colors.brown),),
                                      Flexible(child:outmodel==null?new Text("modelno",style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),) :new Text(outmodel,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),),)
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("ServiceNo:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/30,color: Colors.brown),),
                                      outservice==null?new Text("serviceno",style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),):new Text(outservice,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),),
                                    ],
                                  ),

                                  outtime=="not logged out"?new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Total Working Hours:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/25,color: Colors.deepOrangeAccent),),
                                      new Text(outtime,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/27,color: Colors.green),)

                                    ],
                                  ): new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Total Working Hours:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/25,color: Colors.deepOrangeAccent),),
                                      new Text(workinghours.toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/27,color: Colors.green),)

                                    ],
                                  ),
                                ],
                              ),
                            ): new InkWell(

                              onTap: (){
                                MapUtils.openMap(double.tryParse(outlat), double.tryParse(outlongi));
                              },
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Logged-Out:", style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20,color: Colors.amber),),
                                      new Text(outtime,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),),
                                    ],
                                  ),
                                  new Text(outaddress,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color:Colors.white70),),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Note:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20,color: Colors.redAccent),),
                                      outnote==null?new Text("note",overflow: TextOverflow.ellipsis,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),):new Text(outnote,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/25,color: Colors.black87),),
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("ModelNo:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/30,color: Colors.brown),),
                                      Flexible(child:outmodel==null?new Text("modelno",style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),) :new Text(outmodel,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),),)
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("ServiceNo:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/30,color: Colors.brown),),
                                      outservice==null?new Text("serviceno",style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),):new Text(outservice,style:  TextStyle(fontWeight: FontWeight.normal,fontSize: _width/30,color: Colors.black87),),
                                    ],
                                  ),

                                  outtime=="not logged out"?new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Total Working Hours:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/25,color: Colors.deepOrangeAccent),),
                                      new Text(outtime,style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/27,color: Colors.green),)

                                    ],
                                  ): new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text("Total Working Hours:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/25,color: Colors.deepOrangeAccent),),
                                      new Text(workinghours.toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/27,color: Colors.green),)

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),),

                    ),
                    decoration: new BoxDecoration(boxShadow: [new BoxShadow(color: Colors.black,blurRadius: 20.0,)]),
                  ),

                ],
              );

            }),
      );

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



    return Scaffold(

      appBar:  AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),

            Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
          ],
        ),        )
      ,

      body:

      new Column(

        children: <Widget>[



          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  color: Colors.blue,
                  child: searchdate.isEmpty? Text("Select date", style: TextStyle(color: Colors.white)):Text(searchdate, style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    DateTime selected = await selectDateWithDatePicker(context);

                    if (selected != null) {
                      setState(() {
                        _selectedDate = selected;
                        searchdate= DateFormat("yyyy-MM-dd").format(_selectedDate);
                        monthyear="";

                      });
                    }
                  }),
              new RaisedButton(onPressed:(){

                filterDateSearch(searchdate.toString());
              },
                color: Colors.black87,
                child: const Text("GO",style: TextStyle(color:Colors.white),),)

            ],
          ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  color: Colors.blue,
                  child:monthyear.isEmpty? Text("Select Month and Year", style: TextStyle(color: Colors.white)):Text(monthyear, style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    showMonthPicker(context: context,
                        firstDate: DateTime(0),
                        lastDate: DateTime(9999),
                        initialDate: _selectedDate).then((date){
                      if(date!=null){
                        setState(() {
                          _selectedDate=date;
                          monthyear=DateFormat("yyyy-MM").format(_selectedDate);
                          searchdate="";
                        });
                      }
                    });
                  }),
              new RaisedButton(onPressed:(){

                filterMonthYearSerach(monthyear.toString());
              },
                color: Colors.black87,

                child: const Text("GO",style: TextStyle(color:Colors.white),),)


            ],
          ),

          new RaisedButton(onPressed: (){
            setState(() {
              itemsattendanceList.clear();
              itemsattendanceList.addAll(_attendanceList);
              searchdate="";
              monthyear="";
            });
             },color: Colors.blue,child: Text("Show All", style: TextStyle(color: Colors.white)) ,),


          showAttendanceList(),

        ],
      ),

    );

  }

}

class MapUtils{

  MapUtils._();

  static Future<void> openMap(double latitude,double longitude) async {
    String googleUrl =  'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if(await canLaunch(googleUrl)){
      await launch(googleUrl);

    }else{
      throw 'Could not open the map';
    }

  }
}