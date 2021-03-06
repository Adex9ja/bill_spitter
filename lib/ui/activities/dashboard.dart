import 'package:bill_splitter/ui/fragments/friends.dart';
import 'package:bill_splitter/ui/fragments/history.dart';
import 'package:bill_splitter/ui/fragments/home.dart';
import 'package:bill_splitter/utils/connection_singleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class DashBoardActivity extends StatefulWidget{
  @override
  _DashBoardActivity createState() => _DashBoardActivity();

}

class _DashBoardActivity extends State<DashBoardActivity>{
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final container = IndexedStack(
      index: _currentIndex,
      children: allDestinations.map<Widget>((Destination destination){
        return destination.widget;
      }).toList(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill Splitter", style: style,),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.power_settings_new, color: colorWhite,),
            label: Text("Sign Out", style: style.copyWith(color: colorWhite),),
            onPressed: () => signOut(),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: colorLightGrey,
          child: container
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map<BottomNavigationBarItem>((Destination destination){
          return BottomNavigationBarItem(
            icon: Icon(destination.icon,),
            title: Text(destination.title),
          );
        }).toList(),
        selectedItemColor: colorPrimary,
      ),
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut().then((value) => Navigator.popAndPushNamed(context, '/login'));
  }

}

List<Destination> allDestinations = <Destination>[
  Destination('Home', Icons.home,  HomeFragment()),
  Destination('History', Icons.history, HistoryFragment()),
  Destination('Friends', Icons.group, FriendsFragment() )
];

class Destination {
  const Destination(this.title, this.icon, this.widget);
  final String title;
  final IconData icon;
  final Widget widget;
}