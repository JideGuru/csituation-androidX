import 'package:college_situation/accounts/student_sign_up.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/widgets/cusom_app_bar.dart';
import 'package:flutter/material.dart';

class CreateAccountWidget extends StatefulWidget {
  
 // const CreateAccountWidget({Key key, @required this.data}) : super(key: key);
  @override
  _CreateAccountWidgetState createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  var formKey = new GlobalKey<ScaffoldState>();
  var autoValidate = false;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.grey[800]),
        actions: <Widget>[
          IconButton(
              iconSize: 30,
              padding: EdgeInsets.all(20),
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: formKey,
            autovalidate: autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 60,
                ),
                Text(
                  'Create Account',
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(height: 20),
                Text(
                  'Who are you?',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 70),
                _CustomButton(
                    title: 'Student',
                    subTitle: 'You must have completed Grade 12 of High School',
                    color: MyColors.red,
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => StudentSignUpWidget()));
                    }),
                _CustomButton(
                    title: 'Visa Agent',
                    subTitle:
                        'Your business must be registered with your local Authority',
                    color: MyColors.green,
                    onPressed: () {}),
                _CustomButton(
                    title: 'University',
                    subTitle: 'Must be an accredited University / College / Polytechnic',
                    color: MyColors.blue,
                    onPressed: () {})
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color color;
  final VoidCallback onPressed;

  _CustomButton(
      {@required this.title,
      @required this.subTitle,
      @required this.color,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 100,
        width: double.infinity,
        child: FlatButton(
          onPressed: onPressed,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  subTitle,
                  style: TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
          color: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ));
  }
}
