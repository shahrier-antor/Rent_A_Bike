import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class userProfilePage extends StatelessWidget {
  final String uid;
  userProfilePage({required this.uid});

  Widget ListItem({required Map bookings}){
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookings['model'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            bookings['startTime'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            bookings['endTime'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            bookings['duration'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            bookings['amount'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Query userReference = FirebaseDatabase.instance.reference().child("users").child(uid).child("bookings");
    Query userName = FirebaseDatabase.instance.reference().child("users").child(uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Profile",
        ),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: userReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
            Map bookings = snapshot.value as Map;
            bookings['key'] = snapshot.key;

            return ListItem(bookings: bookings);
          },
        ),
      ),
    );
  }
}

//u1804045@student.cuet.ac.bd



