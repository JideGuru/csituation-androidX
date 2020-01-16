import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/widgets/cusom_app_bar.dart';
import 'package:college_situation/common/widgets/roundedButton.dart';
import 'package:college_situation/dashboard/dashboard_widget.dart';

class PaymentSuccess extends StatelessWidget {
  final UserModel data;

  const PaymentSuccess({Key key, @required this.data}) : super(key: key);

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
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.check,
                size: 42,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                color: MyColors.green,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Text('All set!'),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 80),
              child: Text('Thanks for subscribing :)'),
            ),
            new RoundedButton(
              buttonName: "Dashboard",
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DashboardWidget(data: data),
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
