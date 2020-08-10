import 'package:bill_splitter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';

class FriendsFragment extends StatefulWidget{
  @override
  _FriendsFragment createState() => _FriendsFragment();

}

class _FriendsFragment extends State<FriendsFragment>{
  final ContactPicker _contactPicker = new ContactPicker();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: colorPrimary,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addNewFriend(),
        label: Text('Add New'),
        icon: Icon(Icons.plus_one),
        backgroundColor: colorPrimary,
      ),
    );
  }

  addNewFriend() async {
    Contact contact = await _contactPicker.selectContact();
    if(contact != null){

    }
  }

}