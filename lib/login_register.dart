import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_altaoss/admin_dashboard.dart';
import 'package:flutter_altaoss/employee_attendance_login.dart';
import 'package:flutter_altaoss/hr_dashboard.dart';
import 'package:flutter_altaoss/image_picker_handler.dart';
import 'package:flutter_altaoss/my_profile.dart';
import 'package:flutter_altaoss/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:preferences/preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> with TickerProviderStateMixin {
  //LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  final _key = new GlobalKey<FormState>();
  String dep="",department="",empid="";

  final _resetEmailController = TextEditingController();
  
  AnimationController _logButtonController;
  
  var animationStatus = 0;
  
  bool _secureText = true;

  int _radioValue=-1;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Query query;
  ProgressDialog pr;
  bool checkValue;

  String userId;
  SharedPreferences sharedPreferences;


  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availbleBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listofBiometrics;
    try {
      listofBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availbleBiometricTypes = listofBiometrics;
    });
  }

  Future<void> _authorizedNow() async {
    bool isauthorized = false;
    try {
      isauthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please Authenticate to complete your transaction",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      if (isauthorized) {
       // _authorizedOrNot = "You are Authorized (Hurray 😄)";

        if(empid!=null){


          if((dep=="Admin")&&(empid.startsWith("A"))){

            Future.delayed(Duration(seconds: 3)).then((value){
              pr.hide().whenComplete((){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu1(
                    userId: userId,
                    depart: dep,
                  )
                  ),
                );

              });
            });

          }
          if((dep=="HR") && ((empid.startsWith("H"))||(empid.startsWith("A")))){

            Future.delayed(Duration(seconds: 3)).then((value){
              pr.hide().whenComplete((){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu2(
                    userId: userId,
                    depart: dep,
                  )
                  ),
                );
              });
            });

          }
          if((dep=="Employee") && ((empid.startsWith("E"))||(empid.startsWith("H"))||(empid.startsWith("A")))){

            Future.delayed(Duration(seconds: 3)).then((value){
              pr.hide().whenComplete((){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu(
                    userId: userId,
                    depart: dep,
                  )
                  ),
                );

              });
            });

          }

        }

      } else {
       // _authorizedOrNot = "Not Authorized";

      }
    });
  }



  void _handleRadioValueChange(int value){
    setState(() {
      _radioValue=value;

      switch(_radioValue){
        case 0:
          dep="Admin";
          break;
        case 1:
          dep="HR";
          break;
        case 2:
         dep="Employee";
          break;

      }
    });
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {

    /*loginToast(email);
    loginToast(password);*/

    try{
      pr.show();
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      userId=user.uid;



      if (userId.length > 0 && userId != null) {


        loginToast("User Successfully LoggedIn");
        query=_database.reference().child("Users").orderByChild("userId").equalTo(userId);
        query.once().then((DataSnapshot snapshot){
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key,values) async{
            setState(() {
              empid=values["empid"];
              print(values["empid"]);

            });
            _authorizedNow();
          /*  if(empid!=null){


              if((dep=="Admin")&&(empid.startsWith("A"))){

                Future.delayed(Duration(seconds: 3)).then((value){
                  pr.hide().whenComplete((){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu1(
                        userId: userId,
                        depart: dep,
                      )
                      ),
                    );

                  });
                });

              }
              if((dep=="HR") && ((empid.startsWith("H"))||(empid.startsWith("A")))){

                Future.delayed(Duration(seconds: 3)).then((value){
                  pr.hide().whenComplete((){

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu2(
                        userId: userId,
                        depart: dep,
                      )
                      ),
                    );
                  });
                });

              }
              if((dep=="Employee") && ((empid.startsWith("E"))||(empid.startsWith("H"))||(empid.startsWith("A")))){

                Future.delayed(Duration(seconds: 3)).then((value){
                  pr.hide().whenComplete((){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu(
                        userId: userId,
                        depart: dep,
                      )
                      ),
                    );

                  });
                });

              }

            }*/

            /*sharedPreferences = await SharedPreferences.getInstance();
            setState(() {
              checkValue=sharedPreferences.getBool("fingerprintcheck");
              if(checkValue!=null){
                if(checkValue){
                  _authorizedNow();

                }
                else{
                  if(empid!=null){


                    if((dep=="Admin")&&(empid.startsWith("A"))){

                      Future.delayed(Duration(seconds: 3)).then((value){
                        pr.hide().whenComplete((){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainMenu1(
                              userId: userId,
                              depart: dep,
                            )
                            ),
                          );

                        });
                      });

                    }
                    if((dep=="HR") && ((empid.startsWith("H"))||(empid.startsWith("A")))){

                      Future.delayed(Duration(seconds: 3)).then((value){
                        pr.hide().whenComplete((){

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainMenu2(
                              userId: userId,
                              depart: dep,
                            )
                            ),
                          );
                        });
                      });

                    }
                    if((dep=="Employee") && ((empid.startsWith("E"))||(empid.startsWith("H"))||(empid.startsWith("A")))){

                      Future.delayed(Duration(seconds: 3)).then((value){
                        pr.hide().whenComplete((){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainMenu(
                              userId: userId,
                              depart: dep,
                            )
                            ),
                          );

                        });
                      });

                    }

                  }

                }
              }
              else{
                    checkValue=false;
              }
            });*/

          });
        });

      }



    }
    catch (e) {
      print('Error: $e');
      setState(() {
        loginToast("Failed to login");
        loginToast(e.toString());
        _key.currentState.reset();
      });
    }


  }



  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _logButtonController = new AnimationController(duration: new Duration(milliseconds: 3000),vsync: this);
    
    //getPref();
  }


  @override
  void dispose() {
    _logButtonController.dispose();
    super.dispose();
  }
  
  Future<Null> _playAnimation() async {
    try {
      await _logButtonController.forward();
      await _logButtonController.reverse();
    } on TickerCanceled {}
  }
  
  Future<bool> _onWillPop(){
    return showDialog(context: context,child:new AlertDialog(
      title: new Text('Are you sure?'),
      actions: <Widget>[
        new FlatButton(onPressed: () => Navigator.of(context).pop(false), child: new Text('No'),),
        new FlatButton(onPressed: () => Navigator.pushReplacementNamed(context, ""), child: new Text('Yes'),),
      ],
    ));
  }
  _resetPassword(){

    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password ?'),
          content: new Row(
            children: <Widget>[
              new Expanded(child: new TextField(
                controller: _resetEmailController,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Enter Registered Email'
                ),
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.NO);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () async {
                final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

                try{
                  await _firebaseAuth.sendPasswordResetEmail(email: _resetEmailController.text.toString());

                  pr.show();

                  Future.delayed(Duration(seconds: 3)).then((value){
                    pr.hide().whenComplete((){
                      return showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Reset Password'),
                            content: const Text('Reset Link has been sent to the Registered Email'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  });

                }

                catch (e) {
                  print('Error: $e');
                  pr.show();

                  Future.delayed(Duration(seconds: 3)).then((value){
                    pr.hide().whenComplete((){
                      return showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Reset Password'),
                            content: const Text('Entered Email is incorrect'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  });
                }




              },
            )
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
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
          appBar: new AppBar(
            backgroundColor: Colors.blueGrey,
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),

               Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
              ],
            ),
          ),
          body: Center(
            child:new Container(
              color: Colors.lightBlueAccent,

               child:  ListView(
                 shrinkWrap: true,
                 padding: EdgeInsets.all(15.0),
                 children: <Widget>[
                   Center(
                     child: Container(
                       padding: const EdgeInsets.all(8.0),

                       color: Colors.lightBlueAccent,


                       child: Form(
                         key: _key,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[

                             SizedBox(
                               height: 25,
                             ),

                             Image.asset('assets/images/logo.png',height: 80.0,width: 80.0,fit: BoxFit.contain,),
                             SizedBox(
                               height: 12,
                             ),
                             Container(padding: const EdgeInsets.all(8.0),child: Text('ALTA IT SOLUTIONS',style: TextStyle(color: Colors.white,fontSize: 30.0)),),
                             Container(padding: const EdgeInsets.all(8.0),child: Text('Pack Of Creativity',style: TextStyle(color: Colors.white,fontSize: 15.0)),),

                             //card for Email TextFormField
                             Card(
                               color: Colors.white,
                               elevation: 6.0,
                               child: TextFormField(
                                 initialValue: "kosuricharan@gmail.com",
                                 validator: (e) {
                                   if (e.isEmpty) {
                                     return "Please Insert Username";
                                   }
                                 },
                                 onSaved: (e) => email = e,
                                 style: TextStyle(
                                   color: Colors.black,
                                   fontSize: 16,
                                   fontWeight: FontWeight.w300,
                                 ),
                                 decoration: InputDecoration(
                                     prefixIcon: Padding(
                                       padding:
                                       EdgeInsets.only(left: 20, right: 15),
                                       child:
                                       Icon(Icons.person, color: Colors.black),
                                     ),
                                     contentPadding: EdgeInsets.all(18),
                                     labelText: "Username"),
                               ),
                             ),

                             // Card for password TextFormField
                             Card(
                               color: Colors.white,
                               elevation: 6.0,
                               child: TextFormField(
                                 initialValue: "charan@123",
                                 validator: (e) {
                                   if (e.isEmpty) {
                                     return "Password Can't be Empty";
                                   }
                                 },
                                 obscureText: _secureText,
                                 onSaved: (e) => password = e,
                                 style: TextStyle(
                                   color: Colors.black,
                                   fontSize: 16,
                                   fontWeight: FontWeight.w300,
                                 ),
                                 decoration: InputDecoration(
                                   labelText: "Password",
                                   prefixIcon: Padding(
                                     padding: EdgeInsets.only(left: 20, right: 15),
                                     child: Icon(Icons.phonelink_lock,
                                         color: Colors.black),
                                   ),
                                   suffixIcon: IconButton(
                                     onPressed: showHide,
                                     icon: Icon(_secureText
                                         ? Icons.visibility_off
                                         : Icons.visibility),
                                   ),
                                   contentPadding: EdgeInsets.all(18),
                                 ),
                               ),
                             ),

                             SizedBox(
                               height: 12,
                             ),

                             new Container(
                               padding: EdgeInsets.all(8.0),
                               child: new Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   new Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: <Widget>[
                                       new Icon(Icons.assignment,color:Colors.black),
                                       new Text("Select Department",
                                         style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),

                                     ],
                                   ),
                                   /*new Text("Please Select Department",
                                  style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),*/
                                   new Padding(padding: new EdgeInsets.all(8.0),
                                   ),
                                   new Divider(height: 5.0,color: Colors.black,),
                                   new Padding(padding: new EdgeInsets.all(8.0),),

                                   new Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: <Widget>[
                                       new Radio(value: 0, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.black,
                                       ),
                                       new Text("Admin",
                                         style: new TextStyle(fontSize: 16.0),
                                       ),
                                       new Radio(value: 1, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.black,
                                       ),
                                       new Text("HR",
                                         style: new TextStyle(fontSize: 16.0),
                                       ),
                                       new Radio(value: 2, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.black,
                                       ),
                                       new Text("Employee",
                                         style: new TextStyle(fontSize: 16.0),
                                       ),
                                     ],
                                   ),
                                   new Divider(height: 5.0,color: Colors.black,),

                                 ],
                               ),
                             ),

                             SizedBox(
                               height: 8.0,
                             ),


                             FlatButton(
                               onPressed: _resetPassword,
                               child: Text(
                                 "Forgot Password?",
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontWeight: FontWeight.bold),
                               ),
                             ),

                             Padding(
                               padding: EdgeInsets.all(14.0),
                             ),

                             new Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 SizedBox(
                                   height: 44.0,
                                   child: RaisedButton(
                                       shape: RoundedRectangleBorder(
                                           borderRadius:
                                           BorderRadius.circular(15.0)),
                                       child: Text(
                                         "Login",
                                         style: TextStyle(fontSize: 18.0),
                                       ),
                                       textColor: Colors.white,
                                       color: Color(0xFFf7d426),
                                       onPressed: () {
                                         check();
                                       }),
                                 ),
                                 SizedBox(
                                   height: 44.0,
                                   child: RaisedButton(
                                       shape: RoundedRectangleBorder(
                                           borderRadius:
                                           BorderRadius.circular(15.0)),
                                       child: Text(
                                         "GoTo Register",
                                         style: TextStyle(fontSize: 18.0),
                                       ),
                                       textColor: Colors.white,
                                       color: Color(0xFFf7d426),
                                       onPressed: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) => Register()),
                                         );
                                       }),
                                 ),

                                 SizedBox(
                                   height: 44.0,
                                   child: RaisedButton(
                                       shape: RoundedRectangleBorder(
                                           borderRadius:
                                           BorderRadius.circular(15.0)),
                                       child: Text(
                                         "Services",
                                         style: TextStyle(fontSize: 18.0),
                                       ),
                                       textColor: Colors.white,
                                       color: Color(0xFFf7d426),
                                       onPressed: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) => Services()),
                                         );
                                       }),
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
            )
          ),
        );

  }
}

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register>with TickerProviderStateMixin,ImagePickerListener,SingleTickerProviderStateMixin {


  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  String employeeid, name, email, phone, password,imagepath,filename,department,designation,accountno,answer,bankname,cardname,correspondanceaddress,departmenttype,dob,doj,gender,hrid,
          hrmail,ifsccode,interviewdoneby,interviewschedule,lastname,middlename,officialmail,permanentaddress,personalemail,projectmanagerid,projectmanageremail,referalcode,proofnumber;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  int _radioValue=-1;
  int _radiogendervalue=-1;

  ProgressDialog pr;

  String bloodgroup='Select Blood group';
  List <String> BLOODGROUPSpinner=[
    'Select Blood group',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];
  String idproof='Select Card';
  List <String> IDPROOFSpinner=[
    'Select Card',
    'Aadhar Card',
    'Pan Card',
    'Passport',

  ];

  String securityquestions='Select Security Question';
  List <String> SECURITYQUESTIONSSpinner=[
    'Select Security Question',
    'What is your first Bike?',
    'Your Nick Name?',
    'Your favourite colour?',
    'Your Hobby?',

  ];

  void _handleRadioValueChange(int value){
    setState(() {
      _radioValue=value;

      switch(_radioValue){
        case 0:
          department="Admin";
          break;
        case 1:
          department="HR";
          break;
        case 2:
          department="Employee";
          break;

      }
    });
  }

  void _handleGenderRadioValueChange(int value){
    setState(() {
      _radiogendervalue=value;

      switch(_radiogendervalue){
        case 0:
          gender="Male";
          break;
        case 1:
          gender="Female";
          break;


      }
    });
  }
  DateTime selectdate=DateTime.now();

  Future<Null> _selecFromtDate(BuildContext context)async{
    final DateTime picked = await showDatePicker(context: context, initialDate: selectdate, firstDate: DateTime(2015,8), lastDate: DateTime(2101));
    if(picked !=null&& picked !=selectdate){
      setState(() {
        selectdate=picked;
        dob =  DateFormat('yyyy-MM-dd').format(selectdate);


      });
    }
  }
  Future<Null> _selecinterviewscheduleDate(BuildContext context)async{
    final DateTime picked = await showDatePicker(context: context, initialDate: selectdate, firstDate: DateTime(2015,8), lastDate: DateTime(2101));
    if(picked !=null&& picked !=selectdate){
      setState(() {
        selectdate=picked;
        interviewschedule =  DateFormat('yyyy-MM-dd').format(selectdate);


      });
    }
  }

  Future<Null> _selecdateofjoinDate(BuildContext context)async{
    final DateTime picked = await showDatePicker(context: context, initialDate: selectdate, firstDate: DateTime(2015,8), lastDate: DateTime(2101));
    if(picked !=null&& picked !=selectdate){
      setState(() {
        selectdate=picked;
        doj =  DateFormat('yyyy-MM-dd').format(selectdate);


      });
    }
  }
  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {

    registerToast(email);
    registerToast(password);



    try{
       pr.show();

        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

        AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        FirebaseUser user = result.user;

        final StorageReference ref = FirebaseStorage.instance.ref().child("Profile Pictures").child(filename);
        final StorageUploadTask task= ref.putFile(_image);
        final StorageTaskSnapshot downloadUrl = (await task.onComplete);
        final String url = (await downloadUrl.ref.getDownloadURL());

        _database.reference().child("Users").child(user.uid).set({

          "empid" : employeeid.toString(),
          "name" :  name.toString(),
          "email" : email.toString(),
          "department":department.toString(),
          "password" :  password.toString(),
          "phone": phone.toString(),
          "designation" : designation.toString(),
          "imageURL": url.toString(),
          "userId" : user.uid.toString(),
          "accountno":accountno.toString(),
          "answer":answer,
          "bankname":bankname,
          "bloodgroup":bloodgroup.toString().toString(),
          "cardname":cardname.toString(),
          "correspondanceaddress":correspondanceaddress.toString(),
          "departmenttype":departmenttype.toString(),
          "dob":dob.toString(),
          "doj":doj.toString(),
          "gender":gender.toString(),
          "hrid":hrid.toString(),
          "hrmail":hrmail.toString(),
          "idproof":idproof.toString(),
          "ifsccode":ifsccode.toString(),
          "interviewdoneby":interviewdoneby.toString(),
          "interviewschedule":interviewschedule.toString(),
          "lastname":lastname.toString(),
          "middlename":middlename.toString(),
          "officialemail":officialmail.toString(),
          "permanentaddress":permanentaddress.toString(),
          "personalemail":personalemail.toString(),
          "projectmanagerid":projectmanagerid.toString(),
          "projectmanagermail":projectmanageremail.toString(),
          "proofnumber":proofnumber.toString(),
          "securityquestions":securityquestions.toString(),
        }

        );

        Future.delayed(Duration(seconds: 3)).then((value){
          pr.hide().whenComplete((){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login(),

              ),
            );
          });
        });

        registerToast("User Successfully Registered");
        
      }
      catch(e){
        print('Error: $e');
        setState(() {
          registerToast(e.message.toString());
          registerToast("Failed to register");
          _key.currentState.reset();
        });         
   
      }



  }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {

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
      backgroundColor: Colors.cyan,
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),

            Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
          ],
        ),
      ),
      body: Center(
        child:new Container(
          color: Colors.lightBlueAccent,

           child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.lightBlueAccent,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(
                        height: 50,
                        child: Text(
                            "ALTA IT SOLUTIONS",
                          style: TextStyle(
                            color: Colors.white,fontSize: 30.0
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          "New Employee Form",
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                        
                     new RawMaterialButton(
                       onPressed: ()=> imagePicker.showDialog(context),
                       child: new Center(
                         child: _image == null
                             ? new CircleAvatar(backgroundImage: ExactAssetImage("assets/images/profile.jpg"),radius: 65.0,)
                             :new Container(
                           height: 125.0,
                           width: 125.0,
                           child: Padding(
                             padding: EdgeInsets.all(15),
                             child: CircleAvatar(
                               backgroundColor: Colors.transparent,
                               radius: 100,
                               backgroundImage: new FileImage(_image),
                             ),
                           ),
                           decoration: new BoxDecoration(
                             shape: BoxShape.circle,
                             border: new Border.all(
                               color: Colors.indigo,
                               width: 4.0,
                             )
                           ),
                         )

                       ),

                     ),
                      SizedBox(
                        height: 25,
                      ),
                      //card for Employee Id TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Employee Id";
                            }
                          },
                          onSaved: (e) => employeeid = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.perm_identity, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "EmployeeId"),
                        ),
                      ),
                      //cotainer for select department
                      new Container(
                        padding: EdgeInsets.all(8.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Icon(Icons.assignment,color:Colors.black),
                                new Text("Please Select Department",
                                  style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),

                              ],
                            ),
                            /*new Text("Please Select Department",
                            style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),*/
                            new Padding(padding: new EdgeInsets.all(8.0),
                            ),
                            new Divider(height: 5.0,color: Colors.black,),
                            new Padding(padding: new EdgeInsets.all(8.0),),

                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(value: 0, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.black,
                                ),
                                new Text("Admin",
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(value: 1, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.black,
                                ),
                                new Text("HR",
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(value: 2, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.black,
                                ),
                                new Text("Employee",
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            new Divider(height: 5.0,color: Colors.black,),

                          ],
                        ),
                      ),
                      //card for Department type
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Department type";
                            }
                          },
                          onSaved: (e) => departmenttype = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.settings, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Department Type"),
                        ),
                      ),
                      //card for Designation TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Designation";
                            }
                          },
                          onSaved: (e) => designation = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.settings_applications, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Designation"),
                        ),
                      ),
                      //card for Fullname TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert First Name";
                            }
                          },
                          onSaved: (e) => name = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "First Name"),
                        ),
                      ),
                      //card for middlename
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          /*validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert First Name";
                            }
                          },*/
                          onSaved: (e) => middlename = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Middle Name"),
                        ),
                      ),

                      //card for lastname

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Last Name";
                            }
                          },
                          onSaved: (e) => lastname = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Last Name"),
                        ),
                      ),

                      //card for Email TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Email";
                            }
                          },
                          onSaved: (e) => email = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.email, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Email"),
                        ),
                      ),

                      //card for Password TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          obscureText: _secureText,
                          onSaved: (e) => password = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Password"),
                        ),
                      ),
                      //container for gender
                      new Container(
                        padding: EdgeInsets.all(8.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            new Padding(padding: new EdgeInsets.all(8.0),
                            ),
                            new Divider(height: 5.0,color: Colors.black,),
                            new Padding(padding: new EdgeInsets.all(8.0),),

                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(value: 0, groupValue: _radiogendervalue, onChanged: _handleGenderRadioValueChange,activeColor: Colors.black,
                                ),
                                new Text("Male",
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(value: 1, groupValue: _radiogendervalue, onChanged: _handleGenderRadioValueChange,activeColor: Colors.black,
                                ),
                                new Text("Female",
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            new Divider(height: 5.0,color: Colors.black,),

                          ],
                        ),
                      ),

                      //date picker for dob
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          new Text("Date of Birth"),
                          new Text("${dob}"),
                          new RaisedButton(onPressed: ()=>_selecFromtDate(context),
                            child: Text("select date"),
                          ),

                        ],
                      ),
                      //for blood group
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //new Text("Blood Group:",style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/20,color: Colors.black),),
                          new DropdownButton<String>(
                            value: bloodgroup,
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
                                bloodgroup=data;
                              });
                            },

                            items: BLOODGROUPSpinner.map<DropdownMenuItem<String>>((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      //card type
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                         // new Text("Card Type:",style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/20,color: Colors.black),),
                          new DropdownButton<String>(
                            value: idproof,
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
                                idproof=data;
                              });
                            },
                            items: IDPROOFSpinner.map<DropdownMenuItem<String>>((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      //aadhar card
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please Card Number";
                            }
                          },
                          onSaved: (e) => proofnumber = e,
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
                              labelText: "Card Number"),
                        ),
                      ),

                      //card for Mobile TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Mobile Number";
                            }
                          },
                          onSaved: (e) => phone = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phone, color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "phone",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      //interview schedule
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          new Text("Interview Schedule"),
                          new Text("${interviewschedule}"),
                          new RaisedButton(onPressed: ()=>_selecinterviewscheduleDate(context),
                            child: Text("select date"),
                          ),

                        ],
                      ),
                      //interview done by
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Interview Done By";
                            }
                          },
                          onSaved: (e) => interviewdoneby = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person_pin, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Interview Done By"),
                        ),
                      ),
                      // date of joining
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          new Text("Date of Joining"),
                          new Text("${doj}"),
                          new RaisedButton(onPressed: ()=>_selecdateofjoinDate(context),
                            child: Text("select date"),
                          ),

                        ],
                      ),

                      new Container(
                        padding: EdgeInsets.all(8.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text("Contact Details"),
                            Card(
                              elevation: 6.0,
                              child: TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please insert Permanent Address";
                                  }
                                },
                                onSaved: (e) => permanentaddress = e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.home, color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.all(18),
                                    labelText: "Permanent Address:"),
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                              ),
                            ),
                            Card(
                              elevation: 6.0,
                              child: TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please insert Correspondance Address";
                                  }
                                },
                                onSaved: (e) => correspondanceaddress = e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.home, color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.all(18),
                                    labelText: "Correspondance Address:"),
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,

                              ),
                            ),

                          ],

                        ),
                      ),

                      //official details
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Official email";
                            }
                          },
                          onSaved: (e) => officialmail = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.email, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Official Email"),
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Personal Email";
                            }
                          },
                          onSaved: (e) => personalemail = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.email, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Personal Email"),
                        ),
                      ),

                      new Text("Other Details"),
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Project Manager Email";
                            }
                          },
                          onSaved: (e) => projectmanageremail = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.email, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Project Manager Email"),
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Project Manager Id";
                            }
                          },
                          onSaved: (e) => projectmanagerid = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Project Manager Id"),
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert HR Email";
                            }
                          },
                          onSaved: (e) => hrmail = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.email, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "HR Email"),
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert HR ID";
                            }
                          },
                          onSaved: (e) => hrid = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "HR Id"),
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Account No";
                            }
                          },
                          onSaved: (e) => accountno = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.list, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Bank Account No"),
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert bank name ";
                            }
                          },
                          onSaved: (e) => bankname = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.account_balance, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Bank Name"),
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert IFSC code ";
                            }
                          },
                          onSaved: (e) => ifsccode = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.apps, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "IFSC Code"),
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert card holder name";
                            }
                          },
                          onSaved: (e) => cardname = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.credit_card, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Card holder Name"),
                        ),
                      ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //new Text("Security Questions",style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/20,color: Colors.black),),
                          new DropdownButton<String>(
                            value: securityquestions,
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
                                securityquestions=data;
                              });
                            },
                            items: SECURITYQUESTIONSSpinner.map<DropdownMenuItem<String>>((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert Answer";
                            }
                          },
                          onSaved: (e) => answer = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.message, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Answer"),
                          keyboardType: TextInputType.multiline,

                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(12.0),
                      ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Register",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: Color(0xFFf7d426),
                                onPressed: () {
                                  check();
                                }),
                          ),
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "GoTo Login",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: Color(0xFFf7d426),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                }),
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
        )
      ),
    );
  }

  @override
  userImage(File _image,String _filename) {
    // TODO: implement userImage
    setState(() {
      this._image = _image;
      this.filename =_filename;

    });
  }
}

class DrawerItem {

  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class MainMenu extends StatefulWidget {
  MainMenu({Key key, this.userId,this.depart})
      : super(key: key);
   String userId;
  final String depart;
  //MainMenu(this.signOut);

  final drawerItems = [
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("Reset Password", Icons.lock),
    new DrawerItem("Sign Out", Icons.exit_to_app)
  ];
  @override
  _MainMenuState createState() => _MainMenuState();
}

enum ConfirmAction { NO, YES }
class _MainMenuState extends State<MainMenu> {

  FirebaseDatabase db=FirebaseDatabase.instance;
  Query query;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int _selectedDrawerIndex = 0;
  _onSelectItem(int index) {
   // setState(() => _selectedDrawerIndex = index);
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Settings(),
          ),
        );
        break;
        case 1:

            return showDialog<ConfirmAction>(
              context: context,
              barrierDismissible: false, // user must tap button for close dialog!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Reset Password ?'),
                  content: const Text(
                      'Are you sure want to change password.'),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('NO'),
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.NO);
                      },
                    ),
                    FlatButton(
                      child: const Text('YES'),
                      onPressed: () async {
                        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

                        await _firebaseAuth.sendPasswordResetEmail(email: email);
                        pr.show();

                        Future.delayed(Duration(seconds: 3)).then((value){
                          pr.hide().whenComplete((){
                            return showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Reset Password'),
                                  content: const Text('Reset Link has been sent to the Registered Email'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        });

                      },
                    )
                  ],
                );
              },
            );

      case 2:
        signOut();
        break;

      default:
        return new Text("Error");
    }

   // Navigator.of(context).pop(); // close the drawer
  }
  ToastMessage(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }
  signOut() async  {
    try{
      await _firebaseAuth.signOut();
        setState(() {
          widget.userId="";

          pr.show();
          Future.delayed(Duration(seconds: 3)).then((value){
            pr.hide().whenComplete((){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login(),

                ),
              );
            });
          });
          ToastMessage("User Successfully LoggedOut");
        });

    } catch (e) {
      print(e);
    }
  }
  int currentIndex = 0;
  String selectedIndex = 'TAB: 0';
  String email = "", name = "", id = "",empid = "",imageUrl="",lastname="",middlename="";
  TabController tabController;
  ProgressDialog pr;

  final databaseReference = FirebaseDatabase.instance.reference();
  GoogleMapController mapController;
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubcription;
  Location location = new Location();
  String error;

  void UpdateDatabase(){
    databaseReference.child("Tracking").child(empid).set({
      'empid': empid,
      'latitude': currentLocation['latitude'],
      'longitude': currentLocation['longitude'],
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getPref();
    query = db.reference().child("Users").orderByChild("userId").equalTo(
        widget.userId);
    query.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          email = values["email"];
          name = values["name"];
          lastname = values["lastname"];
          middlename = values["middlename"];
          empid = values["empid"];
          imageUrl = values["imageURL"];
        });
        print("user" + email);
        print("name" + name);
        print("empid" + empid);
        print("imageURL" + imageUrl);
        print("middlename" + middlename);
        print("lastname" + lastname);
      });
    });
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
    locationSubcription = location.onLocationChanged().listen((Map<String, double> result){
      setState(() {
        currentLocation = result;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(currentLocation['latitude'], currentLocation['longitude']), zoom: 17),
          ),
        );
      });
      UpdateDatabase();
    });
  }
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void initPlatformState() async {
    Map<String, double> my_location;
    try{
      my_location = await location.getLocation();
      error = "";
    }on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Permission denied - please ask the user to enable it from the app settings';
      my_location = null;
    }
    setState(() {
      currentLocation = my_location;
    });
  }



  @override
  Widget build(BuildContext context) {
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
    if((empid!=null) && (email!=null) && (name!=null) && (imageUrl!=null)){
      var drawerOptions = <Widget>[];
      for (var i = 0; i < widget.drawerItems.length; i++) {
        var d = widget.drawerItems[i];
        drawerOptions.add(
            new ListTile(
              leading: new Icon(d.icon),
              title: new Text(d.title),
              selected: i == _selectedDrawerIndex,
              onTap: () => _onSelectItem(i),
            )
        );
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/logo.png',height: 30.0,width: 30.0,fit: BoxFit.contain,),
              Container(padding: const EdgeInsets.all(8.0),child: Text('Alta Attendance'),)
            ],
          ),
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: middlename==null?new Text(name+" "+lastname):new Text(name+" "+middlename+" "+lastname),
                accountEmail: new Text(email),
                currentAccountPicture: new CircleAvatar(backgroundImage: NetworkImage(imageUrl),),),
              new Text(empid),
              new Column(children: drawerOptions)
            ],
          ),
        ),

        body:
        new Container(
          child: new Column(
            children: <Widget>[
              new Text("Welcome to Employee dashboard",style: TextStyle(fontWeight: FontWeight.normal,fontSize: _width/15, color: Colors.black,),textAlign: TextAlign.center,),
              SizedBox(
                height: 8.0,
              ),
              new Text(empid,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.lightBlue,),textAlign: TextAlign.center,),
              middlename==null?new Text(name+" "+lastname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.lightBlueAccent,),textAlign: TextAlign.center,):new Text(name+" "+middlename+" "+lastname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: _width/20, color: Colors.lightBlueAccent,),textAlign: TextAlign.center,),

              Visibility(
                child: Text('Lat/Lng: ${currentLocation['latitude']}/${currentLocation['longitude']}'),
                maintainSize: false,
                maintainAnimation: true,
                maintainState: true,
                visible: false, ),

              Visibility(
                child: SizedBox(
                  width: double.infinity,
                  height: 350.0,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: LatLng(currentLocation['latitude'], currentLocation['longitude']),
                        zoom: 17),
                    onMapCreated: _onMapCreated,
                  ),
                ),
                maintainSize: false,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
              ),

              new Expanded(
                child:Container(
                  padding: EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 16),
                  child:  new GridView.count(crossAxisCount: 2,
                    childAspectRatio: .90,
                    //padding: const EdgeInsets.all(4.0),

                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: <Widget>[
                      new FlatButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyProfile(
                            userId: widget.userId,
                          )
                          ),
                        );

                        },
                        color: Colors.white,

                        //padding: EdgeInsets.all(7.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(child:Image.asset('assets/images/profile.jpg'),),
                            new Text("My Profile"),
                          ],
                        ),
                      ),
                      new FlatButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmployeeAttendanceLogin(userId: widget.userId,),
                          ),
                        );
                        },
                        color: Colors.white,
                         //padding: EdgeInsets.all(7.0),
                           child: Column(
                          children: <Widget>[
                            Expanded(child:Image.asset('assets/images/attendance.png'),),
                            new Text("Attendance"),
                          ],
                        ),
                      ),
                    ],
                  ),
                )

              ),

            ],
          ),
        ),




        /*bottomNavigationBar: BottomNavyBar(
          backgroundColor: Colors.black,
          iconSize: 30.0,
//        iconSize: MediaQuery.of(context).size.height * .60,
          currentIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
            });
            selectedIndex = 'TAB: $currentIndex';
//            print(selectedIndex);
            reds(selectedIndex);
          },

          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeColor: Color(0xFFf7d426)),
            BottomNavyBarItem(
                icon: Icon(Icons.view_list),
                title: Text('List'),
                activeColor: Color(0xFFf7d426)),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeColor: Color(0xFFf7d426)),
          ],
        ),*/
      );

    }
    else{

      return Scaffold(
        appBar: AppBar(
          title: Text('AltaOSS'),
        ),
        body: new Center(
          child:const CircularProgressIndicator(),
        ),
      );    }

  }

  //  Action on Bottom Bar Press
  void reds(selectedIndex) {
//    print(selectedIndex);

    switch (selectedIndex) {
      case "TAB: 0":
        {
          callToast("Tab 0");
        }
        break;

      case "TAB: 1":
        {
          callToast("Tab 1");
        }
        break;

      case "TAB: 2":
        {
          callToast("Tab 2");
        }
        break;
    }
  }

  callToast(String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}


class Settings extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SettingsState();

}

class _SettingsState extends State<Settings> {

   SharedPreferences sharedPreferences;
   bool checkValue=false;

   _onChanged(bool value)async{

     sharedPreferences=await SharedPreferences.getInstance();
     setState(() {
       checkValue=value;
       Fluttertoast.showToast(
           msg: checkValue.toString(),
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           timeInSecForIos: 1,
           backgroundColor: Colors.red,
           textColor: Colors.white,
           fontSize: 16.0);
       sharedPreferences.setBool("fingerprintcheck", checkValue);
       sharedPreferences.commit();

     });
   }


   @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: new Text("Settings"),

      ),
      body: PreferencePage([
        PreferenceTitle('Finger Print'),
        SwitchListTile(value: false,
            title: Text("Finger Print Auth"),
            onChanged: _onChanged,
        )

      ]),
    );
  }


}





