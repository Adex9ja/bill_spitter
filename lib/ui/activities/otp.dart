import 'dart:async';
import 'package:bill_splitter/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

class OTPActivity extends StatefulWidget{
  @override
  _OTPActivity createState() => _OTPActivity();

}

class _OTPActivity extends State<OTPActivity>{
  Timer _waitingTimer;
  int _duration = 30;
  int _times = 1;
  String _phoneNumber;
  String _verificationId;
  int _forceResendingToken;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed( Duration(seconds: 1), () => startCounter());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _waitingTimer?.cancel();
  }


  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments as Map;
    _phoneNumber = data['phone_number'];
    _forceResendingToken = data['forceResendingToken'];
    _verificationId = data['verificationId'];
    final pinText = PinCodeTextField(
      backgroundColor: Colors.transparent,
      length: 6,
      obsecureText: false,
      animationType: AnimationType.fade,
      shape: PinCodeFieldShape.box,
      animationDuration: Duration(milliseconds: 300),
      borderRadius: BorderRadius.circular(5),
      fieldHeight: 50,
      fieldWidth: 40,
      activeFillColor: colorLightGrey,
      inactiveColor: colorLightGrey,
      onChanged: (value) => () => {},
      onCompleted: otpCodeCompleted,
    );
    final message = Text("I did not receive the code!", style: style.copyWith(fontSize: 16),);
    final resendButton = FlatButton(
      onPressed: () => attemptResendCode(),
      child: Text("Resend Code" + (_duration == 0 ? "" : "  [ 00:${_duration.toString().padLeft(2, '0')} ]"), style: style.copyWith(color: _duration == 0 ? colorPrimary : colorGrey),),
    );
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("SMS Code Verification"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: <Widget>[
                  Image.asset("assets/bill_3.png",  fit: BoxFit.cover, width: MediaQuery.of(context).size.width,),
                  mediumSize,
                  pinText,
                  mediumSize,
                  message,
                  mediumSize,
                  resendButton,
                ],
              )
              ,
            ),
          ),
        )
    );
  }

  onError(Object obj) {
    loadingFailed("Invalid Code Entered!");
  }

  attemptResendCode() {
    if(_duration == 0){
      if(_times < 3)
        resendCode();
      else
        promptNumberBlock();
    }
  }

  startCounter() {
    const oneSec = const Duration(seconds: 1);
    _waitingTimer = new Timer.periodic( oneSec, (timer){
      setState(() {
        if (_duration < 1){
          timer.cancel();
        }
        else
          _duration = _duration - 1;
      });
    });
  }

  void resendCode() {
    startLoading(context);
    _auth.verifyPhoneNumber(phoneNumber: _phoneNumber, timeout: Duration(minutes: 1), verificationCompleted: _verificationCompleted, verificationFailed: _verificationFailed, codeSent: _codeSent, codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout, forceResendingToken:  _forceResendingToken);
  }

  void promptNumberBlock() {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Message", style: style,),
        content: Text("Please note! Your number will get blocked due to multiple attempts to resend OTP code", style: style,),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: style,),
          ),
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
              resendCode();
            },
            child: Text("Proceed", style: style,),
          )
        ],
      );
    });
  }


  void _codeAutoRetrievalTimeout(String verificationId) {
    loadingFailed(null);
  }

  void _verificationFailed(AuthException error) {
    loadingFailed(error.message);
  }

  void _verificationCompleted(AuthCredential phoneAuthCredential) {
    Navigator.of(context).pop({'data': _phoneNumber });
  }

  void _codeSent(String verificationId, [int forceResendingToken]) {
    loadingFailed("Code sent");
  }

  void otpCodeCompleted(String value) {
    var credential = PhoneAuthProvider.getCredential(verificationId: _verificationId, smsCode: value);
    _auth.signInWithCredential(credential).then((result){
      _verificationCompleted(null);
    }).catchError(onError);
  }
}