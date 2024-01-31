import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods{
  checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.wifi && connectionResult != ConnectivityResult.mobile) {
      if(!context.mounted)return;
      displaySnackBar("Your Internet is not available! Check your connection and Try again.", context);
    }
  }

  displaySnackBar(String messageText, BuildContext context){
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}