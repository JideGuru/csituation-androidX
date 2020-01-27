import 'dart:convert';

import 'package:college_situation/common/constants.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/api/scholarshipBackend.dart';
import 'package:college_situation/common/widgets/cusom_app_bar.dart';
import 'package:college_situation/dashboard/drawer_widget.dart';
import 'package:college_situation/models/scholarshipModel.dart';
import 'package:college_situation/common/widgets/roundedButton.dart';
import 'package:college_situation/pages/scholarships/scholarshipDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:college_situation/common/my_strings.dart';

var baseUrl = Strings.imageDomain;

class ScholarshipListing extends StatefulWidget {
  final UserModel data;

  const ScholarshipListing({Key key, @required this.data}) : super(key: key);
  @override
  _ScholarshipListingState createState() => _ScholarshipListingState();
}

class _ScholarshipListingState extends State<ScholarshipListing> {
  TextEditingController textController = TextEditingController();
  String searchWord = '';
  bool notNull(Object o) => o != null;
  bool isLoading = true;
  bool showSearchField = false;
  List<ScholarshipData> scholarshipData = [];
  String firstResponse;
  Map dataMap;
  ScholarshipModel data;
  String sortStyle;
  String token;
  String currentSearch;
  List<ScholarshipData> featuredContents = [];

  @override
  void initState() {
    getListing();
    super.initState();
  }

  void setSort(String syntax, String state) {
    setState(() {
      if (state != null) {
        textController.text = state;
        searchWord = state;
      }
      sortStyle = syntax;
      currentSearch = state;
      scholarshipData.sort((a, b) {
        return syntax == 'College - Undergraduate'
            ? b.educationalLevel.compareTo(a.educationalLevel)
            : a.educationalLevel.compareTo(b.educationalLevel);
      });
    });
  }

  getListing() async {
    var prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {} finally {
      setState(() {
        token = prefs.getString(Constants.token);
      });
      try {
        firstResponse = await ScholarshipBackend.get(token);
      } catch (e) {
        print(e.message);
      } finally {
        if (firstResponse != null) {
          setState(() {
            dataMap = jsonDecode(firstResponse);
            data = ScholarshipModel.fromJson(dataMap);
            scholarshipData = data.data.reversed.toList();
            for (int i = 0; i < scholarshipData.length; i++) {
              if (scholarshipData[i].featured == 'yes') {
                featuredContents.add(scholarshipData[i]);
              }
            }
            isLoading = false;
          });
        }
      }
    }
  }

  Widget listingWidget(List<ScholarshipData> allScholarshipData) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          showSearchField
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: MyColors.blue,
                  ),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: new Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 5,
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.grey[400],
                                      size: 18,
                                    ),
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: textController,
                                      autofocus: true,
                                      onChanged: (String value) {
                                        setState(() {
                                          searchWord = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Search...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  textController.text.length > 0
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.grey[400],
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                textController.clear();
                                                searchWord = '';
                                              });
                                            },
                                          ),
                                        )
                                      : null,
                                ].where(notNull).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.sort,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => SortModal(
                                  this.setSort,
                                  this.sortStyle,
                                  this.currentSearch),
                              fullscreenDialog: true,
                            ),
                          ),
                        ),
                      ),
                    ].where(notNull).toList(),
                  ),
                )
              : null,
          Flexible(
            child: ListView(
              children: <Widget>[
                searchWord.length < 1
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.29,
                        width: screenWidth,
                        child: Swiper(
                          autoplay: true,
                          itemBuilder: (BuildContext context, int i) {
                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ScholarshipDetails(
                                          id: featuredContents[i].sId,
                                        )),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 350,
                                    child: Image(
                                      image: AssetImage(
                                        'assets/images/schlisting.png',
                                      ),
                                      height: 350,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: screenWidth,
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
                                  Positioned(
                                    bottom: 20,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(bottom: 12),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    Icons.access_time,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                                Text(
                                                  'DUE: ${featuredContents[i].dueDate}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 12),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.80,
                                            child: Text(
                                              featuredContents[i].title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 12),
                                            child: Text(
                                              '${featuredContents[i].amount}.00',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .commentAlt,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        'No comments',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(
                                                      right: 40),
                                                  child: RotationTransition(
                                                    turns:
                                                        AlwaysStoppedAnimation(
                                                            45 / 360),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .thumbtack,
                                                      color: Colors.grey[400],
                                                      size: 14,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: featuredContents.length,
                          itemWidth: screenWidth,
                          containerHeight: 350,
                          pagination: new SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                                activeColor: Colors.white,
                                color: Colors.grey,
                                size: 5,
                                activeSize: 7),
                          ),
                        ),
                      )
                    : null,
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: allScholarshipData.length,
                    itemBuilder: (BuildContext context, int i) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ScholarshipDetails(
                                    id: allScholarshipData[i].sId,
                                  )),
                        ),
                        child: Card(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.29,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: allScholarshipData[i].photo != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8)),
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: 200,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                'https://res.cloudinary.com/favourori/image/upload/v1580111197/schlisting.png',
                                            placeholder: (BuildContext context,
                                                String val) {
                                              return Container(
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                ),
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            },
                                            // errorWidget: (BuildContext context,
                                            //     String val, Exception e) {
                                            //   return Image.asset(
                                            //     'assets/images/placeholder.png',
                                            //     fit: BoxFit.cover,
                                            //   );
                                            // },
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8)),
                                          child: Container(
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
                                            height: 100,
                                            width: 300,
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 6),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                child: Icon(
                                                  Icons.access_time,
                                                  color: MyColors.blue,
                                                  size: 14,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'DUE: ${allScholarshipData[i].dueDate}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 7, top: 3),
                                          height: 29,
                                          child: Text(
                                            allScholarshipData[i].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 3),
                                          child: Text(
                                            allScholarshipData[i].amount,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .commentAlt,
                                                        color: MyColors.blue,
                                                        size: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      'No comments',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: RotationTransition(
                                                  turns: AlwaysStoppedAnimation(
                                                      45 / 360),
                                                  child: Icon(
                                                    FontAwesomeIcons.thumbtack,
                                                    color: Colors.grey[400],
                                                    size: 14,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey[100]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                  ),
                ),
              ].where(notNull).toList(),
            ),
          ),
        ].where(notNull).toList(),
      ),
    );
  }

  builResultWidget() {
    if (searchWord.length > 0) {
      List<ScholarshipData> tempList = List();
      for (int i = 0; i < scholarshipData.length; i++) {
        if (scholarshipData[i]
                .title
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            scholarshipData[i]
                .state
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            scholarshipData[i]
                .amount
                .toLowerCase()
                .contains(searchWord.toLowerCase())) {
          tempList.add(scholarshipData[i]);
        }
      }
      return listingWidget(tempList);
    } else {
      return listingWidget(scholarshipData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(
        data: widget.data,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Text(
            'SCHOLARSHIPS',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () => setState(
                () => showSearchField = showSearchField ? false : true),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: MyColors.blue,
                size: 50.0,
              ),
            )
          : builResultWidget(),
    );
  }
}

class SortModal extends StatefulWidget {
  final Function setSort;
  final String ss;
  final String currentSearch;
  SortModal(this.setSort, this.ss, this.currentSearch);
  @override
  _SortModalState createState() => _SortModalState();
}

class _SortModalState extends State<SortModal> {
  List<String> sortBy = [
    'College - Undergraduate',
    'College - Graduate',
  ];
  String selectedSort;
  String state;
  TextEditingController _textC = TextEditingController();

  @override
  void initState() {
    setState(() {
      selectedSort = this.widget.ss ?? '';
      _textC.text = this.widget.currentSearch;
    });
    super.initState();
  }

  @override
  void dispose() {
    _textC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        iconTheme:
            Theme.of(context).iconTheme.copyWith(color: Colors.grey[800]),
        actions: <Widget>[
          IconButton(
              iconSize: 30,
              padding: EdgeInsets.all(20),
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 10),
                child: Text(
                  'FILTERS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey[400],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'STATE OF RESIDENCE',
                  style: TextStyle(
                    color: MyColors.blue,
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextField(
                  onChanged: (String value) {
                    setState(() {
                      state = value;
                    });
                  },
                  controller: _textC,
                  decoration: InputDecoration(
                    hintText: 'Enter state',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
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
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'EDUCATIONAL LEVEL',
                  style: TextStyle(
                    color: MyColors.blue,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 40),
                child: ListView.builder(
                  itemCount: sortBy.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int i) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedSort = sortBy[i];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                sortBy[i],
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]),
                                color: selectedSort == sortBy[i]
                                    ? MyColors.blue
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: new RoundedButton(
                  buttonName: "APPLY FILTER",
                  onTap: () {
                    Navigator.of(context).pop();
                    this.widget.setSort(selectedSort, state);
                  },
                  width: 200.0,
                  height: 40.0,
                  bottomMargin: 10.0,
                  borderWidth: 0.0,
                  buttonColor: MyColors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
