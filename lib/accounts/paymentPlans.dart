import 'dart:convert';
import 'dart:io';

import 'package:college_situation/common/constants.dart';
import 'package:college_situation/models/listingModel.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import 'package:college_situation/accounts/accounts_mixin.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/my_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:college_situation/accounts/paymentSuccess.dart';
import 'package:college_situation/accounts/paymentFailed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:college_situation/common/widgets/cusom_app_bar.dart';
import 'package:college_situation/api/paymentBackend.dart';
import 'package:flutter/material.dart';
import 'package:college_situation/models/paymentPlansModel.dart';
import 'package:http/http.dart' as http;

class PaymentPlans extends StatefulWidget {
  final String userID;
  final UserModel data;
  const PaymentPlans({@required this.userID, @required this.data});

  @override
  _PaymentPlansState createState() => _PaymentPlansState();
}

class _PaymentPlansState extends State<PaymentPlans> with AccountsMixin {
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  String selectedPlan = 'monthly';
  String selectedPlanID = '5c866010c80e51c48117129a';
  bool isLoading = true;
  String firstResponse;
  Map dataMap;
  String secondResponse;
  Map dataMap2;
  String planResponse;
  Map planDataMap;
  PaymentPlansModel data;
  Owner currentUserData;
  int selectedPrice = 2;
  String token;
  bool hasAppliedFreeSubscription = false;
  String paystackPublicKey = 'pk_live_4e296d7c28815629752273bfa6551cb2d56fb8b6';
  List<PlanData> plans = [];

  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  getCurrentUserData() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print(e.message);
    } finally {
      setState(() {
        String uData = prefs.getString('allCurrentUserData');
        token = prefs.getString(Constants.token);
        currentUserData = Owner.fromJson(jsonDecode(uData));
      });
      try {
        planResponse =
            await PaymentBackend.getUserPlan(currentUserData.sId, token);
      } catch (e) {
        print(e.message);
      } finally {
        planDataMap = jsonDecode(planResponse);
        print('HHHHHHH $planDataMap');
        if (planDataMap["success"]) {
          setState(() {
            hasAppliedFreeSubscription =
                planDataMap["data"]["hasAppliedFreeSubscription"];
          });
        }
        getPaymentPlans();
      }
    }
  }

  getPaymentPlans() async {
    try {
      firstResponse = await PaymentBackend.getPlans(token);
      secondResponse = await PaymentBackend.getKeys(token);
    } catch (e) {
      print(e.message);
    } finally {
      dataMap = jsonDecode(firstResponse);
      dataMap2 = jsonDecode(secondResponse);
      setState(() {
        paystackPublicKey = dataMap2["data"]["paystackTestPublicKey"];
        PaystackPlugin.initialize(publicKey: paystackPublicKey);
        data = PaymentPlansModel.fromJson(dataMap);
        plans = data.data.reversed.toList();
        isLoading = false;
      });
    }
  }

  submitPlan() async {
    if (selectedPlan == 'free') {
      setState(() => isLoading = true);
      var url = MyUtils.buildUrl('payment/createPayment');
      var body = {
        'authInfo': currentUserData.sId,
        'subscription': selectedPlanID
      };
      var headers = {
        "x-access-token": token,
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      };
      try {
        var response = await http.post(url, headers: headers, body: body);
       // print("LLLLL ${response.body}");
        if (json.decode(response.body)["message"] ==
                "subscription successful" ||
            response.body.contains('has already used freetier')) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => PaymentSuccess(
                data: widget.data,
              ),
            ),
          );
        }
        setState(() => isLoading = false);
      } catch (e) {
        setState(() => isLoading = false);
        print(e.message);
      }
    } else {
      setState(() => isLoading = true);
      var url = MyUtils.buildUrl('payment/createPayment');
      var body = {
        'authInfo': currentUserData.sId,
        'subscription': selectedPlanID,
      };
      var headers = {
        "x-access-token": token,
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      };
      var response;
      var responseBody;
      try {
        response = await http.post(url, headers: headers, body: body);
        setState(() => isLoading = false);
      } catch (e) {
        print(e.message);
      } finally {
        print("JJJJ ${response.body}");
        responseBody = jsonDecode(response.body);
        print(responseBody);
        String tRef = responseBody["data"]["invoice"];
        Charge charge = Charge()
          ..amount = selectedPrice * 375 * 100
          ..reference = tRef
          ..email = currentUserData.email;

        CheckoutResponse checkoutResponse = await PaystackPlugin.checkout(
          context,
          method: CheckoutMethod.card,
          charge: charge,
          fullscreen: true,
        );
        print('Response = ${checkoutResponse.message}');

        if (checkoutResponse.message == "Success") {
          setState(() => isLoading = true);
          var url = MyUtils.buildUrl('payment/verifyPayment');
          var body = {
            'invoice': checkoutResponse.reference,
          };
          var headers = {
            "x-access-token": token,
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
          };
          var response;
          var responseBody;
          try {
            response = await http.post(url, headers: headers, body: body);
            setState(() => isLoading = false);
          } catch (e) {
            print(e.message);
          } finally {
            responseBody = jsonDecode(response.body);
            print(responseBody);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    PaymentSuccess(data: widget.data),
              ),
            );
          }
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => PaymentFailed(
                userID: widget.userID,
                data: widget.data,
              ),
            ),
          );
        }
      }
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
        // actions: <Widget>[
        //   IconButton(
        //       iconSize: 30,
        //       padding: EdgeInsets.all(20),
        //       icon: Icon(Icons.close),
        //       onPressed: () => Navigator.of(context).pop())
        // ],
      ),
      body: isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: MyColors.blue,
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.zero,
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 120,
                          ),
                        ),
                        Container(
                          child: Text(
                            'Select A Plan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 40),
                    child: Text(
                      'Join thousands of students who are enjoying our resources!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: plans.length,
                    itemBuilder: (BuildContext context, int i) {
                      return plans[i].duration == 3
                          ? hasAppliedFreeSubscription
                              ? Card(
                                  margin: EdgeInsets.only(bottom: 30),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: selectedPlan == plans[i].tag
                                            ? Colors.red[400]
                                            : Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, bottom: 12, top: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                                child: Text(
                                                  plans[i].duration == 3
                                                      ? 'Free trial (3 days)'
                                                      : plans[i].duration == 30
                                                          ? 'Monthly'
                                                          : 'Annually',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 12),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.62,
                                                child: Text(
                                                  plans[i].desc,
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  plans[i].duration == 3
                                                      ? 'Valid for only 3 days!'
                                                      : plans[i].duration == 30
                                                          ? 'Valid for one month'
                                                          : 'Valid for a whole year',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[400]),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 20, top: 40),
                                          child: Text(
                                            plans[i].duration == 3
                                                ? 'Free'
                                                : plans[i].duration == 30
                                                    ? '\$${plans[i].price}/mo'
                                                    : '\$${plans[i].price}',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPlanID = plans[i].sId;
                                      selectedPlan = plans[i].tag;
                                      selectedPrice = plans[i].price;
                                    });
                                    print(
                                        "OOOOO $selectedPlanID $selectedPlan");
                                  },
                                  child: Card(
                                    margin: EdgeInsets.only(bottom: 30),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: selectedPlan == plans[i].tag
                                              ? Colors.red[400]
                                              : Colors.white,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10, bottom: 12, top: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  child: Text(
                                                    plans[i].duration == 3
                                                        ? 'Free trial (3 days)'
                                                        : plans[i].duration ==
                                                                30
                                                            ? 'Monthly'
                                                            : 'Annually',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.62,
                                                  child: Text(
                                                    plans[i].desc,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    plans[i].duration == 3
                                                        ? 'Valid for only 3 days!'
                                                        : plans[i].duration ==
                                                                30
                                                            ? 'Valid for one month'
                                                            : 'Valid for a whole year',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          plans[i].tag == 'Anually'
                                              ? Container(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 20),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 6,
                                                                horizontal: 18),
                                                        child: Text(
                                                          'Best Deal',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        color: MyColors.green,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          '\$${plans[i].price}',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20, top: 40),
                                                  child: Text(
                                                    plans[i].duration == 3
                                                        ? 'Free'
                                                        : plans[i].duration ==
                                                                30
                                                            ? '\$${plans[i].price}/mo'
                                                            : '\$${plans[i].price}',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPlanID = plans[i].sId;
                                  selectedPlan = plans[i].tag;
                                  selectedPrice = plans[i].price;
                                });
                                print("KKKKK $selectedPlanID $selectedPlan");
                              },
                              child: Card(
                                margin: EdgeInsets.only(bottom: 30),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: selectedPlan == plans[i].tag
                                          ? Colors.red[400]
                                          : Colors.white,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, bottom: 12, top: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Text(
                                                plans[i].duration == 3
                                                    ? 'Free trial (3 days)'
                                                    : plans[i].duration == 30
                                                        ? 'Monthly'
                                                        : 'Annually',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 12),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.62,
                                              child: Text(
                                                plans[i].desc,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                plans[i].duration == 3
                                                    ? 'Valid for only 3 days!'
                                                    : plans[i].duration == 30
                                                        ? 'Valid for one month'
                                                        : 'Valid for a whole year',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600]),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      plans[i].tag == 'Anually'
                                          ? Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 20),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 18),
                                                    child: Text(
                                                      'Best Deal',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    color: MyColors.green,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      '\$${plans[i].price}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  right: 20, top: 40),
                                              child: Text(
                                                plans[i].duration == 3
                                                    ? 'Free'
                                                    : plans[i].duration == 30
                                                        ? '\$${plans[i].price}/mo'
                                                        : '\$${plans[i].price}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                  Container(
                    width: 300,
                    child: RaisedButton(
                      onPressed: submitPlan,
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: MyColors.green,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms of Service & Privacy policy\n\n',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                                text:
                                    'We won\'t need your card details if you go with free trial, but if you decide to go with the Annual or Monthly Plan, you will be charged immediately. You can also mark it to be a recurring payment')
                          ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
