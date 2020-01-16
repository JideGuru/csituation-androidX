import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:college_situation/api/findschoolBackend.dart';
import 'package:college_situation/common/constants.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/common/widgets/findSchoolWidget.dart';
import 'package:college_situation/models/findSchoolModel.dart';
import 'package:college_situation/dashboard/drawer_widget.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:college_situation/pages/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindSchool extends StatefulWidget {
  final UserModel data;
  const FindSchool({Key key, @required this.data}) : super(key: key);

  @override
  _FindSchoolState createState() {
    return new _FindSchoolState();
  }
}

class _FindSchoolState extends State<FindSchool> {
  List<SchoolData> schoolDataList = new List();
  bool isLoading = true;
  int currentPage = 1;
  String token;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  _appBarActions() {
    return <Widget>[
      new IconButton(
        icon: new Icon(Icons.search),
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => Search())),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(data: widget.data),
      appBar: AppBar(
        actions: _appBarActions(),
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                schoolDataList.length > 0
                    ? '${schoolDataList[currentPage].name}'
                    : '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
            Text(
                schoolDataList.length > 0
                    ? '${schoolDataList[currentPage].city}, ${schoolDataList[currentPage].state}'
                    : '',
                style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isLoading
                ? SpinKitFadingCircle(
                    color: MyColors.blue,
                    size: 50.0,
                  )
                : Flexible(
                    child: PageView.builder(
                      onPageChanged: (int thisPage) {
                        setState(() {
                          currentPage = thisPage;
                        });
                      },
                      controller: PageController(
                        initialPage: 1,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: schoolDataList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return FindSchoolWidget(
                          schoolData: schoolDataList[i],
                          fromSearch: false,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      /* bottomNavigationBar: bmnav.BottomNav(
        iconStyle: bmnav.IconStyle(onSelectColor: MyColors.blue),
        items: [
          bmnav.BottomNavItem(Icons.home, label: ''),
          bmnav.BottomNavItem(Icons.favorite, label: ''),
          bmnav.BottomNavItem(Icons.local_library, label: ''),
          bmnav.BottomNavItem(Icons.pages, label: ''),
          bmnav.BottomNavItem(Icons.view_headline, label: '')
        ],
      ), */
    );
  }

  Future<void> loadData() async {
    var prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {} finally {
      setState(() {
        token = prefs.getString(Constants.token);
      });

      try {
        var firstResponse = await FindSchoolBackend.get(token);
        // print(firstResponse);
        Map dataMap = jsonDecode(firstResponse);
        var data = FindSchoolModel.fromJson(dataMap);

        if (firstResponse != null) {
          setState(() {
            isLoading = false;
            schoolDataList = shuffle(data.data);
          });
        } else {
          loadData();
        }
      } catch (e) {
        // Handle error...
      }
    }
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
}
