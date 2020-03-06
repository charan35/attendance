

import 'package:firebase_database/firebase_database.dart';

class ApplyLeaveForm{

  String key;
  String empid,leavetype,reason,fromdate,todate,noofdays,applyto,description,status,month,year,monthandyear,empidmonthandyear,empidyear;

  ApplyLeaveForm(this.empid, this.leavetype, this.reason, this.fromdate,
      this.todate, this.noofdays, this.applyto, this.description, this.status,
      this.month, this.year, this.monthandyear, this.empidmonthandyear,
      this.empidyear);

  ApplyLeaveForm.fromSnapshot(DataSnapshot snapshot):

        key = snapshot.key,


        empid = snapshot.value["empid"],
        leavetype=snapshot.value["leavetype"],

        reason=snapshot.value["reason"],
        fromdate=snapshot.value["fromdate"],
        todate=snapshot.value["todate"],
        noofdays=snapshot.value["noofdays"],
        applyto=snapshot.value["applyto"],
        description=snapshot.value["description"],
        status=snapshot.value["status"],
        month=snapshot.value["month"],
        year=snapshot.value["year"],
        monthandyear=snapshot.value["monthandyear"],
        empidmonthandyear=snapshot.value["empidmonthandyear"],
        empidyear=snapshot.value["empidyear"];



  toJson(){
    return{
      "empid":empid,
      "leavetype":leavetype,
      "reason":reason,
      "fromdate":fromdate,
      "todate":todate,
      "noofdays":noofdays,
      "applyto":applyto,
      "description":description,
      "status":status,
      "month":month,
      "year":year,
      "monthandyear":monthandyear,
      "empidmonthandyear":empidmonthandyear,
      "empidyear":empidyear
    };
  }

}