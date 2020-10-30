import 'package:firebase_crud_ap/src/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crud_ap/src/bloc/provider.dart';
import 'package:firebase_crud_ap/src/pages/home_page.dart';
import 'package:firebase_crud_ap/src/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
