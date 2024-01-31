import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:user_bicycle_rental/authentication/signup_screen.dart';
import 'package:user_bicycle_rental/global/global_var.dart';
import 'package:user_bicycle_rental/methods/common_methods.dart';
import 'package:user_bicycle_rental/pages/home.dart';

import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable(){
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation(){
    if(!emailTextEditingController.text.contains("@")){
      cMethods.displaySnackBar("enter a valid e-mail ", context);
    }
    else if(passwordTextEditingController.text.trim().length < 7){
      cMethods.displaySnackBar("password must be at least 8 or more characters", context);
    }
    else{
      signInUser();
    }
  }

  signInUser() async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Allowing you to Login..."),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg){
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if(!context.mounted)return;
    Navigator.pop(context);

    if(userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
      usersRef.once().then((snap) {
        if(snap.snapshot.value != null) {
          if((snap.snapshot.value as Map)["blockStatus"] == "no"){
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(context, MaterialPageRoute(builder: (c) => bikeRentalPage(uid: userFirebase.uid)));
          }
          else{
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("you are blocked! Contact Admin.", context);
          }
        }
        else{
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar("your records do not exist as a User.", context);
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 10),
          child: Column(
            children: [
              Image.asset(
                  "assets/images/logo1.png",
                  width: 400,
                  height: 300,
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              const Text(
                "Login as a User",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //textfields and Button
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "User Email Address",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 22,),

                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Password",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 32,),

                    ElevatedButton(
                      onPressed: (){
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      ),
                      child: const Text(
                          "Login"
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 12,),

              //textbutton
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> SignUpScreen()));
                },
                child: const Text(
                  "Don\'t have an Account? Register here",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
