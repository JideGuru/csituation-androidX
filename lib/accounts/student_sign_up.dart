import 'dart:convert';
import 'dart:io';

import 'package:college_situation/accounts/accounts_mixin.dart';
import 'package:college_situation/accounts/login_widget.dart';
import 'package:college_situation/accounts/paymentPlans.dart';
import 'package:college_situation/api/api.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/my_strings.dart';
import 'package:college_situation/common/my_utils.dart';
import 'package:college_situation/common/widgets/cusom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentSignUpWidget extends StatefulWidget {
  @override
  _StudentSignUpWidgetState createState() => _StudentSignUpWidgetState();
}

class _StudentSignUpWidgetState extends State<StudentSignUpWidget>
    with AccountsMixin {
  var formKey = new GlobalKey<FormState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var autoValidate = false;
  var loading = false;

  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPassword;

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
                  'Student Signup',
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(height: 10),
                Text(
                  'Are you a student? Register here',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(height: 70),
                new TextFormField(
                  decoration: InputDecoration(labelText: 'First name'),
                  onSaved: (value) => firstName = value,
                  validator: (value) =>
                      value.isNotEmpty ? null : Strings.fieldReq,
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: 20),
                new TextFormField(
                  decoration: InputDecoration(labelText: 'Last name'),
                  onSaved: (value) => lastName = value,
                  validator: (value) =>
                      value.isNotEmpty ? null : Strings.fieldReq,
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: 20),
                new TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onSaved: (value) => email = value,
                  validator: (value) => MyUtils.isValidEmail(value)
                      ? null
                      : 'Email address is not valid',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                new TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  onSaved: (value) => password = value,
                  validator: (value) =>
                      value.length >= 5 ? null : 'Minimum of 5 characters',
                  obscureText: true,
                ),
                SizedBox(height: 20),
                new TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm password'),
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
                          SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: RaisedButton(
                              onPressed: verifyInputs,
                              child: Text(
                                'Register',
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
                                'Already have an account?',
                                style: TextStyle(fontSize: 13),
                              ),
                              FlatButton(
                                  onPressed: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                          builder: (_) => LoginWidget(),
                                        ),
                                      ),
                                  child: Text('Login Now',
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
    if (!formState.validate()) {
      setState(() => autoValidate = true);
      return;
    }

    formState.save();

    setState(() => loading = true);

    var url = MyUtils.buildUrl('student/register');
    var body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
    var headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    try {
      var response = await http.post(url, headers: headers, body: body);
      setState(() => loading = false);
      print(response.body);
      var responseBody = jsonDecode(response.body);
      bool loggedIn = responseBody['success'] ??= false;
      var data = await APIRequest.login(email: email, password: password);

      setState(() => loading = false);

      if (response.statusCode == HttpStatus.ok && loggedIn) {
        var user = responseBody['user'];
        await saveUserDetails(
          firstName: user['firstName'],
          lastName: user['lastName'],
          token: responseBody['token'],
          email: user['email'],
          allCurrentUserData: jsonEncode(user),
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => PaymentPlans(
                userID: user['_id'],
                data: data,
              ),
            ),
            (Route<dynamic> route) => false);
      } else {
        showSnackMessage();
      }
    } catch (e) {
      showSnackMessage();
    }
  }

  showSnackMessage() {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Something went wrong'),
      ),
    );
  }
}
