import 'package:flutter/material.dart';
import 'package:flutter_altaoss/login_register.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
          debugShowCheckedModeBanner: false,
        //home:RootPage(auth: new Auth()));
        home:Login());
  }
}


/*
void main()=> runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  home: RootPage(auth: new Auth()),
));*/
