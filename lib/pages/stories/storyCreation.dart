import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:college_situation/common/constants.dart';
import 'package:college_situation/dashboard/dashboard_widget.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:college_situation/models/listingModel.dart';
import 'package:college_situation/api/storiesBackend.dart';
import 'package:college_situation/common/auth.dart';
import 'package:college_situation/common/validations.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/widgets/roundedButton.dart';
import 'package:college_situation/pages/stories/storyDetails.dart';
import 'package:college_situation/models/storiesCatModel.dart';

class StoryCreation extends StatefulWidget {
  final UserModel data;

  const StoryCreation({Key key, @required this.data}) : super(key: key);
  @override
  _StoryCreationState createState() => _StoryCreationState();
}

class _StoryCreationState extends State<StoryCreation> {
  StoryFormData storyFormData = StoryFormData();
  //File attachedPhoto;
  Forms forms = Forms();
  bool _autovalidate = false;
  List<Map> catList = [];
  final FocusNode focusNode = new FocusNode();
  Validations validations = new Validations();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String currentUserData;
  String secondResponse;
  String token;
  Map catDataMap;
  //String encodedPhoto;
  StoriesCatModel catData;
  List<StoryCatData> storyCatData = [];

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
        token = prefs.getString(Constants.token);
      });
      try {
        secondResponse = await StoriesBackend.getStoriesCat(token);
      } catch (e) {
        print(e.message);
      } finally {
        setState(() {
          catDataMap = jsonDecode(secondResponse);
          catData = StoriesCatModel.fromJson(catDataMap);
          storyCatData = catData.data;
          for (int i = 0; i < storyCatData.length; i++) {
            Map catMap = {
              "name": storyCatData[i].name,
              "id": storyCatData[i].sId,
            };
            catList.add(catMap);
          }
          currentUserData = prefs.getString('allCurrentUserData');
        });
      }
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => new AlertDialog(
        content: new Container(
          height: 80,
          child: new Container(
            width: 5,
            child: new Center(
              child: SpinKitFadingCircle(
                color: MyColors.blue,
                size: 50.0,
              ),
            ),
          ),
        ),
      ),
    );
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;
      Navigator.pop(context);
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      // var t = prefs.getString('userData');
      //var userData = UserModel.fromJson(json.decode(t));

      form.save();
      storyFormData.owner = Owner.fromJson(jsonDecode(currentUserData)).sId;
      try {
        var submit = await forms.submitStory(storyFormData, token);
        if (submit != null) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => StoryDetails(
                  id: submit.data.sId, ownerId: submit.data.owner.sId),
            ),
          );
        } else {
          showInSnackBar('There was an error submitting your story.');
        }
      } catch (e) {}
    }
  }

  // getImage() async {
  //   File image;
  //   try {
  //     image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   } catch (e) {
  //     print(e.message);
  //   } finally {
  //     if (image != null) {
  //       setState(() {
  //         encodedPhoto = base64Encode(image.readAsBytesSync());
  //         String mtype = MimeTypeResolver().lookup(image.path);
  //         storyFormData.photo = 'data:$mtype;base64,$encodedPhoto';
  //         attachedPhoto = image;
  //       });
  //     }
  //   }
  // }

  Future<bool> willPop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content:
            new Container(child: new Text('Are you sure you want to go back?')),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: new Text('Yes'),
          )
        ],
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DashboardWidget(data: widget.data),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Share Experience',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text(
          //       'Cancel',
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //     onPressed: () => Navigator.of(context).pop(),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 12),
            child: new Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 20, top: 20, right: 10, left: 10),
                    child: TextFormField(
                      onSaved: (String value) {
                        storyFormData.title = value;
                      },
                      validator: (value) =>
                          validations.validateStoryTitle(value),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  // InkResponse(
                  //   onTap: getImage,
                  //   child: Container(
                  //     margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                  //     width: MediaQuery.of(context).size.width,
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  //     child: Row(
                  //       children: <Widget>[
                  //         new Container(
                  //           margin: EdgeInsets.only(right: 12),
                  //           child: new Icon(
                  //             Icons.camera_alt,
                  //             size: 16,
                  //           ),
                  //         ),
                  //         Expanded(
                  //           child: Container(
                  //             child: attachedPhoto != null
                  //                 ? Text(
                  //                     attachedPhoto.path.split('/').last,
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: TextStyle(
                  //                       color: Colors.grey,
                  //                     ),
                  //                   )
                  //                 : Text(
                  //                     'Select photo...',
                  //                     style: TextStyle(
                  //                       color: Colors.grey,
                  //                     ),
                  //                   ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: Colors.grey,
                  //       ),
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: DropdownButtonFormField<String>(
                      onChanged: (String val) {
                        setState(() {
                          storyFormData.category = val;
                        });
                      },
                      onSaved: (String val) {
                        storyFormData.category = val;
                      },
                      validator: (value) =>
                          validations.validateStoryCatDropDown(value),
                      value: storyFormData.category,
                      items: catList.map((Map value) {
                        return DropdownMenuItem(
                          value: value['id'].toString(),
                          child: new Text(value['name']),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Select Category',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(focusNode),
                    child: new Container(
                      margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        child: TextFormField(
                          validator: (value) =>
                              validations.validateStoryDesc(value),
                          onSaved: (String value) {
                            storyFormData.description = value;
                          },
                          maxLines: null,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: new DropdownButtonFormField<String>(
                      onChanged: (String val) {
                        setState(() {
                          storyFormData.featured = val;
                        });
                      },
                      onSaved: (String val) {
                        storyFormData.featured = val;
                      },
                      value: storyFormData.featured,
                      items: <String>[
                        'Yes',
                        'No',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toLowerCase(),
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Feature story?',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 7.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: new RoundedButton(
                      buttonName: "Publish",
                      onTap: _handleSubmitted,
                      width: 200,
                      height: 40,
                      bottomMargin: 10,
                      borderWidth: 0,
                      buttonColor: MyColors.blue,
                    ),
                  ),
                  Center(
                    child: new RoundedButton(
                      buttonName: "Cancel",
                      onTap: () => Navigator.of(context).pop(),
                      width: 200.0,
                      height: 40.0,
                      bottomMargin: 10.0,
                      borderWidth: 0.0,
                      buttonColor: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
