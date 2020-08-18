import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/model/friend.dart';
import 'package:bill_splitter/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

class HomeFragment extends StatefulWidget{
  @override
  _HomeFragment createState() => _HomeFragment();

}

class _HomeFragment extends State<HomeFragment>{
  String _amount;

  String _item;

  DatabaseReference _contactRef;
  List<Friend> _contactList = List();

  Future<FirebaseUser> loadUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    final FirebaseDatabase database = FirebaseDatabase();
    _contactRef = database.reference().child('contacts').child(user.uid);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return FutureBuilder(
     future: loadUser(),
     builder: (context, snaps2ot){
       if(snaps2ot.hasData && snaps2ot.data != null){
         return Scaffold(
           body: SafeArea(
             child: Container(
               padding: mediumSpacing,
               color: colorLightGrey,
               height: MediaQuery.of(context).size.height,
               child: SingleChildScrollView(
                 child:  Stack(
                   children: <Widget>[
                     Container(
                       padding: EdgeInsets.only(
                         top: Const.avatarRadius + Const.padding,
                         bottom: Const.padding,
                         left: Const.padding,
                         right: Const.padding,
                       ),
                       margin: EdgeInsets.only(top: Const.avatarRadius, left: 10, right: 10),
                       decoration: new BoxDecoration(
                         color: Colors.white,
                         shape: BoxShape.rectangle,
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black26,
                             blurRadius: 10.0,
                             offset: const Offset(0.0, 10.0),
                           ),
                         ],
                       ),
                       child:Column(
                         mainAxisSize: MainAxisSize.min,
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Text("Total Amount to split", style: style.copyWith(color: colorGrey),),
                           smallSize,
                           TextField(
                             decoration: InputDecoration( hintText: 'Enter amount'),
                             onChanged: (value) => _amount = value.trim(),
                             keyboardType: TextInputType.number,
                           ),
                           fabSize,
                           Text("What are you paying for?", style: style.copyWith(color: colorGrey),),
                           smallSize,
                           TextField(
                             decoration: InputDecoration( hintText: 'Enter item name'),
                             onChanged: (value) => _item = value.trim(),
                             keyboardType: TextInputType.text,
                           ),
                           fabSize,
                           smallSize,
                           StreamBuilder(
                             stream: _contactRef.onValue,
                             builder: (context, event){
                               if(event.hasData && event.data.snapshot.value != null) {
                                 Map map = event.data.snapshot.value;
                                 if (map != null) {
                                   map.forEach((key, value) {
                                     var contact = Friend.fromSnapshot(value);
                                     var res = _contactList.firstWhere((element) => element.phoneNumber == contact.phoneNumber, orElse: () => null);
                                     if ( res == null ) _contactList.add(contact);
                                   });
                                 }
                               }
                               return MultiSelect(
                                   autovalidate: false,
                                   titleText: "Select who is sharing the bill with you",
                                   validator: (value) => value.isEmpty ? 'Please select one or more option(s)' : null,
                                   errorText: 'Please select one or more option(s)',
                                   dataSource: _contactList.map((e) => { "display" : e.fullName, "value" : e.phoneNumber }).toList(),
                                   textField: 'display',
                                   valueField: 'value',
                                   filterable: true,
                                   required: true,
                                   value: null,
                                   onSaved: (value) {
                                     print('The value is $value');
                                   }
                               );
                             },
                           ),
                           fabSize,
                           Material(
                             elevation: 5.0,
                             borderRadius: BorderRadius.circular(10.0),
                             color: colorPrimary,
                             child: MaterialButton(
                               minWidth: MediaQuery.of(context).size.width,
                               onPressed: () => attemptSave(),
                               child: Text("Submit Payment Split",
                                 textAlign: TextAlign.center,
                                 style: style.copyWith( color: Colors.white, fontSize: 14 ),
                               ),
                             ),

                           )
                         ],
                       ),
                     ),
                     Positioned(
                       left: Const.padding,
                       right: Const.padding,
                       child: CircleAvatar(
                         backgroundColor: colorPrimary,
                         radius: Const.avatarRadius,
                         child: Image.asset("assets/bill_1.png", fit: BoxFit.scaleDown, width: 150,),
                       ),
                     ),
                   ],
                 ),
               ),

             ),
           ),
         );
       }
       else
         return Center(
           child: CircularProgressIndicator(),
         );
     },
   );
  }

  attemptSave() {

  }

}