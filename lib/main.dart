import 'dart:convert';

import 'package:college_situation/accounts/login_widget.dart';
import 'package:college_situation/accounts/paymentPlans.dart';
import 'package:college_situation/common/constants.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/dashboard/dashboard_widget.dart';
import 'package:college_situation/splash_widget.dart';
import 'package:college_situation/models/listingModel.dart';
import 'package:college_situation/accounts/trialsEnded.dart';
import 'package:college_situation/api/paymentBackend.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/newUserModel.dart';
import 'splash_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Situation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyColors.blue,
        textTheme: GoogleFonts.muliTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashWidget(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  DateTime now = DateTime.now();
  Timer _timer;
  var firstResponse;
  Map dataMap;
  DateTime planExpiryDate;
  DateTime planStartDate;
  var loggedIn;
  var hasSelectedPlan;
  var dateOfSub;
  var currentUserData;

  getUserPlan() async {
    loggedIn =
        (await SharedPreferences.getInstance()).getString(Constants.token);
    hasSelectedPlan =
        (await SharedPreferences.getInstance()).getBool('hasSelectedPlan') ??
            false;
    dateOfSub =
        (await SharedPreferences.getInstance()).getString('dateOfSub') ??
            DateTime.now().toString();
    currentUserData =
        (await SharedPreferences.getInstance()).getString('allCurrentUserData');

    UserModel userData;
    if (loggedIn != null && loggedIn.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        var t = prefs.getString('userData');
        setState(() {
          userData = UserModel.fromJson(json.decode(t));
        });
        firstResponse =
            await PaymentBackend.getUserPlan(userData.user.sId, loggedIn);
      } catch (e) {
        print(e.toString());
      } finally {
        if (firstResponse != null)
          setState(() {
            dataMap = json.decode(firstResponse);
            print(dataMap);
            if (dataMap["success"] != null && dataMap["success"]) {
              planExpiryDate =
                  DateTime.parse(dataMap["data"]["endDate"]) ?? DateTime.now();
              planStartDate = DateTime.parse(dataMap["data"]["startDate"]) ??
                  DateTime.now();
              // planStartDate = DateTime.parse('2019-03-21T20:22:36.757Z');
              // planExpiryDate = DateTime.parse('2019-03-24T20:22:36.757Z');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => (DateTime.now().millisecondsSinceEpoch <
                          planExpiryDate.millisecondsSinceEpoch)
                      ? DashboardWidget(data: userData)
                      : planExpiryDate.difference(planStartDate).inDays == 3
                          ? TrialsEnded(
                              userID:
                                  Owner.fromJson(json.decode(currentUserData))
                                      .sId,
                              data: userData,
                            )
                          : PaymentPlans(
                              userID:
                                  Owner.fromJson(json.decode(currentUserData))
                                      .sId,
                              data: userData,
                            ),
                ),
              );
            } else if (dataMap["auth"] != null && !dataMap["auth"]) {
              logOutUser();
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => PaymentPlans(
                      userID: Owner.fromJson(jsonDecode(currentUserData)).sId,
                      data: userData,
                    ),
                  ),
                  (Route<dynamic> route) => false);
            }
          });
      }
    } else {
      navigate();
    }
  }

  logOutUser() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print(e.message);
    } finally {
      prefs.clear().then((value) {
        if (value) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginWidget()),
              (Route<dynamic> route) => false);
        }
      });
    }
  }

  navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SplashWidget(),
      ),
    );
  }

  @override
  void initState() {
    getUserPlan();
    super.initState();
  }

  @override
  void dispose() {
    if (loggedIn == null || loggedIn.isEmpty) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return new Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height / 1.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  child: Image.asset('assets/images/logo.png', scale: 4),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 1.6) / 1.7),
                  child: Text("© ${now.year} The College Situation",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
