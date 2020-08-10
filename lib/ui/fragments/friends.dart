import 'dart:convert';

import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/model/friend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';

class FriendsFragment extends StatefulWidget{
  @override
  _FriendsFragment createState() => _FriendsFragment();

}

class _FriendsFragment extends State<FriendsFragment>{
  final ContactPicker _contactPicker = new ContactPicker();
  List<Friend> _contactList = List();
  DatabaseReference _contactRef;

  Future<FirebaseUser> loadUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    final FirebaseDatabase database = FirebaseDatabase();
    _contactRef = database.reference().child('contacts').child(user.uid);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          builder: (context, snapshot){
            return snapshot.hasData ? StreamBuilder(
              stream: _contactRef.onValue,
              builder: (context, event){
                if(event.hasData && event.data.snapshot.value != null){
                  Map map = event.data.snapshot.value;
                  if(map != null){
                    map.forEach((key, value) {
                      var contact = Friend.fromSnapshot(value);
                      var res = _contactList.firstWhere((element) => element.phoneNumber == contact.phoneNumber, orElse: () => null);
                      if(res == null) _contactList.add(contact);
                    });
                  }
                  return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: colorGrey,
                      ),
                    itemBuilder: (context, position){
                      return Text(_contactList[position].fullName, style: style,);
                    },
                    itemCount: _contactList.length,
                    padding: mediumSpacing,
                    scrollDirection: Axis.vertical
                  );
                }
                else{
                  return Center(
                    child: Text("You currently have no contact. Start adding to your friend list by clicking the button at add button", style: style, textAlign: TextAlign.center,),
                  );
                }
              },
            ) : Container();
          },
          future: loadUser(),
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
      var data = { "fullName" : contact.fullName, "phoneNumber" : contact.phoneNumber.number };
      _contactRef.push().set(data).then((value) => toastSuccess("Contact added!"));
    }
  }

}