import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/utils/connection_singleton.dart';
import 'package:bill_splitter/utils/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginActivity extends StatefulWidget{
  @override
  _LoginActivity createState() => _LoginActivity();
}

class _LoginActivity extends State<LoginActivity>{
  String _phoneNumber = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _formattedPhoneNumber;
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset("assets/bill_3.png"),
                              Text("Enter your phone number", style: style,),
                              smallSize,
                              Text("Please enter your correct phone number. An OTP code will be sent to your number for verification", style: style.copyWith(fontSize: 11, color: colorGrey),),
                              mediumSize,
                              TextField(
                                decoration: InputDecoration( hintText: 'e.g 081********'),
                                onChanged: (value) => _phoneNumber = value.trim(),
                                keyboardType: TextInputType.phone,
                              ),
                              fabSize,
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(10.0),
                                color: colorPrimary,
                                child: MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  onPressed: () => attemptLogin(),
                                  child: Text("Verify Phone Number",
                                    textAlign: TextAlign.center,
                                    style: style.copyWith( color: Colors.white, fontSize: 14 ),
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  attemptLogin() {
    if(_phoneNumber.length < 11){
      toastError("Invalid phone number!");
      return;
    }

    startLoading(context);
    _formattedPhoneNumber = Repository.getInstance().formatPhoneNumberWithCountryCode(_phoneNumber);
    _auth.verifyPhoneNumber(phoneNumber: _formattedPhoneNumber, timeout: Duration(minutes: 1), verificationCompleted: _verificationCompleted, verificationFailed: _verificationFailed, codeSent: _codeSent, codeAutoRetrievalTimeout:  _codeAutoRetrievalTimeout);
  }

  void _verificationCompleted(AuthCredential phoneAuthCredential) {
    loadingSuccessful(null);
  }

  void _verificationFailed(AuthException error) {
    loadingFailed(error.message);
  }

  Future<void> _codeSent(String verificationId, [int forceResendingToken]) async {
    loadingSuccessful("Code sent!");
    var data = {"phone_number": _formattedPhoneNumber, "forceResendingToken" : forceResendingToken, "verificationId" : verificationId };
    var response = await Navigator.pushNamed(context, '/login/otp', arguments: data );
    if(response != null){
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }

  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    loadingFailed(null);
  }
}