import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/model/friend.dart';
import 'package:bill_splitter/model/split.dart';
import 'package:bill_splitter/utils/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryFragment extends StatefulWidget{
  @override
  _HistoryFragment createState() => _HistoryFragment();
}

class _HistoryFragment extends State<HistoryFragment>{
  DatabaseReference _contactRef;
  List<Split> _splitList = List();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadUser(),
      builder: (context, event){
        if(event.hasData && event.data != null){
          return Scaffold(
            body: SafeArea(
                child: StreamBuilder(
                  stream: _contactRef?.onValue,
                  builder: (context, event){
                    if(event.hasData && event.data.snapshot.value != null){
                      Map map = event.data.snapshot.value;
                      _splitList = map.values.map((e) => Split.fromSnapshot(e)).toList();
                      return ListView.builder(
                          itemBuilder: (context, position) =>  Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            elevation: 2,
                            margin: mediumSpacing,
                            child: ExpansionTile(
                                backgroundColor: Colors.white,
                                title: _buildTitle(_splitList[position]),
                                trailing: SizedBox(),
                                children: _splitList[position].splitters.map<Widget>((e) {
                                  return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.check_circle, color: colorPrimary,),
                                              VerticalDivider(),
                                              Text(e.fullName, style: style.copyWith(color: colorGrey, fontSize: 13),),
                                            ],
                                          ),
                                          flex: 3,
                                        ),
                                        Text("NGN ${ Repository.getInstance().getNairaUnitFormat(e.amount)} ", style: style.copyWith(fontSize: 13, color: colorGrey),),
                                      ],
                                    ),
                                  );
                                }).toList() ),),
                          itemCount: _splitList.length
                      );
                    }
                    else{
                      return Center(
                        child: Text("Your history list is currently empty", style: style, textAlign: TextAlign.center,),
                      );
                    }
                  },
                )

            ),
          );
        }
        else
          return Center( child:  CircularProgressIndicator(),);
      }
    );
  }
  Widget _buildTitle(Split splitList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(splitList.item, style: style,),
        Row(
          children: <Widget>[
            Text(splitList.date, style: style.copyWith(fontSize: 14),),
            Expanded( child: Container(),),
            FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {},
              icon: Icon(Icons.supervised_user_circle),
              label: Text("NGN ${ Repository.getInstance().getNairaUnitFormat(splitList.amount) }", style: style.copyWith(fontSize: 14),),
            ),
          ],
        ),
      ],
    );
  }
  Future<FirebaseUser> loadUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    final FirebaseDatabase database = FirebaseDatabase();
    _contactRef = database.reference().child("bill_splitter").child('splits').child(user.uid);
    return user;
  }
}