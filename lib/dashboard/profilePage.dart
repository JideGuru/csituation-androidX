import 'dart:convert';

import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  UserModel userData;
  DateTime startDate, endDate;
  

  @override
  void initState() {
    loadPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile & Settings'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20.0),
            height: MediaQuery.of(context).size.height * 0.22,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    offset: Offset(0, 0),
                    spreadRadius: -13,
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 18,
                  ),
                ],
                borderRadius: BorderRadius.circular(0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 75,
                  height: 75,
                  decoration:
                      BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/images/user_avatar.png',
                          color: Colors.grey[700],
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    '${userData?.user?.firstName ?? ''} ${userData?.user?.lastName ?? ''}'
                    '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    '${userData?.user?.email ?? ''}'
                    '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(20.0)
                .add(EdgeInsets.symmetric(vertical: 10)),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    offset: Offset(0, 0),
                    spreadRadius: -13,
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 18,
                  ),
                ],
                borderRadius: BorderRadius.circular(0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('SUBSCRIPTION',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(
                  height: 20,
                ),
                // Text(
                //     'Start Date:  ${startDate?.day ?? ''}/${startDate?.month ?? ''}/${startDate?.year ?? ''}',
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.w400,
                //     )),
                // const SizedBox(
                //   height: 10,
                // ),
                Text(
                    'Expiration Date:  ${endDate?.day ?? ''}/${endDate?.month ?? ''}/${endDate?.year ?? ''}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ))
              ],
            ),
          ),
         /*  Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    offset: Offset(0, 0),
                    spreadRadius: -13,
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 18,
                  ),
                ],
                borderRadius: BorderRadius.circular(0)),
            child: Form(
              key: _formKey,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('RESET PASSWORD',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(
                  height: 30,
                ),
                currPass(),
                const SizedBox(
                  height: 20,
                ),
                newPass(),
                const SizedBox(
                  height: 20,
                ),
                confirmPass(),
                const SizedBox(
                  height: 34,
                ),
                Container(
                  height: 56,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      reset();
                    },
                    textColor: Colors.white,
                    child: Text('RESET PASSWORD'),
                  ),
                )
              ],
            ),),
          ), */
        ],
      ),
    );
  }

  currPass() => TextFormField(
        validator: (value) {
          if (value.isNotEmpty) {
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Current Password is Invalid";
          }
        },
        maxLines: null,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFFAF7F7).withOpacity(0.04),
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(18.0),
            labelText: 'Current Password'),
        keyboardType: TextInputType.text,
      );

  newPass() => TextFormField(
        validator: (value) {
          if (value.isNotEmpty && value.length > 4) {
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "New Password is Invalid";
          }
        },
        maxLines: null,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFFAF7F7).withOpacity(0.04),
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(18.0),
            labelText: 'New Password'),
        keyboardType: TextInputType.text,
      );

  confirmPass() => TextFormField(
        validator: (value) {
          if (value.isNotEmpty) {
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Confirm Password is Invalid";
          }
        },
        maxLines: null,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFFAF7F7).withOpacity(0.04),
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(18.0),
            labelText: 'Confirm Password'),
        keyboardType: TextInputType.text,
      );

     /*  reset()async {
        if(_formKey.currentState.validate()){

        }
      } */

  void loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var t = prefs.getString('userData');
      setState(() {
        userData = UserModel.fromJson(json.decode(t));
      });
      if (userData != null) {
        setState(() {
          startDate =
              DateTime.parse(userData?.user?.userSubscription?.startDate);
          endDate = DateTime.parse(userData?.user?.userSubscription?.endDate);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
