import 'dart:async';
import 'dart:convert';

import 'package:college_situation/api/adviceBackend.dart';
import 'package:college_situation/common/constants.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/dashboard/drawer_widget.dart';
import 'package:college_situation/models/adviceModel.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:college_situation/pages/findSchool.dart';
import 'package:college_situation/pages/scholarships/scolarshipListing.dart';
import 'package:college_situation/pages/stories/storiesListing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DashboardWidget extends StatefulWidget {
  final UserModel data;

  const DashboardWidget({Key key, @required this.data}) : super(key: key);
  @override
  _DashboardWidgetState createState() {
    return new _DashboardWidgetState();
  }
}

class _DashboardWidgetState extends State<DashboardWidget>
    with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _controller;
  String token = '';
  List<Data> tipsList = new List();
  bool isLoading = true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'DASHBOARD',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.notifications), onPressed: () {})
        // ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: Color(0xFF36497B),
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Hello,',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${widget?.data?.user?.firstName ?? ''} ${widget?.data?.user?.lastName ?? ''}'
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                new DashBoardItem(
                  title: 'SCHOOLS',
                  desc:
                      'Find affordable colleges & unversities in USA, Canada, UK etc & tips on how to apply',
                  callbackClass: FindSchool(data: widget.data),
                ),
                new DashBoardItem(
                  title: 'SCHOLARSHIPS',
                  desc:
                      'Explore several scholarships available for undergraduate, postgraduate & PhD students',
                  callbackClass: ScholarshipListing(
                    data: widget.data,
                  ),
                ),
                new DashBoardItem(
                  title: 'HELPFUL TIPS & EXPERIENCES',
                  desc:
                      'Read experiences and helpful tips that\'ll guide you during your application process',
                  callbackClass: StoriesListing(
                    data: widget.data,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                ),
                Container(
                  height: 160,
                  color: Color(0xFF36497B),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        color: MyColors.blue,
                        width: double.infinity,
                        child: Text(
                          'Helpful Tips',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                          child: !isLoading
                              ? SizedBox(
                                  height: double.infinity,
                                  child: TabBarView(
                                    controller: _controller,
                                    children: tipsList
                                        .map((tipsList) =>
                                            _buildSliders(context))
                                        .toList(),
                                  ),
                                )
                              : SpinKitFadingCircle(
                                  color: Colors.white,
                                  size: 50.0,
                                ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(data: widget.data),
    );
  }

  Widget _buildSliders(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2, top: 13),
        child: Swiper(
            autoplay: true,
            autoplayDelay: 5100,
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      tipsList[i].adviceBody,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey[100], fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 0.5,
                        color: Colors.grey)
                  ],
                ),
              );
            },
            itemCount: tipsList.length,
            itemWidth: screenWidth,
            pagination: new SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                    activeColor: Colors.white,
                    color: Colors.grey,
                    size: 5,
                    activeSize: 7))),
      ),
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
        var firstResponse = await AdviceBackend.get(token);

        await Future.delayed(const Duration(seconds: 1));

        Map dataMap = jsonDecode(firstResponse);
        var data = AdviceModel.fromJson(dataMap);

        // print(data.data[0].t                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    oJson());
        if (firstResponse != null) {
          setState(() {
            isLoading = false;
            //_controller = new TabController(length: tipsList.length, vsync: this);
            tipsList = data.data;
            _controller = TabController(
                length: tipsList != null ? tipsList.length : 0, vsync: this);
          });
        } else {
          loadData();
        }
      } catch (e) {
        // Handle error...
      }
    }
  }
}

class DashBoardItem extends StatelessWidget {
  final String title, desc;
  final Widget callbackClass;

  const DashBoardItem({
    Key key,
    this.title,
    this.desc,
    this.callbackClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      child: Container(
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
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        child: InkWell(
          onTap: () {
            if (callbackClass != null)
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => callbackClass));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        title ?? '',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black87.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        desc ?? '',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Color(0xFF36497B).withOpacity(0.8),
                    height: 7,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
