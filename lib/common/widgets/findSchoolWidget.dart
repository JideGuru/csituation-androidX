import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/models/findSchoolModel.dart';

class FindSchoolWidget extends StatefulWidget {
  final SchoolData schoolData;
  final bool fromSearch;

  const FindSchoolWidget({
    Key key,
    @required this.schoolData,
    this.fromSearch,
  }) : super(key: key);

  _FindSchoolWidgetState createState() =>
      _FindSchoolWidgetState(schoolData: schoolData, fromSearch: fromSearch);
}

class _FindSchoolWidgetState extends State<FindSchoolWidget> {
  final SchoolData schoolData;
  final bool fromSearch;
  _FindSchoolWidgetState({this.schoolData, this.fromSearch});
  
  double _headerSize = 450;
  double _offset = 0.0;
  double highlightPosition = 0.0;
  ScrollController _scrollController;
  bool isFromSearch = false;
  bool buildLinks = false;
  bool buildMap = false;
  bool buildFincancial = false;
  List<bool> buildExpandedStatus = [false, false, false, false];

  @override
  void initState() {
    isFromSearch = fromSearch;
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: isFromSearch
          ? Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                centerTitle: false,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${schoolData.name}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('${schoolData.city}, ${schoolData.state}',
                        style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              body: scaffoldBody(),
            )
          : Scaffold(
              body: scaffoldBody(),
            ),
    );
  }

  Widget scaffoldBody() {
    highlightPosition = (_offset >= 0.0 ? -_offset : 0.0);
    return Stack(
      children: <Widget>[
        SizedBox(
          child: ClipRect(
            clipper: HeaderClipper(_headerSize - _offset),
            child: Container(
              child: CachedNetworkImage(
                imageUrl: widget.schoolData.photo,
                placeholder: (BuildContext context, String val) {
                  return Container(
                    child: Image.asset(
                      "assets/images/placeholder.png",
                      fit: BoxFit.cover,
                    ),
                  );
                },
                errorWidget: (BuildContext context, String val, Object o) {
                  return Container(
                    child: Image.asset(
                      "assets/images/placeholder.png",
                      fit: BoxFit.cover,
                    ),
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
          height: _scrollController.hasClients &&
                  _scrollController.position.extentAfter == 0.0
              ? _headerSize
              : _offset <= _headerSize ? _headerSize - _offset : 0.0,
          width: MediaQuery.of(context).size.width,
        ),
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              setState(() {
                _offset = notification.metrics.pixels;
              });
            }
            return;
          },
          child: ListView(
            controller: _scrollController,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    height: _headerSize,
                  ),
                  Positioned.fill(
                    top: 380,
                    child: Container(
                      height: 70,
                      color: Colors.grey[600],
                    ),
                  ),
                  Positioned.fill(
                    top: 200,
                    child: Container(
                      height: 290,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Positioned.fill(
                    top: 200,
                    child: Container(
                      height: 480,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildItem(
                                  '${schoolData.population}', 'Population'),
                              SizedBox(height: 5),
                              _buildItem('${schoolData.avgACT}', 'Average ACT'),
                              SizedBox(height: 5),
                              _buildItem(
                                  '${schoolData.avgTuitionInternational}',
                                  'Out-of-state Tuition'),
                              SizedBox(height: 5),
                              _buildIcons(
                                  Icon(
                                    Icons.home,
                                    color: Colors.yellow,
                                    size: 29,
                                  ),
                                  'College',
                                  Colors.white)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildItem('${schoolData.acceptanceRate}',
                                  'Acceptance Rate'),
                              SizedBox(height: 5),
                              _buildItem('${schoolData.avgSAT}', 'Average SAT'),
                              SizedBox(height: 5),
                              _buildItem('${schoolData.avgTuitionLocal}',
                                  'In-state Tuition'),
                              SizedBox(height: 5),
                              _buildIcons(
                                  Icon(
                                    Icons.place,
                                    color: Colors.yellow,
                                    size: 29,
                                  ),
                                  'Town',
                                  Colors.white)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildItem('${schoolData.graduationRate}',
                                  'Graduation Rate'),
                              SizedBox(height: 5),
                              _buildItem('${schoolData.type}', 'Type'),
                              SizedBox(height: 5),
                              _buildItem('${schoolData.zip}', 'Zip'),
                              SizedBox(height: 5),
                              _buildIcons(
                                  Icon(
                                    Icons.security,
                                    color: Colors.yellow,
                                    size: 29,
                                  ),
                                  '${schoolData.category}',
                                  Colors.white)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Column(
                  children: <Widget>[
                   /*  Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.symmetric(vertical: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildIcons(
                                Icon(
                                  Icons.sort,
                                  color: MyColors.blue,
                                  size: 29,
                                ),
                                'Sort',
                                Colors.black),
                            _buildIcons(
                                Icon(
                                  Icons.adjust,
                                  color: MyColors.blue,
                                  size: 29,
                                ),
                                'Organize',
                                Colors.black),
                            _buildIcons(
                                Icon(
                                  Icons.add_to_queue,
                                  color: MyColors.blue,
                                  size: 29,
                                ),
                                'Compare',
                                Colors.black),
                            _buildIcons(
                                Icon(
                                  Icons.favorite_border,
                                  color: MyColors.blue,
                                  size: 29,
                                ),
                                'Add Favourite',
                                Colors.black)
                          ],
                        )),
                    */ Divider(height: 2, color: Colors.grey),
                    Column(
                      children: _buildExpandedList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox.shrink(),
      ],
    );
  }

  Widget _buildItem(number, item) {
    return Column(
      children: <Widget>[
        Text(
          '$number',
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        Text('$item', style: TextStyle(color: Colors.white, fontSize: 11.3))
      ],
    );
  }

  Widget _buildIcons(Widget icons, String item, Color textColor) {
    return Column(
      children: <Widget>[
        icons,
        SizedBox(
          height: 5,
        ),
        Text('$item', style: TextStyle(color: textColor, fontSize: 12))
      ],
    );
  }

  _buildExpandedList() {
    return <Widget>[
      _buildExpanded(
        Icon(
          Icons.info_outline,
          color: MyColors.green,
          size: 25,
        ),
        'About',
        '${schoolData.desc}',
        0,
      ),
      _buildMap(
        Icon(
          Icons.location_on,
          color: MyColors.green,
          size: 25,
        ),
        'Location',
      ),
      _buildExpanded(
        Icon(
          Icons.info,
          color: MyColors.green,
          size: 25,
        ),
        'Fast Facts',
        '${schoolData.fastFacts}',
        1,
      ),
      _buildLinks(
        Icon(
          Icons.link,
          color: MyColors.green,
          size: 25,
        ),
        'Links & Addresses',
      ),
      _buildFinancial(
        Icon(
          Icons.attach_money,
          color: MyColors.green,
          size: 25,
        ),
        'Tuition & Fees',
      ),
      _buildExpanded(
        Icon(
          Icons.cloud,
          color: MyColors.green,
          size: 25,
        ),
        'Weather',
        'Coming Soon',
        2,
      ),
      _buildExpanded(
        Icon(
          Icons.calendar_today,
          color: MyColors.green,
          size: 25,
        ),
        'Academic Calendar',
        'Coming Soon',
        3,
      ),
    ];
  }

  Widget _buildExpanded(Icon icon, title, body, int index) {
    return Container(
      color: Colors.grey[50].withOpacity(0.6),
      child: Column(
        children: <Widget>[
          ExpandablePanel(
            initialExpanded: buildExpandedStatus[index],
            hasIcon: false,
            header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      buildExpandedStatus[index] =
                          (buildExpandedStatus[index]) ? false : true;
                    });
                  },
                  trailing: Icon(
                    buildExpandedStatus[index]
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.black54,
                    size: 26,
                  ),
                  leading: icon,
                  title: Text('$title'),
                )),
            expanded: Container(
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$body',
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            tapHeaderToExpand: true,
          ),
          Divider(height: 2, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMap(Icon icon, title) {
    return Container(
      color: Colors.grey[50].withOpacity(0.6),
      child: Column(
        children: <Widget>[
          ExpandablePanel(
            initialExpanded: buildMap,
            hasIcon: false,
            header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      buildMap = buildMap ? false : true;
                    });
                  },
                  trailing: Icon(
                    buildMap ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black54,
                    size: 26,
                  ),
                  leading: icon,
                  title: Text('$title'),
                )),
            expanded: Container(
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('${schoolData.city}, ${schoolData.state}'),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 58,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _buildNull(
                                  'More about ${schoolData.city}, ${schoolData.state}',
                                  '${schoolData.aboutLocation}'),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            tapHeaderToExpand: true,
          ),
          Divider(height: 2, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildFinancial(Icon icon, title) {
    return Container(
      color: Colors.grey[50].withOpacity(0.6),
      child: Column(
        children: <Widget>[
          ExpandablePanel(
            initialExpanded: buildFincancial,
            hasIcon: false,
            header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      buildFincancial = buildFincancial ? false : true;
                    });
                  },
                  trailing: Icon(
                    buildFincancial ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black54,
                    size: 26,
                  ),
                  leading: icon,
                  title: Text('$title'),
                )),
            expanded: Container(
              color: Colors.white,
              height: 500,
              child: Column(
                children: [
                  _buildInt(),
                  _buildItems('Tutition',
                      '${schoolData.avgTuitionInternational??0}', false),
                  _buildItems(
                      'Application Fee', '${schoolData.applicationFee ?? 0}', true),
                  _buildLocal(),
                  _buildItems(
                      'Tutition', '${schoolData.avgTuitionLocal??0}', false),
                  _buildItems(
                      'Application Fee', '${schoolData.applicationFee??0}', false),
                  _buildNull('View all fees', 'h')
                ],
              ),
            ),
          ),
          Divider(height: 2, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLinks(Icon icon, title) {
    return Container(
      color: Colors.grey[50].withOpacity(0.6),
      child: Column(
        children: <Widget>[
          ExpandablePanel(
            initialExpanded: buildLinks,
            hasIcon: false,
            header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: icon,
                  trailing: Icon(
                    buildLinks ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black54,
                    size: 26,
                  ),
                  title: Text('$title'),
                  onTap: () {
                    setState(() {
                      buildLinks = buildLinks ? false : true;
                    });
                  },
                )),
            expanded: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 58,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _buildNull(
                                  'Home Page', '${schoolData.website}'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 58,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _buildNull(
                                  'Admissions', '${schoolData.admissions}'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 58,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _buildNull(
                                  'Academics', '${schoolData.academics}'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 58,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _buildNull(
                                  'Courses', '${schoolData.courses}'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 58,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _buildNull(
                                  'Scholarships', '${schoolData.scholarships}'),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.place,
                          color: MyColors.blue,
                          size: 25,
                        ),
                        title: Text('${schoolData.address}'),
                      ),
                      ListTile(
                        onTap: () {
                          _launchURL(
                              "mailto:${schoolData.email}?subject=&body=");
                        },
                        leading: Icon(
                          Icons.email,
                          color: MyColors.blue,
                          size: 25,
                        ),
                        title: Text('Email'),
                        subtitle: Text('${schoolData.email}'),
                      ),
                      ListTile(
                        onTap: () {
                          _launchURL("tel://${schoolData.generalPhone}");
                        },
                        leading: Icon(
                          Icons.phone,
                          color: MyColors.blue,
                          size: 25,
                        ),
                        title: Text('General Phone'),
                        subtitle: Text('${schoolData.generalPhone}'),
                      ),
                      ListTile(
                        onTap: () {
                          _launchURL("tel://${schoolData.intlAdmissionPhone}");
                        },
                        leading: Icon(
                          Icons.phone,
                          color: MyColors.blue,
                          size: 25,
                        ),
                        title: Text('International Admission Phone'),
                        subtitle: Text('${schoolData.intlAdmissionPhone}'),
                      )
                    ],
                  )
                ],
              ),
            ),
            tapHeaderToExpand: true,
          ),
          Divider(height: 2, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildNull(title, url) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              _launchURL(url);
            },
            title: Text('$title'),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: MyColors.green,
              size: 25,
            ),
          ),
          Divider(height: 2, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildItems(title, String price, bool bold) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
              title: Text('$title'),
              trailing: Text(
                price.contains('\$') ? '$price' : '\$' '$price',
                style: TextStyle(fontSize: 20),
              )),
          Divider(
              height: bold ? 2 : 3, color: bold ? Colors.black : Colors.grey),
        ],
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (e) {
        print(e);
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  _buildLocal() {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
                leading: Text('Local',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 19))),
            Divider(height: 3, color: Colors.black),
          ],
        ));
  }

  _buildInt() {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Text('International',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
            ),
            Divider(height: 3, color: Colors.black),
          ],
        ));
  }
}

class HeaderClipper extends CustomClipper<Rect> {
  final double height;

  HeaderClipper(this.height);

  @override
  getClip(Size size) => Rect.fromLTRB(0.0, 0.0, size.width, this.height);

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
