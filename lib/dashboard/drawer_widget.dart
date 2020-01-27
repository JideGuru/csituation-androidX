import 'package:college_situation/dashboard/profilePage.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:college_situation/pages/comingSoon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:college_situation/dashboard/dashboard_widget.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/pages/findSchool.dart';
import 'package:college_situation/splash_widget.dart';
import 'package:college_situation/pages/stories/storiesListing.dart';
// import 'package:college_situation/pages/room/roomListing.dart';
// import 'package:college_situation/pages/room/roomListingCreation.dart';
import 'package:college_situation/pages/scholarships/scolarshipListing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  final UserModel data;
  const DrawerWidget({Key key, @required this.data}) : super(key: key);
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  comingSoonAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: ComingSoon(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Color(0xFF36497B),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: new Column(
              children: <Widget>[
                /* Image.asset(
                  'assets/images/logo.png',
                  scale: 0.5
                ), */
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/user_avatar.png',
                            color: Colors.grey[300],
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ProfilePage()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 210,
                            child: Text(
                                '${widget?.data?.user?.firstName ?? ''} ${widget?.data?.user?.lastName ?? ''}'
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: MyColors.green,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: MyColors.blue,
            child: ListView(
              children: <Widget>[
                _ItemWidget('Home', [
                  _Item(
                      'Dashboard',
                      Icons.dashboard,
                      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DashboardWidget(data: widget.data)))),
                ]),
                _ItemWidget('School', [
                  _Item('Find School', FontAwesomeIcons.university,
                      () => handleOptionsClick(0, context)),
                  // _Item('Compare Schools', FontAwesomeIcons.balanceScale,
                  //     () => comingSoonAlert()),
                ]),
                // _ItemWidget('Housing', [
                //   _Item(
                //       'Find a Room / House',
                //       FontAwesomeIcons.searchLocation,
                //       () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                //           builder: (BuildContext context) => RoomListing(data: widget.data,)))),
                //   _Item(
                //       'Post Room',
                //       Icons.add_circle,
                //       () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                //           builder: (BuildContext context) => CreateListing(data: widget.data,)))),
                // ]),
                // _ItemWidget('Jobs & Internships', [
                //   _Item('Find Jobs/Internships', Icons.find_in_page,
                //       () => comingSoonAlert()),
                // ]),

                _ItemWidget('Scholarships', [
                  _Item(
                      'Find Scholarships',
                      FontAwesomeIcons.listAlt,
                      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ScholarshipListing(data: widget.data,)))),
                ]),
                _ItemWidget('Visa & Immigration', [
                  _Item(
                      'Share / Read Stories & Tips',
                      FontAwesomeIcons.creativeCommonsShare,
                      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StoriesListing(data: widget.data,)))),
                ]),

                _ItemWidget('Resources', [
                  _Item('Free Resources', FontAwesomeIcons.fileAlt,
                      () => comingSoonAlert()),
                ]),
                _ItemWidget(
                    'Settings',
                    [
                      _Item('Preferences', FontAwesomeIcons.cog,
                          () =>   Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ProfilePage()))
                      ),
                      _Item('Logout', FontAwesomeIcons.signOutAlt,
                          () => logOutDialog(context)),
                    ],
                    true),
              ],
            ),
          ))
        ],
      ),
    );
  }

  handleOptionsClick(int index, BuildContext context) {
    // Navigator.of(context).pop();
    if (index == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => new FindSchool(data: widget.data,)));
    }
  }
}

logOutDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Container(
            child: Text('Are you sure you want to Log out?'),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
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
              onPressed: () => logOutUser(context),
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

logOutUser(BuildContext context) async {
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
                builder: (BuildContext context) => SplashWidget()),
            (Route<dynamic> route) => false);
      }
    });
  }
}

class _ItemWidget extends StatelessWidget {
  final String title;
  final List<_Item> items;
  final bool isLast;

  _ItemWidget(this.title, this.items, [this.isLast = false]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
                Column(
                  children: items.map((item) {
                    return FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          item.onPressed();
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: 10, bottom: 4),
                                      child: Icon(
                                        item.icon,
                                        size: 17,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: MyColors.green,
                            )
                          ],
                        ));
                  }).toList(),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          isLast
              ? SizedBox()
              : Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.grey,
                  height: 0.5,
                )
        ],
      ),
    );
  }
}

class _Item {
  String title;
  IconData icon;
  VoidCallback onPressed;

  _Item(this.title, this.icon, this.onPressed);
}
