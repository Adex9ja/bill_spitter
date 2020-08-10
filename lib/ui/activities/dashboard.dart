import 'package:bill_splitter/ui/fragments/friends.dart';
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
    return StreamBuilder(
      stream: ConnectionStatusSingleton.getInstance().connectionChange,
      initialData: ConnectionStatusSingleton.getInstance().hasConnection,
      builder: (context, snapshot){
        return Scaffold(
          appBar: AppBar(
            title: Text("Bill Splitter", style: style,),
            actions: <Widget>[
              FlatButton(
                child: Text("Sign Out", style: style,),
                onPressed: () => signOut(),
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              color: colorLightGrey,
              child: Column(
                children: <Widget>[
                  snapshot.hasData && snapshot.data ? Container() : noInternetWidget,
                  Expanded(
                    child: container,
                  )
                ],
              ),
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
                title: Text(destination.title, style: style,),
              );
            }).toList(),
            selectedItemColor: colorPrimary,
          ),
        );
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut().then((value) => Navigator.popAndPushNamed(context, '/login'));
  }

}

List<Destination> allDestinations = <Destination>[
  Destination('Home', Icons.home,  HomeFragment()),
  Destination('History', Icons.show_chart, HomeFragment()),
  Destination('Friends', Icons.person, FriendsFragment() )
];

class Destination {
  const Destination(this.title, this.icon, this.widget);
  final String title;
  final IconData icon;
  final Widget widget;
}