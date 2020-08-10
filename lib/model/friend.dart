class Friend{
  String fullName;
  String phoneNumber;

  Friend.fromSnapshot(Map<dynamic, dynamic> value) {
    fullName = value['fullName'];
    phoneNumber = value['phoneNumber'];

  }
}