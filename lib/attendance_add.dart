

import 'package:firebase_database/firebase_database.dart';

class Attendance{
  String key;
  String id,intime,empid,lat,longi,outtime,date,address,status,monthandyear,outlat,
      outlongi,outaddress,note,outnote,serviceno,modelno,outserviceno,outmodelno;


  Attendance(this.id, this.intime,
      this.empid, this.lat, this.longi, this.outtime, this.date, this.address,
      this.status, this.monthandyear, this.outlat, this.outlongi,
      this.outaddress, this.note, this.outnote, this.serviceno, this.modelno,
      this.outserviceno, this.outmodelno);

  Attendance.fromSnapshot(DataSnapshot snapshot):

      key = snapshot.key,
      id = snapshot.value["id"],
        intime=snapshot.value["intime"],

      empid=snapshot.value["empid"],
      lat=snapshot.value["lat"],
        longi=snapshot.value["longi"],
        outtime=snapshot.value["outtime"],
        date=snapshot.value["date"],
        address=snapshot.value["address"],
        status=snapshot.value["status"],
        monthandyear=snapshot.value["monthandyear"],
        outlat=snapshot.value["outlat"],
        outlongi=snapshot.value["outlongi"],
        outaddress=snapshot.value["outaddress"],
        note=snapshot.value["note"],
        outnote=snapshot.value["outnote"],
        serviceno=snapshot.value["serviceno"],
        modelno=snapshot.value["modelno"],
        outserviceno=snapshot.value["outserviceno"],
        outmodelno=snapshot.value["outmodelno"];


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


}