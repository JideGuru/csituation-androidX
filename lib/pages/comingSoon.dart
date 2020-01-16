import 'package:flutter/material.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/widgets/roundedButton.dart';

class ComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text('Coming Soon 😇',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
                'This feature will be available in the next version ',
            style: TextStyle(
              color: Colors.grey[600],
            ),),
          ),
          Center(
            child: RoundedButton(
              buttonName: "close",
              onTap: () => Navigator.of(context).pop(),
              width: 200.0,
              height: 40.0,
              bottomMargin: 10.0,
              borderWidth: 0.0,
              buttonColor: MyColors.green,
            ),
          )
        ],
      ),
    );
  }
}
