
import 'package:intl/intl.dart';

class Repository{
  static Repository _instance = Repository._internal();
  Repository._internal();
  static Repository getInstance(){
    return _instance;
  }


  formatPhoneNumber(String phoneNumber) {
    String removePlus234 = phoneNumber.replaceFirst("+234","");
    String remove234 = removePlus234.substring(0,3) == ("234") ? removePlus234.substring(3) : removePlus234;
    String addZero = remove234.substring(0,1) == ("0") ? remove234 : "0" + remove234;
    return addZero;
  }

  formatPhoneNumberWithCountryCode(String customerId) {
    return "+234" + formatPhoneNumber(customerId).substring(1);
  }

  String getNairaUnitFormat(double amount) {
    final oCcy = new NumberFormat("#,##0.00", "en_US");
    final formated = oCcy.format(amount);
    return formated.toString();
  }
}