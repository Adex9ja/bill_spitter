import 'dart:async';
import 'dart:convert';

import 'package:bill_splitter/model/friend.dart';
import 'package:bill_splitter/utils/repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class BillSplittingActivity extends StatefulWidget{
  @override
  _BillSplittingActivity createState() => _BillSplittingActivity();
}

class _BillSplittingActivity extends State<BillSplittingActivity>{
  var data;
  bool _evenlySplit = true;
  var _formKey = GlobalKey<FormState>();
  DatabaseReference _contactRef;
  FirebaseDatabase database = FirebaseDatabase();
  @override
  Widget build(BuildContext context) {
    if(data == null){
      data = ModalRoute.of(context).settings.arguments;
      _contactRef = database.reference().child("bill_splitter").child('splits').child(data['user_id']);
      splitPaymentEqually();
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                  height: 140,
                  color: colorPrimary,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: FlatButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back_ios, color: colorWhite,),
                          label: Text(""),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Center(
                        child: Text("NGN ${ Repository.getInstance().getNairaUnitFormat(data['amount'])}", style:  style.copyWith( fontSize: 28, color: colorWhite),),
                      ),
                    ],
                  )
              ),
              Container(
                color: colorLightGrey,
                child: Row(
                  children: <Widget>[
                    VerticalDivider(),
                    Text("Split Bills Equally ?", style: style,),
                    Expanded( child: Container(),),
                    Switch(value: _evenlySplit, onChanged: (value) {
                      setState(() {
                        _evenlySplit = value;
                        if(_evenlySplit) splitPaymentEqually();
                      });
                    })
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: colorGrey,
                  ),
                  itemBuilder: (context, position){
                    return Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.radio_button_checked, color: colorPrimary,),
                                VerticalDivider(),
                                Text(data['splitters'][position].fullName, style: style.copyWith(color:  position == 0 ? colorBlue : colorBlack),),
                              ],
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child:  TextFormField(
                              onChanged: (value) {
                                var newValue = double.tryParse(value.trim()) ?? 0;
                                data['splitters'][position].amount = newValue;
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) => value.isEmpty ? "Empty field" : null,
                              controller: TextEditingController(text: data['splitters'][position].amount.toStringAsFixed(2) ),
                              readOnly: _evenlySplit,
                              textAlign: TextAlign.center,
                              style: style.copyWith( color: _evenlySplit ? colorGrey : colorBlack),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: data['splitters'].length,
                  padding: mediumSpacing,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                ),
              ),
              Container(
                padding: mediumSpacing,
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: colorPrimary,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () => attemptSave(),
                    child: Text("Save splitted bills",
                      textAlign: TextAlign.center,
                      style: style.copyWith( color: Colors.white, fontSize: 14 ),
                    ),
                  ),

                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void splitPaymentEqually() {
    var size = data['splitters'].length;
    double amount = data['amount'] / size;
    data['splitters'].forEach((element) { element.amount = amount; });
  }

  attemptSave() {
    var currentState = _formKey.currentState;
    if(currentState.validate()){
      currentState.save();

      var splitters = data['splitters'].map((value) => { "fullName" : value.fullName, "phoneNumber" : value.phoneNumber, "amount" : value.amount }).toList();
      data['splitters'] = splitters;
      data['date'] = DateTime.now().toString();
      startLoading(context).then((value) =>  _contactRef.push().set(data).then((value) => splittedSaved()).catchError(onError));
    }
  }


  FutureOr splittedSaved() {
    loadingSuccessful("Successfully Saved!");
    Navigator.pop(context, ['data']);
  }

  onError(Object obj) {
    loadingFailed("Error occurs!");
  }
}