import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:college_situation/common/constants.dart';
import 'package:college_situation/dashboard/dashboard_widget.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:college_situation/models/listingModel.dart';
import 'package:college_situation/common/auth.dart';
import 'package:college_situation/common/validations.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/widgets/roundedButton.dart';
import 'package:college_situation/pages/room/listingDetails.dart';

class CreateListing extends StatefulWidget {
  final UserModel data;

  const CreateListing({Key key, @required this.data}) : super(key: key);
  @override
  _CreateListingState createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  ListingFormData listingFormData = ListingFormData();
  List<File> attachedPhotos = [];
  List<String> attachedEncodedPhotos = [];
  Forms forms = Forms();
  bool _autovalidate = false;
  final FocusNode focusNode = new FocusNode();
  Validations validations = new Validations();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isDogFriendly = false;
  bool isCatFriendly = false;
  String currentUserData;
  String parsedDate;
  String token;
  DateTime selectedDate;
  bool notNull(Object o) => o != null;

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
        currentUserData = prefs.getString('allCurrentUserData');
      });
    }
  }

  getDate(BuildContext context) async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2008),
      lastDate: DateTime(2022),
      initialDate: selectedDate ?? DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    showDialog(
      context: context,
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
    } else if (selectedDate == null) {
      Navigator.pop(context);
      showInSnackBar(
          'Please enter the available date of item you are listing.');
    } else if (attachedPhotos.length < 6) {
      Navigator.pop(context);
      showInSnackBar('Minimum of 6 photos is required');
    } else {
      form.save();
      listingFormData.photos = attachedEncodedPhotos;
      listingFormData.owner = Owner.fromJson(jsonDecode(currentUserData));
      selectedDate = selectedDate ?? DateTime.now();
      listingFormData.availability =
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      forms.submitListing(listingFormData, token).then((value) {
        Navigator.of(context).pop();
        if (value['res']) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => ListingDetails(
                id: value['id'],
              ),
            ),
          );
        } else {
          showInSnackBar('There was an error submitting your listing.');
        }
      });
    }
  }

  getImage() async {
    File image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print(e.message);
    } finally {
      if (image != null) {
        setState(() {
          String encodedPhoto = base64Encode(image.readAsBytesSync());
          String mtype = MimeTypeResolver().lookup(image.path);
          String encPhoto = 'data:$mtype;base64,$encodedPhoto';
          attachedEncodedPhotos.add(encPhoto);
          attachedPhotos.add(image);
          print(attachedEncodedPhotos);
        });
      }
    }
  }

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
            'New Rental Listing',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
            child: new Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  attachedPhotos.length > 0
                      ? Container(
                          margin:
                              EdgeInsets.only(bottom: 20, right: 10, left: 10),
                          height: 200,
                          child: ListView.builder(
                            itemCount: attachedPhotos.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              Widget myWidget;
                              if (attachedPhotos.length - 1 == i) {
                                myWidget = Container(
                                  child: Row(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            height: 200,
                                            width: 150,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.file(
                                                attachedPhotos[i],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 20,
                                            top: 10,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  attachedEncodedPhotos
                                                      .removeAt(i);
                                                  attachedPhotos.removeAt(i);
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkResponse(
                                        onTap: attachedPhotos.length != 10
                                            ? getImage
                                            : null,
                                        child: Container(
                                          height: 200,
                                          width: 160,
                                          child: Center(
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 6, bottom: 7),
                                                    child: Icon(
                                                      Icons.add_a_photo,
                                                      color: MyColors.blue,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      'Add Photos',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                myWidget = Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 200,
                                      width: 160,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.file(
                                          attachedPhotos[i],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    Positioned(
                                      right: 20,
                                      top: 10,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            attachedPhotos.removeAt(i);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return myWidget;
                            },
                          ),
                        )
                      : InkResponse(
                          onTap: getImage,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 20, right: 10, left: 10),
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: 6, bottom: 7),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: MyColors.blue,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Add Photos',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                  (attachedPhotos.length > 0 && attachedPhotos.length < 6)
                      ? Container(
                          margin:
                              EdgeInsets.only(bottom: 10, right: 10, left: 10),
                          child: Text(
                            'Minimum of 6 photos is required',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      : null,
                  Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: Text(
                      'Photos ${attachedPhotos.length}/10 - Choose your main photo and add supporting images to best showcase the property you\'re listing.',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30, right: 10, left: 10),
                    child: Text(
                      'Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: new DropdownButtonFormField<String>(
                      onChanged: (String val) {
                        setState(() {
                          listingFormData.type = val;
                        });
                      },
                      onSaved: (String val) {
                        listingFormData.type = val;
                      },
                      validator: (value) =>
                          validations.validateDropDown('RT', value),
                      value: listingFormData.type,
                      items: <String>[
                        'Apartment/Condo',
                        'House',
                        'Room only',
                        'Townhouse',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Rental type',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: TextFormField(
                      onSaved: (String value) {
                        listingFormData.address = value;
                      },
                      validator: (value) => validations.validateAddress(value),
                      decoration: InputDecoration(
                        hintText: 'Rental Address',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: TextFormField(
                      onSaved: (String value) {
                        listingFormData.city = value;
                      },
                      validator: (value) => validations.validateCity(value),
                      decoration: InputDecoration(
                        hintText: 'City',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: TextFormField(
                      onSaved: (String value) {
                        listingFormData.state = value;
                      },
                      validator: (value) => validations.validateState(value),
                      decoration: InputDecoration(
                        hintText: 'State',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        listingFormData.zip = value;
                      },
                      validator: (value) => validations.validateZipCode(value),
                      decoration: InputDecoration(
                        hintText: 'Zip',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        listingFormData.bedrooms = value;
                      },
                      validator: (value) => validations.validateBedroom(value),
                      decoration: InputDecoration(
                        hintText: 'No. of Bedrooms',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        listingFormData.bathrooms = value;
                      },
                      validator: (value) => validations.validateBathroom(value),
                      decoration: InputDecoration(
                        hintText: 'No. of Bathroom',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        listingFormData.price = value;
                      },
                      validator: (value) => validations.validatePrice(value),
                      decoration: InputDecoration(
                        hintText: 'Price per month',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        listingFormData.size = value;
                      },
                      validator: (value) => validations.validateSize(value),
                      decoration: InputDecoration(
                        hintText: 'Square feet',
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
                  GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(focusNode),
                    child: new Container(
                      margin: EdgeInsets.only(bottom: 40, right: 10, left: 10),
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
                          validator: (value) => validations.validateDesc(value),
                          onSaved: (String value) {
                            listingFormData.briefDescription = value;
                          },
                          maxLines: null,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Brief description',
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
                  Container(
                    margin: EdgeInsets.only(bottom: 30, right: 10, left: 10),
                    child: Text(
                      'More Info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: InkWell(
                      onTap: () => getDate(context),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                        child: Text(
                          selectedDate == null
                              ? 'Date available'
                              : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Cat Friendly',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Switch(
                          onChanged: (bool value) {
                            setState(() {
                              isCatFriendly = value;
                              if (value) {
                                listingFormData.catFriendly = "Yes";
                              } else {
                                listingFormData.catFriendly = "No";
                              }
                            });
                          },
                          value: isCatFriendly,
                          activeColor: MyColors.blue,
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Dog Friendly',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Switch(
                          onChanged: (bool value) {
                            setState(() {
                              isDogFriendly = value;
                              if (value) {
                                listingFormData.dogFriendly = "Yes";
                              } else {
                                listingFormData.dogFriendly = "No";
                              }
                            });
                          },
                          value: isDogFriendly,
                          activeColor: MyColors.blue,
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: new DropdownButtonFormField<String>(
                      onChanged: (String val) {
                        setState(() {
                          listingFormData.laundryType = val;
                        });
                      },
                      onSaved: (String val) {
                        listingFormData.laundryType = val;
                      },
                      validator: (value) =>
                          validations.validateDropDown('LT', value),
                      value: listingFormData.laundryType,
                      items: <String>[
                        'In-unit laundry',
                        'Laundry in building',
                        'Laundry available',
                        'None',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Laundry type',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: new DropdownButtonFormField<String>(
                      onChanged: (String val) {
                        setState(() {
                          listingFormData.parkingType = val;
                        });
                      },
                      onSaved: (String val) {
                        listingFormData.parkingType = val;
                      },
                      validator: (value) =>
                          validations.validateDropDown('PT', value),
                      value: listingFormData.parkingType,
                      items: <String>[
                        'Garage parking',
                        'Street parking',
                        'Off-street parking',
                        'Parking available',
                        'None',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Parking type',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: new DropdownButtonFormField<String>(
                      onChanged: (String val) {
                        setState(() {
                          listingFormData.acType = val;
                        });
                      },
                      onSaved: (String val) {
                        listingFormData.acType = val;
                      },
                      validator: (value) =>
                          validations.validateDropDown('AT', value),
                      value: listingFormData.acType,
                      items: <String>[
                        'Central AC',
                        'AC available',
                        'None',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Air conditioning type',
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
                  new Container(
                    margin: EdgeInsets.only(bottom: 40, right: 10, left: 10),
                    child: new DropdownButtonFormField<String>(
                      onChanged: (String val) {
                        setState(() {
                          listingFormData.heatingType = val;
                        });
                      },
                      onSaved: (String val) {
                        listingFormData.heatingType = val;
                      },
                      validator: (value) =>
                          validations.validateDropDown('HT', value),
                      value: listingFormData.heatingType,
                      items: <String>[
                        'Central heating',
                        'Electric heating',
                        'Gas heating',
                        'Radiator heating',
                        'Heating available',
                        'None',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Heating type',
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
                  Container(
                    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: Text(
                      'By posting, you confirm this listing comprise with our terms & policies and all applicable laws, including anti-descrimination law.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Center(
                    child: new RoundedButton(
                      buttonName: "Publish",
                      onTap: _handleSubmitted,
                      width: 200,
                      height: 50,
                      bottomMargin: 10,
                      borderWidth: 0,
                      buttonColor: MyColors.blue,
                    ),
                  )
                ].where(notNull).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
