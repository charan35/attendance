import 'package:firebase_database/firebase_database.dart';

class EmployeeList{
  String key;
  String userid,empid,name,department,imageurl,lastname,middlename;


  EmployeeList(this.userid,
      this.empid,this.department,this.name,this.imageurl,this.lastname,this.middlename);

  EmployeeList.fromSnapshot(DataSnapshot snapshot):

        key = snapshot.key,
        userid = snapshot.value["userId"],
        empid=snapshot.value["empid"],
        name=snapshot.value["name"],
        lastname=snapshot.value["lastname"],
        department=snapshot.value["department"],
        middlename=snapshot.value["middlename"],
        imageurl=snapshot.value["imageURL"];






/*
  toJson(){
    return {
      "id":id,
      "intime":intime,
      "empid":empid,
      "lat":lat,
      "longi":longi,
      "outtime":outtime,
      "date":date,
      "address":address,
      "status":status,
      "monthandyear":monthandyear,
      "outlat":outlat,
      "outlongi":outlongi,
      "outaddress":outaddress,
      "note":note,
      "outnote":outnote,
      "outserviceno":outserviceno,
      "modelno":modelno,
      "serviceno":serviceno,
      "outmodelno":outmodelno,
    };
  }
*/


}