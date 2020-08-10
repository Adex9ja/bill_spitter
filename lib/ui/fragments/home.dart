import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeFragment extends StatefulWidget{
  @override
  _HomeFragment createState() => _HomeFragment();

}

class _HomeFragment extends State<HomeFragment>{
  String _amount;

  String _item;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                     Text("Who is sharing?", style: style.copyWith(color: colorGrey),),
                     smallSize,
                     TextField(
                       decoration: InputDecoration( hintText: 'Select who is sharing'),
                       onChanged: (value) => _amount = value.trim(),
                       keyboardType: TextInputType.number,
                       readOnly: true,
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

  attemptSave() {}

}