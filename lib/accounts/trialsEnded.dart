import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/accounts/paymentPlans.dart';
import 'package:college_situation/common/widgets/cusom_app_bar.dart';
import 'package:college_situation/common/widgets/roundedButton.dart';

class TrialsEnded extends StatelessWidget {
  final String userID;
  final UserModel data;
  TrialsEnded({this.userID, @required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(20),
              child: Icon(FontAwesomeIcons.frown, size: 30, color: Colors.grey[100],),
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Text('Trial Expired!'),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 80),
              child: Text('Your 3-days trial has ended.'),
            ),
            new RoundedButton(
              buttonName: "Subscribe Now",
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => PaymentPlans(
                          userID: userID,
                          data: data,
                        ),
                  ),
                );
              },
              width: 200.0,
              height: 40.0,
              bottomMargin: 10.0,
              borderWidth: 0.0,
              buttonColor: MyColors.green,
            )
          ],
        ),
      ),
    );
  }
}
