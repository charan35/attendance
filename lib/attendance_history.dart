import 'dart:async';

import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_altaoss/attendance_add.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart';

/*/// Type of date picker for [FlutterDatePicker] to use.
///
/// This is primarily used as an internal mechanism for the various accessors
/// ([showYearPicker], [showMonthPicker], [showDayPicker]) to signal their
/// required picker type, but is exposed to support direct instantiation of
/// [FlutterDatePicker], where desired.
enum FlutterDatePickerMode {
  /// Show a date picker for choosing a day.
  day,

  /// Show a date picker for choosing a month.
  month,

  /// Show a date picker for choosing a year.
  year,
}

/// Select a year by calling the [YearPicker] class directly.
Future<DateTime> showYearPicker({
  @required BuildContext context,
  @required DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  Widget title,
  EdgeInsetsGeometry titlePadding,
}) async {
  assert(context != null);
  assert(initialDate != null);

  return await showDialog(
    context: context,
    builder: (context) => FlutterDatePicker(
      mode: FlutterDatePickerMode.year,
      selectedDate: initialDate,
      firstDate: firstDate ?? DateTime(2019),
      lastDate: lastDate ?? DateTime.now(),
      title: title,
      titlePadding: titlePadding,
    ),
  );
}

/// Select a month by calling the [MonthPicker] class directly.
Future<DateTime> showMonthPicker({
  @required BuildContext context,
  @required DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  Widget title,
  EdgeInsetsGeometry titlePadding,
}) async {
  assert(context != null);
  assert(initialDate != null);

  return await showDialog(
    context: context,
    builder: (context) => FlutterDatePicker(
      mode: FlutterDatePickerMode.month,
      selectedDate: initialDate,
      firstDate: firstDate ?? DateTime(0),
      lastDate: lastDate ?? DateTime(9999),
      title: title,
      titlePadding: titlePadding,
    ),
  );
}

/// Select a day by calling the [DayPicker] class directly.
Future<DateTime> showDayPicker({
  @required BuildContext context,
  @required DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  Widget title,
  EdgeInsetsGeometry titlePadding,
}) async {
  assert(context != null);
  assert(initialDate != null);

  return await showDialog(
    context: context,
    builder: (context) => FlutterDatePicker(
      mode: FlutterDatePickerMode.day,
      selectedDate: initialDate,
      firstDate: firstDate ?? DateTime(0),
      lastDate: lastDate ?? DateTime(9999),
      title: title,
      titlePadding: titlePadding,
    ),
  );
}

/// A non-cascading [SimpleDialog] view of a [FlutterDatePickerMode] picker.
///
/// In general this class does not need to be used directly, and should
/// be primarily accessed through the [showYearPicker], [showMonthPicker]
/// and [showDayPicker] convenience wrappers.
class FlutterDatePicker extends StatefulWidget {
  final FlutterDatePickerMode mode;
  final EdgeInsetsGeometry titlePadding;
  final Widget title;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;

  FlutterDatePicker(
      {Key key,
        @required this.mode,
        this.title,
        this.titlePadding,
        @required this.selectedDate,
        @required this.firstDate,
        @required this.lastDate})
      : assert(!firstDate.isAfter(lastDate)),
        assert(
        selectedDate.isAfter(firstDate) && selectedDate.isBefore(lastDate)),
        super(key: key);

  @override
  _FlutterDatePickerState createState() => _FlutterDatePickerState();
}

class _FlutterDatePickerState extends State<FlutterDatePicker> {
  final GlobalKey _pickerKey = GlobalKey();
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  Widget _defaultPickerHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Text("Select a " + describeEnum(widget.mode),
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Colors.white)),
        color: Theme.of(context).primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        titlePadding: widget.titlePadding ?? widget.title == null
            ? EdgeInsets.all(0)
            : EdgeInsets.all(20.0),
        title: widget.title ?? _defaultPickerHeader(context),
        children: <Widget>[
          Container(
            height: 300,
            width: double.maxFinite,
            child: widget.mode == FlutterDatePickerMode.year
                ? YearPicker(
              key: _pickerKey,
              firstDate: widget.firstDate,
              selectedDate: _selectedDate,
              lastDate: widget.lastDate,
              onChanged: (DateTime selected) {
                setState(() {
                  _selectedDate = selected;
                });
              },
            )
                : widget.mode == FlutterDatePickerMode.month
                ? MonthPicker(
              key: _pickerKey,
              firstDate: widget.firstDate,
              selectedDate: _selectedDate,
              lastDate: widget.lastDate,
              onChanged: (DateTime selected) {
                setState(() {
                  _selectedDate = selected;
                });
              },
            )
                : DayPicker(
              key: _pickerKey,
              displayedMonth: widget.selectedDate,
              firstDate: widget.firstDate,
              selectedDate: _selectedDate,
              currentDate: DateTime.now(),
              lastDate: widget.lastDate,
              onChanged: (DateTime selected) {
                setState(() {
                  _selectedDate = selected;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold)),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedDate);
                },
                child: Text('OK',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ]);
  }
}*/



class  AttendanceHistory extends StatefulWidget{
  AttendanceHistory({Key key, this.userId, this.empid })
      : super(key: key);

  String userId;
  String empid;

  @override
  State<StatefulWidget> createState() => new _AttendanceHistoryState();

}

class _AttendanceHistoryState  extends State<AttendanceHistory>{



    List<Attendance> _attendanceList;


    List<Attendance> itemsattendanceList;


    Attendance temporalattendance;

    final FirebaseDatabase _database = FirebaseDatabase.instance;

    Query query;

    String workinghours=" ";

    StreamSubscription<Event> _onAttendanceAddedSubscription;
    StreamSubscription<Event> _onAttendanceChangedSubscription;

    final DateTime now = DateTime.now();
    DateTime _selectedDate;

    String monthyear,searchdate,year;

    ProgressDialog pr;



    //FlutterDatePickerMode _mode;
    int _result;



    @override
  void initState() {
    _attendanceList = new List();
    itemsattendanceList = new List();

   query=_database.reference().child("Attendance Details").child(widget.empid).orderByChild("empid").equalTo(widget.empid);

    _onAttendanceAddedSubscription = query.onChildAdded.listen(onEntryAdded);
    _onAttendanceChangedSubscription=query.onChildChanged.listen(onEntryChanged);

    _result = 0;

    _selectedDate = now;
    monthyear="";
    searchdate="";
    year="";


  }
    /*Future<DateTime> selectDateWithDatePicker(BuildContext context) async {
      return await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(0),
        lastDate: DateTime(9999),
      );
    }*/

    Future<Null> selectDateWithDatePicker(BuildContext context)async{
      final DateTime picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2019,11), lastDate: DateTime.now());
      if(picked !=null&& picked !=_selectedDate){
        setState(() {
          _selectedDate=picked;
          searchdate= DateFormat("yyyy-MM-dd").format(_selectedDate);
          monthyear="";
          year="";

        });
        filterDateSearch(searchdate.toString());

      }
    }



    @override
    void dispose() {
      _onAttendanceChangedSubscription.cancel();
      _onAttendanceAddedSubscription.cancel();


      super.dispose();
    }


    onEntryChanged(Event event){
      var oldEntry = _attendanceList.singleWhere((attendance)=>attendance.id==event.snapshot.key);

      var oldEntry1=itemsattendanceList.singleWhere((attendance)=>attendance.id==event.snapshot.key);

      setState(() {
        _attendanceList[_attendanceList.indexOf(oldEntry)]=new Attendance.fromSnapshot(event.snapshot);
        itemsattendanceList[itemsattendanceList.indexOf(oldEntry1)]=new Attendance.fromSnapshot(event.snapshot);


      });

    }

    onEntryAdded(Event event){
      setState(() {
        _attendanceList.add(new Attendance.fromSnapshot(event.snapshot));

        itemsattendanceList.add(new Attendance.fromSnapshot(event.snapshot));

      });


    }

    void filterYearSerach(String query) {
      List<Attendance> dummySearchList = List<Attendance>();
      dummySearchList.addAll(_attendanceList);
      if(query.isNotEmpty){
        List<Attendance> dummyListData = List<Attendance>();
        dummySearchList.forEach((item){
          DateTime dateTime=DateFormat("yyyy").parse(item.monthandyear.toLowerCase());
          final String text=DateFormat("yyyy").format(dateTime);
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
            child: CircularProgressIndicator(),
          );
          /*pr.show();
          Future.delayed(Duration(seconds: 3)).then((value){
            pr.hide().whenComplete((){
              if(itemsattendanceList.length>0){

              }
              else{
                Fluttertoast.showToast(
                    msg: "Value not found",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white);
              }

            });
          });  */
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
          ),        )
        ,

        body:

         new Column(

            children: <Widget>[

              new Text(widget.empid,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.blueAccent),),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                      color: Colors.blue,
                      child: searchdate.isEmpty? Text("Date", style: TextStyle(color: Colors.white)):Text(searchdate, style: TextStyle(color: Colors.white)),
                      onPressed: () =>selectDateWithDatePicker(context)),
                  RaisedButton(
                      color: Colors.blue,
                      child:monthyear.isEmpty? Text("Month and Year", style: TextStyle(color: Colors.white)):Text(monthyear, style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        showMonthPicker(context: context,
                            firstDate: DateTime(2019,11),
                            lastDate: DateTime.now(),
                            initialDate: _selectedDate).then((date){
                          if(date!=null){
                            setState(() {
                              _selectedDate=date;
                              monthyear=DateFormat("yyyy-MM").format(_selectedDate);
                              searchdate="";
                            });
                            filterMonthYearSerach(monthyear.toString());
                          }
                        });
                      }),

                 /* RaisedButton(onPressed: (){
                    SimpleDialog(
                      title: Container(padding: EdgeInsets.all(20.0),
                         child: Text("Select Month",style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
                        color: Theme.of(context).primaryColor,
                      ),
                      children: <Widget>[
                        Container(
                          height: 300,
                          width: double.maxFinite,

                        )
                      ],

                    );
                   },
                    color: Colors.blue,
                    child:monthyear.isEmpty? Text("Month", style: TextStyle(color: Colors.white)):Text(monthyear, style: TextStyle(color: Colors.white)),
                  ),
                  RaisedButton(onPressed: ()async {
                       DateTime selected = await showYearPicker(
                       context: context,
                       initialDate: _selectedDate,
                     );

                     if (selected != null) {
                       setState(() {
                         _selectedDate = selected;
                         _mode = FlutterDatePickerMode.year;
                         _result = selected.year;
                         year=_result.toString();
                       });
                     }
                   },
                    color: Colors.blue,
                    child:year.isEmpty? Text("Year", style: TextStyle(color: Colors.white)):Text(year, style: TextStyle(color: Colors.white)),
                  ),*/
                  /*new RaisedButton(onPressed:(){

                    filterDateSearch(searchdate.toString());
                    },
                    color: Colors.black87,
                    child: const Text("GO",style: TextStyle(color:Colors.white),),)*/

                ],
              ),


              new RaisedButton(onPressed: (){
                setState(() {
                  itemsattendanceList.clear();
                  itemsattendanceList.addAll(_attendanceList);
                  searchdate="";
                  monthyear="";
                  year="";
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