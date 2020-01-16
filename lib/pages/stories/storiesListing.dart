import 'dart:convert';

import 'package:college_situation/common/constants.dart';
import 'package:college_situation/common/functions.dart';
import 'package:college_situation/dashboard/dashboard_widget.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/api/storiesBackend.dart';
import 'package:college_situation/common/widgets/cusom_app_bar.dart';
import 'package:college_situation/models/storiesModel.dart';
import 'package:college_situation/models/storiesCatModel.dart';
import 'package:college_situation/common/widgets/roundedButton.dart';
import 'package:college_situation/pages/stories/storyDetails.dart';
import 'package:college_situation/pages/stories/storyCreation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoriesListing extends StatefulWidget {
  final UserModel data;

  const StoriesListing({Key key, @required this.data}) : super(key: key);
  @override
  _StoriesListingState createState() => _StoriesListingState();
}

class _StoriesListingState extends State<StoriesListing> {
  TextEditingController textController = TextEditingController();
  String searchWord = '';
  bool notNull(Object o) => o != null;
  bool isLoading = true;
  bool showSearchField = false;
  List<StoryCatData> storyCatData = [];
  List<StoriesData> storiesData = [];
  List<String> catList = [];
  String firstResponse;
  String secondResponse;
  String token;
  Map catDataMap;
  Map dataMap;
  StoriesModel data;
  StoriesCatModel catData;
  String sortCat;
  String sortStyle;
  String currentSearch;
  double totalScollWidth = 0.0;
  double scrollIndPos = 0.0;
  List<Color> colors = [
    Color(0xFF8e44ad),
    Color(0xFFe67e22),
    Color(0xFF2c3e50),
    Color(0xFF1abc9c),
    Color(0xFF2980b9),
    Color(0xFF8c7ae6),
    Color(0xFF192a56),
  ];
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    getRequirements();
    super.initState();
  }

  _listener() {
    setState(() {
      scrollIndPos = (_scrollController.offset / totalScollWidth) * 128;
    });
  }

  void setSort(String syntax, String state, String selectedCat) {
    setState(() {
      if (selectedCat != null) {
        textController.text = selectedCat;
        searchWord = selectedCat;
      } else {
        textController.text = '';
        searchWord = '';
      }
      sortStyle = syntax;
      sortCat = selectedCat;
      storiesData.sort((a, b) {
        return syntax == 'Newest'
            ? b.dateOfCreation.compareTo(a.dateOfCreation)
            : a.dateOfCreation.compareTo(b.dateOfCreation);
      });
    });
  }

  getRequirements() async {
    var prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {} finally {
      setState(() {
        token = prefs.getString(Constants.token);
      });
      try {
        firstResponse = await StoriesBackend.get(token);
      } catch (e) {
        print(e.message);
      } finally {
        try {
          secondResponse = await StoriesBackend.getStoriesCat(token);
        } catch (e) {
          print(e.message);
        } finally {
          if (firstResponse != null && secondResponse != null) {
            setState(() {
              catDataMap = jsonDecode(secondResponse);
              catData = StoriesCatModel.fromJson(catDataMap);
              storyCatData = catData.data;
              for (int i = 0; i < storyCatData.length; i++) {
                catList.add(storyCatData[i].name);
              }
              totalScollWidth = storyCatData.length * 108.0;
              dataMap = jsonDecode(firstResponse);
              data = StoriesModel.fromJson(dataMap);
              storiesData = data.data.reversed.toList();
              isLoading = false;
            });
          }
        }
      }
    }
  }

  Widget listingWidget(List<StoriesData> storiesData) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                padding: EdgeInsets.only(
                  left: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.grey[500],
                    )),
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
            /*  searchWord.length < 1
                ? Container(
                    height: 200,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: storyCatData.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          height: 200,
                          width: 160,
                          margin: EdgeInsets.only(right: 14),
                          child: Center(
                            child: Text(
                              storyCatData[i].name.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: colors[i],
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  colors[i].withAlpha(255),
                                  colors[i].withAlpha(220),
                                  colors[i].withAlpha(200),
                                ]),
                          ),
                        );
                      },
                    ),
                  )
                : null,
            searchWord.length < 1
                ? Container(
                    margin: EdgeInsets.only(top: 20, bottom: 40),
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1.9),
                    height: 5,
                    width: 150,
                    alignment: Alignment.centerLeft,
                    // child: Container(
                    //   height: 10,
                    //   width: 10,
                    //   margin: EdgeInsets.only(left: scrollIndPos),
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey[700],
                    //     shape: BoxShape.circle,
                    //   ),
                    // ),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                  )
                : null, */
            Container(
              margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                ),
                itemCount: storiesData.length,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => StoryDetails(
                          id: storiesData[i].sId,
                          ownerId: storiesData[i].owner.sId
                        ),
                      ),
                    ),
                    child: Card(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: storiesData[i].photo != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8)),
                                      child: CachedNetworkImage(
                                        height: 120,
                                        width: 300,
                                        fit: BoxFit.cover,
                                        imageUrl: storiesData[i].photo,
                                        placeholder:
                                            (BuildContext context, String val) {
                                          return Container(
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 10,),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.access_time,
                                              color: MyColors.blue,
                                              size: 14,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              '${Functions().timeAgo(DateTime.parse(storiesData[i].dateOfCreation))}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      height: 23,
                                      child: Text(
                                        storiesData[i].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        storiesData[i].category.name,
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
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    FontAwesomeIcons.commentAlt,
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
                                            padding: EdgeInsets.all(7),
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
    );
  }

  buildResultWidget() {
    if (searchWord.length > 0) {
      List<StoriesData> tempList = List();
      for (int i = 0; i < storiesData.length; i++) {
        if (storiesData[i]
                .title
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            storiesData[i]
                .category
                .name
                .toLowerCase()
                .contains(searchWord.toLowerCase())) {
          tempList.add(storiesData[i]);
        }
      }
      return listingWidget(tempList);
    } else {
      return listingWidget(storiesData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: MyColors.blue,
          child: Icon(
            Icons.add,
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => StoryCreation(
                data: widget.data,
              ),
            ),
          ),
          elevation: 10,
        ),
      ),
      drawer: DashboardWidget(data: widget.data),
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Text(
            'EXPERIENCES',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SortModal(
                      this.setSort, this.sortStyle, this.sortCat, this.catList),
                  fullscreenDialog: true,
                ),
              ),
            ),
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
          : buildResultWidget(),
    );
  }
}

class SortModal extends StatefulWidget {
  final Function setSort;
  final String ss;
  final List<String> catList;
  final String sortCat;
  SortModal(this.setSort, this.ss, this.sortCat, this.catList);
  @override
  _SortModalState createState() => _SortModalState();
}

class _SortModalState extends State<SortModal> {
  List<String> sortBy = [
    'Newest',
    'Oldest',
  ];
  String selectedSort;
  String state;
  String selectedCat;

  @override
  void initState() {
    setState(() {
      selectedSort = this.widget.ss ?? '';
      selectedCat = this.widget.sortCat;
    });
    super.initState();
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
                  'CATEGORY',
                  style: TextStyle(
                    color: MyColors.blue,
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(bottom: 20),
                child: new DropdownButtonFormField<String>(
                  onChanged: (String val) {
                    setState(() {
                      selectedCat = val;
                    });
                  },
                  onSaved: (String val) {
                    selectedCat = val;
                  },
                  value: selectedCat,
                  items: this.widget.catList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value.toString()),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Category',
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
                  'DATE OF CREATION',
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
                    this.widget.setSort(selectedSort, state, selectedCat);
                  },
                  width: 200.0,
                  height: 40.0,
                  bottomMargin: 10.0,
                  borderWidth: 0.0,
                  buttonColor: MyColors.blue,
                ),
              ),
              Center(
                child: new RoundedButton(
                  buttonName: "CLEAR FILTER",
                  onTap: () {
                    Navigator.of(context).pop();
                    this.widget.setSort('', '', null);
                  },
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
    );
  }
}
