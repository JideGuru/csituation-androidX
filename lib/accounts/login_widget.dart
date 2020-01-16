import 'dart:convert';
import 'package:college_situation/accounts/accounts_mixin.dart';
import 'package:college_situation/accounts/paymentPlans.dart';
import 'package:college_situation/accounts/create_account_widget.dart';
import 'package:college_situation/accounts/trialsEnded.dart';
import 'package:college_situation/api/api.dart';
import 'package:college_situation/api/paymentBackend.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/my_utils.dart';
import 'package:college_situation/common/widgets/cusom_app_bar.dart';
import 'package:college_situation/dashboard/dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> with AccountsMixin {
  var formKey = new GlobalKey<FormState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var autoValidate = false;
  var loading = false;
  bool hasSelectedPlan = false;
  String dateOfSub;

  String email;
  String password;

  @override
  void initState() {
    hasSP();
    super.initState();
  }

  hasSP() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {} finally {
      setState(() {
        hasSelectedPlan = prefs.getBool('hasSelectedPlan') ?? false;
        dateOfSub = prefs.getString('dateOfSub') ?? DateTime.now().toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        iconTheme:
            Theme.of(context).iconTheme.copyWith(color: Colors.grey[800]),
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
                  'Login',
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(height: 10),
                Text(
                  'Sign in with your email & password',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(height: 70),
                new TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 18,
                      )),
                  onSaved: (value) => email = value,
                  validator: (value) => MyUtils.isValidEmail(value)
                      ? null
                      : 'Email address is not valid',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                new TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 18,
                      )),
                  onSaved: (value) => password = value,
                  validator: (value) =>
                      value.length >= 5 ? null : 'Minimum of 5 characters',
                  obscureText: true,
                ),
                SizedBox(height: 30),
                loading
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Forgot password?',
                                style: TextStyle(fontSize: 12),
                              ),
                              FlatButton(
                                  onPressed: () {},
                                  child: Text('Reset Password',
                                      style: TextStyle(
                                          fontSize: 11,
                                          decoration: TextDecoration.underline,
                                          color: Colors.grey[600])))
                            ],
                          ),
                          SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: RaisedButton(
                              onPressed: verifyInputs,
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              color: MyColors.blue,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Don’t have an account?',
                                style: TextStyle(fontSize: 13),
                              ),
                              FlatButton(
                                  onPressed: () => Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (_) =>
                                              CreateAccountWidget())),
                                  child: Text('Signup Now',
                                      style: TextStyle(
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                          color: Colors.grey[600])))
                            ],
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyInputs() async {
    var formState = formKey.currentState;
    if (formState.validate()) {
      setState(() => loading = true);
      formState.save();
      var data = await APIRequest.login(email: email, password: password);

      if (data != null) {
        String firstResponse;
        Map dataMap;
        DateTime planExpiryDate;
        DateTime planStartDate;
        try {
          firstResponse =
              await PaymentBackend.getUserPlan(data.user.sId, data.token);
          await saveUserDetails(
            firstName: data.user.firstName,
            lastName: data.user.lastName,
            token: data.token,
            email: data.user.email,
            allCurrentUserData: json.encode(data.user.toJson()).toString(),
          );

          setState(() => loading = false);
        } catch (e) {
          setState(() => loading = false);
          print(e.message);
        } finally {
          setState(() => loading = false);
          print(firstResponse);
          dataMap = jsonDecode(firstResponse);
          print(dataMap);
          if (dataMap["success"]) {
            planExpiryDate =
                DateTime.parse(dataMap["data"]["endDate"]) ?? DateTime.now();
            planStartDate =
                DateTime.parse(dataMap["data"]["startDate"]) ?? DateTime.now();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => (DateTime.now().millisecondsSinceEpoch <
                          planExpiryDate.millisecondsSinceEpoch)
                      ? DashboardWidget(data:data)
                      : planExpiryDate.difference(planStartDate).inDays == 3
                          ? TrialsEnded(
                              userID: data.user.sId,
                              data: data,
                            )
                          : PaymentPlans(
                              userID: data.user.sId,
                              data: data,
                            ),
                ),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => PaymentPlans(
                    userID: data.user.sId,
                    data: data,
                  ),
                ),
                (Route<dynamic> route) => false);
          }
        }
      } else {
        setState(() => loading = false);
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Incorrect login details'),
          ),
        );
      }
    }
  }
}
