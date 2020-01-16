import 'dart:async';

import 'package:college_situation/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountsMixin {
  Future saveUserDetails(
      {@required String firstName,
      @required String lastName, 
      @required String token,
      @required String allCurrentUserData,
      @required String email}) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('allCurrentUserData', allCurrentUserData);
    preferences.setString(Constants.lastName, lastName);
    preferences.setString(Constants.firstName, firstName);
    preferences.setString(Constants.userEmail, email);
    preferences.setString(Constants.token, token);
    return;
  }
}
