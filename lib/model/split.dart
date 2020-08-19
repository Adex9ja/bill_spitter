import 'package:bill_splitter/model/friend.dart';

class Split{
  double amount;
  String item;
  List<Friend> splitters;
  String date;

  Split.fromSnapshot(dynamic value) {
    amount = double.tryParse(value['amount'].toString());
    item = value['item'];
    date = value['date'];
    splitters = value['splitters'].map<Friend>((value) => Friend.fromSnapshot(value)).toList();
  }
}