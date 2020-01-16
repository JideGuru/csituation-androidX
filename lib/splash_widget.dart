import 'package:college_situation/accounts/create_account_widget.dart';
import 'package:college_situation/accounts/login_widget.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:flutter/material.dart';

class SplashWidget extends StatefulWidget {
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 1));
    //print("Loaded");
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (BuildContext context) => LoginWidget()),
    //     (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/loginbg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).padding.top,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, bottom: 20),
                      child: Image.asset(
                        'assets/images/logo.png',
                        scale: 4,
                      ),
                    ),
                    Container(
                      width: 220,
                      margin: EdgeInsets.only(bottom: 10),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        onPressed: () => Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (_) => LoginWidget())),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: MyColors.red,
                      ),
                    ),
                    Container(
                      width: 220,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        onPressed: () => Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (_) => CreateAccountWidget())),
                        child: Text(
                          'Signup',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: MyColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 130,
              ),
              width: 200,
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Connecting Students with ',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Schools, Jobs, Scholarships, Roommates,',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' and '),
                        TextSpan(
                            text: 'Fellow Students',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' Abroad.')
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
