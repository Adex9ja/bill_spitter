  import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


class WelcomeActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 180,),
            Expanded(
              child: IntroductionScreen(
                globalBackgroundColor: Colors.transparent,
                showNextButton: true,
                showSkipButton: true,
                skip: Text("Skip"),
                next: Text("Next"),
                done: Text("Get Started"),
                pages: getPages(),
                onDone: () => gotoLoginPage(context),
                onSkip: () => gotoLoginPage(context),
              ),
            ),
          ],
        ),
      ),
    );

  }

  final myPage = const PageDecoration(
    bodyTextStyle: TextStyle(fontSize: 14)
  );
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset("assets/bill_1.png"),
        title: "Multiple payment choice",
        body: "You can choose to make payment with multiple cards. You don't have to worry about going low on cash",
        decoration: myPage
      ),
      PageViewModel(
        image: Image.asset("assets/bill_2.jpg"),
        title: "Go Dutch",
        body: "Split bills with your partner while on a date.",
          decoration: myPage
      ),
      PageViewModel(
        image: Image.asset("assets/bill_3.png"),
        title: "Friend's hangout",
        body: "Make your hangout with friend's and family more fun. Share the bill and make everyone feel comfortable",
          decoration: myPage
      ),
    ];
  }

  gotoLoginPage(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

}
