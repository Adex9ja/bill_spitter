import 'package:bill_splitter/utils/connection_singleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class DashBoardActivity extends StatefulWidget{
  @override
  _DashBoardActivity createState() => _DashBoardActivity();

}

class _DashBoardActivity extends State<DashBoardActivity>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ConnectionStatusSingleton.getInstance().connectionChange,
      initialData: ConnectionStatusSingleton.getInstance().hasConnection,
      builder: (context, snapshot){
        return Scaffold(
          body: SafeArea(
            child: Container(
              color: colorLightGrey,
              child: Column(
                children: <Widget>[
                  snapshot.hasData && snapshot.data ? Container() : noInternetWidget,
                  Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: fabSpacing,
                          child: Container(),
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: Text("Welcome", style: style,),
            actions: <Widget>[
              FlatButton(
                child: Text("Sign Out", style: style,),
                onPressed: () => signOut(),
              )
            ],
          ),
        );
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut().then((value) => Navigator.popAndPushNamed(context, '/login'));
  }

}