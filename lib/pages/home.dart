import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:user_bicycle_rental/pages/user_profile.dart';
//import 'package:url_launcher/url_launcher.dart'; // For navigation to user profile

const bikeList = [
  {
    'imageURL': 'https://www.bicyclebd.com/images/products/trek-6300-2012.jpg',
    'model': 'Trek 6300',
    'price': 100,
    'details': '',
  },
  {
    'imageURL': 'https://www.bicyclebd.com/images/products/core-project-29er.jpg',
    'model': 'Core Project 29er',
    'price': 40,
    'details': '',
  },
  {
    'imageURL': 'https://www.bicyclebd.com/images/products/saracen-cross-2.jpg',
    'model': 'Saracen Cross 2',
    'price': 50,
    'details': '',
  },
  {
    'imageURL': 'https://www.bicyclebd.com/images/products/saracen-hack-2.jpg',
    'model': 'Saracen Hack 2',
    'price': 80,
    'details': '',
  },
  {
    'imageURL': 'https://www.bicyclebd.com/images/products/upland-fusion-fully.jpg',
    'model': 'Upland Fusion Fully',
    'price': 70,
    'details': '',
  },
];

class bikeRentalPage extends StatelessWidget {
  final String uid;
  bikeRentalPage({required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent A Bike'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (c) => userProfilePage(uid: uid)));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: bikeList.length,
        itemBuilder: (context, index) {
          final bikeData = bikeList[index];
          final imageURL = bikeData['imageURL'] as String?;
          final model = bikeData['model'] as String?;
          final price = bikeData['price'] as int?;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  imageURL != null
                      ? Container(
                          width: 400,
                          height: 300,
                          child: Image.network(
                            imageURL,
                            fit: BoxFit.cover,
                          ),
                       ) : SizedBox.shrink(),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(model ?? 'Model not available',
                          style: Theme.of(context).textTheme.headline6),
                      Text(price != null ? '৳$price per hour' : 'Price not available'),
                    ],
                  ),
                  const SizedBox(height: 5.0),

                  // Add button to rent car if needed
                  ElevatedButton(
                    onPressed: () {
                      // Add your logic for booking the bike
                      showBookingDialog(context, uid, model, imageURL, price);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Adjust the value for circular border
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust the value for constant padding
                      primary: Colors.grey, // Background color
                    ),
                    child: const Text(
                      'Book Now',
                        style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                  ),
                ],
              ),
            ),
          );;
        },
      ),
    );
  }

  void showBookingDialog(BuildContext context, String uid, String? bikeModel, String? bikeImageURL, int? bikePrice) {
    DateTime? startTime;
    DateTime? endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState){
            return Center(
              child: AlertDialog(
                title: buildTitleWidget(bikeModel, bikeImageURL),
                contentPadding: const EdgeInsets.all(25),
                titlePadding: const EdgeInsets.only(top: 28, left: 18, right: 16, bottom: 10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //start time field
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if(selectedDate != null) {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if(selectedTime != null) {
                            setState(() {
                              startTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedDate.hour,
                                selectedDate.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text(startTime != null ? 'Start: ${startTime!.toLocal()}' : 'Select Start Time'),
                    ),
                    const SizedBox(width: 10,),
                    //end time field
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (selectedTime != null) {
                            setState(() {
                              endTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text(endTime != null ? 'End: ${endTime!.toLocal()}' : 'Select End Time'),
                    ),
                    const SizedBox(height: 10.0),

                    Text('Duration: ${calculateDuration(startTime, endTime)}'),
                    const SizedBox(height: 10.0),

                    Text('Amount to Pay: ${calculateAmount(startTime, endTime, bikePrice)}'),
                    const SizedBox(height: 10.0),

                    ElevatedButton(
                      onPressed: () {
                        // Add logic to handle checkout
                        //showPaymentDialog(context);
                        showPaymentDialog(context, uid, bikeModel, startTime, endTime, calculateDuration(startTime, endTime), calculateAmount(startTime, endTime, bikePrice));
                        //Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Checkout'),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTitleWidget(String? bikeModel, String? bikeImageURL) {
    return Row(
      children: [
        // Tiny image of the bike
        bikeImageURL != null
            ? Container(
          width: 30,
          height: 30,
          child: Image.network(
            bikeImageURL,
            fit: BoxFit.cover,
          ),
        )
            : SizedBox.shrink(),
        const SizedBox(width: 8.0),
        // Model of the bike
        Text('Book $bikeModel', style: const TextStyle(fontSize: 20,),),
      ],
    );
  }

  String calculateDuration(DateTime? startTime, DateTime? endTime) {
    if (startTime != null && endTime != null) {
      final duration = endTime.difference(startTime);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '$hours hours $minutes minutes';
    }
    return 'N/A';
  }

  String calculateAmount(DateTime? startTime, DateTime? endTime, int? hourlyRate) {
    if (startTime != null && endTime != null && hourlyRate != null) {
      final duration = endTime.difference(startTime).inHours + ((endTime.difference(startTime).inMinutes % 60)/60);
      final amount = (duration * hourlyRate).round();
      return '৳$amount';
    }
    return 'N/A';
  }

  void showPaymentDialog(BuildContext context, String uid, String? bikeModel, DateTime? startTime, DateTime? endTime, String duration, String amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please provide your Nagad information:'),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nagad Number'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Add logic to handle the payment and close the dialogs
                  storeBookingData(uid, bikeModel, startTime, endTime, duration, amount);
                  Navigator.of(context).pop(); // Close the payment dialog
                  Navigator.of(context).pop(); // Close the booking dialog
                },
                child: const Text('Submit Payment'),
              ),
            ],
          ),
        );
      },
    );
  }

  void storeBookingData(String uid, String? bikeModel, DateTime? startTime, DateTime? endTime, String duration, String amount) {
    DatabaseReference bookingRef = FirebaseDatabase.instance.reference().child("users").child(uid).child("bookings");

    // Create a unique key for the booking
    String bookingKey = bookingRef.push().key ?? "";

    Map bookingData = {
      "model": bikeModel,
      "startTime": startTime?.toIso8601String(),
      "endTime": endTime?.toIso8601String(),
      "duration": duration,
      "amount": amount,
    };

    // Store booking data under the unique key
    bookingRef.child(bookingKey).set(bookingData);
  }

}
