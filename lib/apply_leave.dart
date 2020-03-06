

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_altaoss/apply_leave_form_class.dart';
import 'package:flutter_altaoss/employee_leave_history.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ApplyLeave extends StatefulWidget{

  ApplyLeave({Key key, this.empid})
      : super(key: key);

  String empid;



  @override
  State<StatefulWidget> createState() => new _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave>{

  String monthandyear,noofdays,reason,year,applyto,empidmonthandyear,empidyear,month,status,description;
  String fromdate="0000-00-00",todate="0000-00-00";

  final _key = new GlobalKey<FormState>();


  String leavetype='Casual';
  List <String> spinnerItems=[
    'Casual',
    'Sick',
    'Medical',
    'Half Day',
    'Emergency'
  ];

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DateTime selectFromDate=DateTime.now();

  DateTime selectToDate=DateTime.now();

  Future<Null> _selecFromtDate(BuildContext context)async{
    final DateTime picked = await showDatePicker(context: context, initialDate: selectFromDate, firstDate: DateTime(2015,8), lastDate: DateTime(2101));
    if(picked !=null&& picked !=selectFromDate){
      setState(() {
        selectFromDate=picked;
        fromdate =  DateFormat('yyyy-MM-dd').format(selectFromDate);
        month=DateFormat('MMMM').format(selectFromDate);
        year=DateFormat('yyyy').format(selectFromDate);
        monthandyear=month+year;

      });
    }
  }

  Future<Null> _selectToDate(BuildContext context)async{
    final DateTime picked = await showDatePicker(context: context, initialDate: selectToDate, firstDate: DateTime(2015,8), lastDate: DateTime(2101));
    if(picked !=null&& picked !=selectToDate){
      setState(() {
        selectToDate=picked;
        todate =  DateFormat('yyyy-MM-dd').format(selectToDate);
      });
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _submitleaveform();
    }
  }
   _submitleaveform() async {
    String Empid=widget.empid;
    String LeaveType=leavetype.toString();
    String Reason= reason.toString();
    String FromDate=fromdate.toString();
    String ToDate=todate.toString();
    String Noofdays=noofdays.toString();
    String ApplyTo=applyto.toString();
    String Description=description.toString();
    String Status="Leave Request".toString();
    String Month=month;
    String Year=year;
    String month_year=monthandyear;
    String EmpidMonthandYear=Empid+month_year;
    String EmpidYear=Empid+Year;

    ApplyLeaveForm applyLeaveForm = new ApplyLeaveForm(Empid, LeaveType, Reason, FromDate, ToDate, Noofdays, ApplyTo, Description, Status, Month, Year, month_year, EmpidMonthandYear, EmpidYear);

    _database.reference().child("Leaves").child(Empid+FromDate+month_year).set(applyLeaveForm.toJson());

    Fluttertoast.showToast(
        msg: "Applied Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);


  }

  @override
  Widget build(BuildContext context) {

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),

              Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
            ],
          ),        ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          new Center(
            child: new Container(

              padding: const EdgeInsets.all(8.0),
              color: Colors.blue,

              child: Form(
                key: _key,
                child: new Column(
                  children: <Widget>[

                    new Text("Leave Form",style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/15, color: Colors.black,),textAlign: TextAlign.center,),

                    SizedBox(
                      height: 25,
                    ),

                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text("Leave type:",style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/20,color: Colors.black),),
                        new DropdownButton<String>(
                          value: leavetype,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.red,fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String data){
                            setState(() {
                              leavetype=data;
                            });
                          },
                          items: spinnerItems.map<DropdownMenuItem<String>>((String value){
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    new Card(
                      elevation: 6.0,
                      child: TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please insert Reason";
                          }
                        },
                        onSaved: (e) => reason = e,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),

                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Reason"),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    new Card(
                      elevation: 6.0,
                      child: TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please insert No.Of days";
                          }
                        },
                        onSaved: (e) => noofdays = e,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),

                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "No.of days"),
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        new Text("From Date:"),
                        new Text("${fromdate}"),
                        new RaisedButton(onPressed: ()=>_selecFromtDate(context),
                          child: Text("Select From Date"),
                        ),

                      ],
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        new Text("To Date:"),
                        new Text("${todate}"),
                        new RaisedButton(onPressed: ()=>_selectToDate(context),
                          child: Text("Select To Date"),
                        ),

                      ],
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    new Card(
                      elevation: 6.0,
                      child: TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please insert Applied to";
                          }
                        },
                        onSaved: (e) => applyto = e,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),

                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Applied to"),
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    new Card(
                      elevation: 6.0,
                      child: TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Please insert Description";
                          }
                        },
                        onSaved: (e) => description = e,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),

                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Description"),
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new FlatButton(onPressed: (){
                          check();
                          },
                          color: Colors.amberAccent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              new Text("Submit"),
                            ],
                          ),
                        ),
                        new FlatButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployeeLeaveHistory(empid: widget.empid,)),
                          );
                           },
                          color: Colors.lightBlueAccent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Text("Leave History"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


            ),
          ),
        ],
      ),

    );
  }

}