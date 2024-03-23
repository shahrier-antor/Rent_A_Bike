import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfAdmin();
  }

  void _checkIfAdmin() async {
    // TODO: Check if the current user has admin privileges
    // ...(Retrieve admin status from user data if applicable)
  }

  // Add a bike
  void _addBike() async {
    if (_formKey.currentState!.validate()) {
      // 1. Get new bike data from form fields
      String imageUrl = _imageUrlController.text;
      String model = _modelController.text;
      int price = int.parse(_priceController.text);
      String details = _detailsController.text;

      // 2. Generate a unique key for the new bike
      String bikeId = FirebaseDatabase.instance.ref('bikes').push().key!;

      // 3. Upload the image (consider using Firebase Storage)
      // ...

      // 4. Create a Map with the bike data
      Map<String, dynamic> bikeData = {
        'imageURL': imageUrl,
        'model': model,
        'price': price,
        'details': details,
        'available': true
      };

      // 5. Add new bike document to the 'bikes' collection
      await FirebaseDatabase.instance.ref('bikes').child(bikeId).set(bikeData);

      // Reset the form fields after submission
      _resetFormFields();
    }
  }

  // Delete a bike
  void _deleteBike(String bikeId) async {
    // 1. Show a confirmation dialog
    bool? confirmed = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this bike?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('No')),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('Yes')),
        ],
      ),
    );

    // 2. If confirmed, delete the bike document
    if (confirmed ?? false) {
      await FirebaseDatabase.instance.ref('bikes').child(bikeId).remove();
    }
  }

  void _resetFormFields() {
    _imageUrlController.clear();
    _modelController.clear();
    _priceController.clear();
    _detailsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // TODO: Navigate back to the login screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBikeForm(),
            SizedBox(height: 20),
            _buildBikeList(),
          ],
        ),
      ),
    );
  }

  // Form to add a new bike
  Widget _buildBikeForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey, // Link the form key
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add New Bike", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextFormField(controller: _imageUrlController, decoration: InputDecoration(labelText: 'Image URL')),
            // ...(Other form fields)
            ElevatedButton(
              onPressed: () => _addBike(),
              child: Text('Add Bike'),
            ),
          ],
        ),
      ),
    );
  } // ..._buildBikeForm(), _buildBikeList()
}
