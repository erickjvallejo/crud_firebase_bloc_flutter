import 'package:flutter/material.dart';
import 'package:crud_firebase_bloc/src/pages/product_page.dart';
import 'package:crud_firebase_bloc/src/pages/register_page.dart';
import 'package:crud_firebase_bloc/src/pages/home_page.dart';
import 'package:crud_firebase_bloc/src/pages/login_page.dart';
import 'package:crud_firebase_bloc/src/bloc/provider.dart';
import 'package:crud_firebase_bloc/src/preferences/user_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    print(prefs.token);

    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'register': (BuildContext context) => RegisterPage(),
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
