import 'dart:convert';

import 'package:college_situation/common/constants.dart';
import 'package:college_situation/common/functions.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/api/storiesBackend.dart';
import 'package:college_situation/models/storiesModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryDetails extends StatefulWidget {
  final String id;
  final String ownerId;

  const StoryDetails({
    Key key,
    @required this.id,
    this.ownerId,
  }) : super(key: key);

  @override
  _StoryDetailsState createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
  StoriesData storyData;
  bool notNull(Object o) => o != null;
  String firstResponse;
  Map dataMap;
  String token;
  bool isLoading = true;
  int registedOn = DateTime.now().year;
  String adPostedOn;
  ScrollController _scrollController;
  bool showListingHeader = false;
  UserModel userModel;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    getListingDetails();
    super.initState();
  }

  _listener() {
    if (_scrollController.offset > 320) {
      setState(() {
        showListingHeader = true;
      });
    } else {
      setState(() {
        showListingHeader = false;
      });
    }
  }

  getListingDetails() async {
    var prefs = await SharedPreferences.getInstance();
    var t = prefs.getString('userData');

    if (t != null)
      setState(() {
        userModel = UserModel.fromJson(json.decode(t));
      });

    print(userModel.user.sId);
    print(widget.ownerId);

    setState(() {
      token ??= prefs.getString(Constants.token);
    });

    try {
      firstResponse =
          await StoriesBackend.getSingleStoryDetails(widget.id, token);

      if (firstResponse != null) {
        setState(() {
          dataMap = jsonDecode(firstResponse);
          storyData = StoriesData.fromJson(dataMap["data"]);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget storyHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.80,
            child: Text(
              storyData.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(45 / 360),
              child: Icon(
                FontAwesomeIcons.thumbtack,
                color: Colors.grey[400],
                size: 14,
              ),
            ),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        centerTitle: true,
        title: Container(
          child: Text(
            'STORY',
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
          : Container(
              child: Column(
                children: <Widget>[
                  showListingHeader
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          color: MyColors.blue,
                          height: 60,
                          child: storyHeader(),
                        )
                      : null,
                  Flexible(
                    child: ListView(
                      controller: _scrollController,
                      shrinkWrap: true,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 230,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 230,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/story.gif'),
                                            fit: BoxFit.cover,
                                            // colorBlendMode: BlendMode.color,
                                            // color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                  
                            ),
                            Positioned(
                              bottom: 30,
                              child: storyHeader(),
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
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
                                            '${Functions().timeAgo(DateTime.parse(storyData.dateOfCreation))}',
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
                                        'Author: ${storyData.owner.firstName} ${storyData.owner.lastName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                          fontSize: 15,
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
                                margin: EdgeInsets.only(top: 30, bottom: 40),
                                child: Text(
                                  storyData.description,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 12),
                                      child: Text(
                                        'Author',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 55,
                                                height: 55,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: ClipRRect(
                                                  clipBehavior: Clip.antiAlias,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Image.asset(
                                                    'assets/images/user_avatar.png',
                                                    color: Colors.grey[300],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                          '${storyData.owner.firstName} ${storyData.owner.lastName}'),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Joined in $registedOn',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: Container(
                                              child: Column(
                                                children: <Widget>[
                                                  widget.ownerId ==
                                                          userModel.user.sId
                                                      ? InkWell(
                                                          onTap: () {
                                                            delete(widget.id);
                                                          },
                                                          child: Container(
                                                            width: 150,
                                                            height: 35,
                                                            child: Center(
                                                              child: Text(
                                                                'Delete Story',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: MyColors
                                                                    .lDRed,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Container(
                        //     margin: EdgeInsets.symmetric(vertical: 50),
                        //     child: Container(
                        //       margin: EdgeInsets.only(bottom: 30),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: <Widget>[

                        //           InkWell(
                        //             onTap: () async {
                        //               await Share.share(
                        //                   '''Checkout this scholarship curated by the College Situation:

                        //               ${storyData.}''');
                        //             },
                        //             child: Container(
                        //               margin: EdgeInsets.only(right: 14),
                        //               padding: EdgeInsets.symmetric(
                        //                   horizontal: 20, vertical: 12),
                        //               decoration: BoxDecoration(
                        //                   color: Colors.grey[500],
                        //                   borderRadius:
                        //                       BorderRadius.circular(4)),
                        //               child: Row(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     margin: EdgeInsets.only(right: 6),
                        //                     child: Icon(
                        //                       FontAwesomeIcons.shareAlt,
                        //                       color: Colors.white,
                        //                       size: 12,
                        //                     ),
                        //                   ),
                        //                   Text(
                        //                     'Share',
                        //                     style: TextStyle(
                        //                       color: Colors.white,
                        //                       fontSize: 14,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ].where(notNull).toList(),
              ),
            ),
    );
  }

  void delete(String id) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            content: Container(
              child: Text('Are you sure you want to Delete this Post?'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  await StoriesBackend.deleteSingleStoryDetails(id, token);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: MyColors.blue,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
