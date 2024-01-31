import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_bicycle_rental/authentication/login_screen.dart';
import 'package:user_bicycle_rental/authentication/signup_screen.dart';
import 'package:user_bicycle_rental/pages/home.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'AIzaSyBfXnteg0IAtVObp5bNAgEuO7evv0ntDGc',
    appId: '1:1077450271684:ios:2511386822d62b8d799291',
    messagingSenderId: '1077450271684',
    projectId: 'bicyclerental-aa44e',
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: LoginScreen(),
    );
  }
}