import 'dart:convert';

import 'package:college_situation/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/api/scholarshipBackend.dart';
import 'package:college_situation/models/scholarshipModel.dart';

class ScholarshipDetails extends StatefulWidget {
  final String id;

  const ScholarshipDetails({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _ScholarshipDetailsState createState() => _ScholarshipDetailsState(id: id);
}

class _ScholarshipDetailsState extends State<ScholarshipDetails> {
  final String id;
  _ScholarshipDetailsState({this.id});

  ScholarshipData scholarshipData;
  String firstResponse;
  Map dataMap;
  bool isLoading = true;
  int registedOn = DateTime.now().year;
  String adPostedOn;
  String token;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    getListingDetails();
    super.initState();
  }

  _listener() {
    print(_scrollController.offset);
  }

  getListingDetails() async {
    var prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {} finally {
      setState(() {
        token = prefs.getString(Constants.token);
      });
      try {
        firstResponse =
            await ScholarshipBackend.getSingleScholarshipDetails(id, token);
      } catch (e) {
        print(e.message);
      } finally {
        if (firstResponse != null) {
          setState(() {
            dataMap = jsonDecode(firstResponse);
            scholarshipData = ScholarshipData.fromJson(dataMap["data"]);
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        centerTitle: true,
        title: Container(
          child: Text(
            'SCHOLARSHIP',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: MyColors.blue,
                size: 50.0,
              ),
            )
          : CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                new SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: MyColors.blue,
                  expandedHeight: 350,
                  pinned: true,
                  floating: false,
                  flexibleSpace: new FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(
                      bottom: 20,
                      left: 10,
                    ),
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.58,
                            child: Text(
                              scholarshipData.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(6),
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(45 / 360),
                              child: Icon(
                                FontAwesomeIcons.thumbtack,
                                color: Colors.grey[400],
                                size: 10,
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    background: Container(
                      color: MyColors.blue,
                      child: scholarshipData.photo.length > 0
                          ? Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: scholarshipData.photo,
                                  placeholder:
                                      (BuildContext context, String val) {
                                    return Container(
                                      color: Colors.grey[350],
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                  // errorWidget: (BuildContext context,
                                  //     String val, Exception e) {
                                  //   return Container(
                                  //     color: Colors.grey[350],
                                  //     child: Center(
                                  //       child: Text(
                                  //         'Could not load photo',
                                  //         style: TextStyle(
                                  //           color: Colors.grey[700],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   );
                                  // },
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            stops: [
                                              0.1,
                                              0.2,
                                              0.4,
                                              0.7,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xCC000000)
                                                  .withOpacity(0.0),
                                              Color(0xCC000000)
                                                  .withOpacity(0.2),
                                              Color(0xCC000000)
                                                  .withOpacity(0.4),
                                              Color(0xCC000000)
                                                  .withOpacity(0.6),
                                            ])),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              child: Center(
                                child: Text(
                                  'No photo',
                                  style: TextStyle(
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                  ),
                ),
                new SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: Icon(
                                            Icons.access_time,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                        ),
                                        Text(
                                          scholarshipData.dueDate,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '${scholarshipData.amount}.00',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey[300],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.80,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            'State',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                        Text(
                                          scholarshipData.state,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            'Status',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                        Text(
                                          scholarshipData.status,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            'Educational Level',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                        Text(
                                          scholarshipData.educationalLevel,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey[300],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 30),
                              child: Text(
                                scholarshipData.description,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey[200],
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 50),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
                                    await launch(scholarshipData.link);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 14),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                        color: MyColors.blue,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 6),
                                          child: Icon(
                                            FontAwesomeIcons.link,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                        Text(
                                          'Link to Scholarship',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Share.share(
                                        '''Checkout this scholarship curated by the College Situation:

                                    ${scholarshipData.link}''');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 14),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[500],
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 6),
                                          child: Icon(
                                            FontAwesomeIcons.shareAlt,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
