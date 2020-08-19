class Friend{
  String fullName;
  String phoneNumber;

  Friend(this.fullName, this.phoneNumber);

  double amount;

  Friend.fromSnapshot(Map<dynamic, dynamic> value) {
    fullName = value['fullName'];
    phoneNumber = value['phoneNumber'];
    amount = double.tryParse(value['amount'].toString());

  }

}