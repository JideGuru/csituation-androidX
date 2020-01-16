
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/models/findSchoolModel.dart';
import 'package:college_situation/pages/search.dart';

class FindSchoolWidget extends StatefulWidget {
  final SchoolData schoolData;

  const FindSchoolWidget({
    Key key,
    @required this.schoolData,
  }) : super(key: key);

  _FindSchoolWidgetState createState() =>
      _FindSchoolWidgetState(schoolData: schoolData);
}

class _FindSchoolWidgetState extends State<FindSchoolWidget> {
  final SchoolData schoolData;
  _FindSchoolWidgetState({this.schoolData});

  var _loadImage = new AssetImage('assets/images/placeholder.png');
  var _myImage; 
  bool _checkLoaded = true;

  @override
  void initState() {
    super.initState();
    _myImage = new NetworkImage('${widget.schoolData.photo}');
    _myImage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        appBar: AppBar(
            actions: _appBarActions(),
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
                ])),
        body: Center(
          child: ListView(
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  new Container(
                    height: 450,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: _checkLoaded ? _loadImage : _myImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  new Positioned.fill(
                    top: 380,
                    child: Container(
                      height: 70,
                      color: Colors.grey[600],
                    ),
                  ),
                  new Positioned.fill(
                    top: 200,
                    child: Container(
                      height: 290,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  new Positioned.fill(
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
                                _buildItem(
                                    '${schoolData.avgACT}', 'Average ACT'),
                                SizedBox(height: 5),
                                _buildItem(
                                    '${schoolData.avgTuitionInternational}',
                                    'International Tuition'),
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
                                _buildItem(
                                    '${schoolData.avgSAT}', 'Average SAT'),
                                SizedBox(height: 5),
                                _buildItem('${schoolData.avgTuitionLocal}',
                                    'Local Tuition'),
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
                      )),
                ],
              ),
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
               */Divider(height: 2, color: Colors.grey),
              Column(children: _buildExpandedList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(number, item) {
    return new Column(
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
    return new Column(
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
          '${schoolData.desc}'),
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
          '${schoolData.fastFacts}'),
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
          'Coming Soon'),
      _buildExpanded(
          Icon(
            Icons.calendar_today,
            color: MyColors.green,
            size: 25,
          ),
          'Academic Calendar',
          'Coming Soon'),
    ];
  }

  _appBarActions() {
    return <Widget>[
      new IconButton(
        icon: new Icon(Icons.search),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Search())),
      )
    ];
  }

  Widget _buildExpanded(Icon icon, title, body) {
    return Container(
      color: Colors.grey[50].withOpacity(0.6),
      child: Column(
        children: <Widget>[
          ExpandablePanel(
            header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
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
            hasIcon: true,
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
            header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
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
            hasIcon: true,
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
            header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
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
                      '${schoolData.avgTuitionInternational}', false),
                  _buildItems(
                      'Application Fee', '${schoolData.applicationFee}', true),
                  _buildLocal(),
                  _buildItems(
                      'Tutition', '${schoolData.avgTuitionLocal}', false),
                  _buildItems(
                      'Application Fee', '${schoolData.applicationFee}', false),
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
            header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: icon,
                  title: Text('$title'),
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
            hasIcon: true,
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
