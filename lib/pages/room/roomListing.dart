import 'dart:convert';

import 'package:college_situation/common/constants.dart';
import 'package:college_situation/models/newUserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/api/listingBackend.dart';
import 'package:college_situation/dashboard/drawer_widget.dart';
import 'package:college_situation/models/listingModel.dart';
import 'package:college_situation/pages/room/listingDetails.dart';
import 'package:college_situation/common/widgets/roundedButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomListing extends StatefulWidget {
  final UserModel data;

  const RoomListing({Key key,@required this.data}) : super(key: key);
  @override
  _RoomListingState createState() => _RoomListingState();
}

class _RoomListingState extends State<RoomListing> {
  TextEditingController textController = TextEditingController();
  String searchWord = '';
  bool notNull(Object o) => o != null;
  bool isLoading = true;
  List<ListingData> listingData = [];
  String firstResponse;
  Map dataMap;
  ListingModel data;
  String sortStyle;
  String token;

  @override
  void initState() {
    getListing();
    super.initState();
  }

  void setSort(String syntax) {
    setState(() {
      print('hhdggs $syntax');
      sortStyle = syntax;
      listingData.sort((a, b) {
        return syntax == 'Newest'
            ? b.dateOfCreation.compareTo(a.dateOfCreation)
            : syntax == 'Bedrooms'
                ? int.parse(a.bedrooms).compareTo(int.parse(b.bedrooms))
                : syntax == 'Bathrooms'
                    ? int.parse(a.bathrooms).compareTo(int.parse(b.bathrooms))
                    : syntax == 'Price'
                        ? int.parse(a.price.replaceRange(0, 1, '')).compareTo(
                            int.parse(b.price.replaceRange(0, 1, '')))
                        : syntax == 'Size'
                            ? int.parse(a.size).compareTo(int.parse(b.size))
                            : syntax == 'State'
                                ? b.state.compareTo(a.state)
                                : syntax == 'City'
                                    ? b.city.compareTo(a.city)
                                    : b.dateOfCreation
                                        .compareTo(a.dateOfCreation);
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
        firstResponse = await ListingBackend.get(token);
      } catch (e) {
        print(e.message);
      } finally {
        if (firstResponse != null) {
          setState(() {
            dataMap = jsonDecode(firstResponse);
            data = ListingModel.fromJson(dataMap);
            listingData = data.data.reversed.toList();
            isLoading = false;
          });
        }
      }
    }
  }

  Widget listingWidget(List<ListingData> allListingData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    allListingData.length > 1
                        ? '${allListingData.length} results'
                        : '${allListingData.length} result',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          SortModal(this.setSort, this.sortStyle),
                    );
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.filter_list,
                            size: 18,
                          ),
                        ),
                        Text(
                          ' Sort',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[400],
          ),
          Flexible(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int i) => Divider(
                color: Colors.grey[400],
              ),
              itemCount: allListingData.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ListingDetails(
                            id: allListingData[i].sId,
                          ))),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: (allListingData[i].photos.length > 0)
                              ? new ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        allListingData[i].photos.elementAt(0),
                                    placeholder:
                                        (BuildContext context, String val) {
                                      return Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                        ),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    },
                                    errorWidget: (BuildContext context,
                                        String e, Object o) {
                                      return Image.asset(
                                        'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                        height: 90,
                                        width: 90,
                                      );
                                    },
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
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
                                    height: 90,
                                    width: 90,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    (int.parse(allListingData[i].bathrooms) >
                                                1 &&
                                            int.parse(allListingData[i]
                                                    .bedrooms) >
                                                1)
                                        ? '${allListingData[i].bedrooms} Bedrooms, ${allListingData[i].bathrooms} Bathrooms for Rent'
                                        : (int.parse(allListingData[i]
                                                    .bedrooms) >
                                                1)
                                            ? '${allListingData[i].bedrooms} Bedrooms, ${allListingData[i].bathrooms} Bathroom for Rent'
                                            : (int.parse(allListingData[i]
                                                        .bathrooms) >
                                                    1)
                                                ? '${allListingData[i].bedrooms} Bedroom, ${allListingData[i].bathrooms} Bathrooms for Rent'
                                                : '${allListingData[i].bedrooms} Bedroom, ${allListingData[i].bathrooms} Bathroom for Rent',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.blue,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: Colors.grey[500],
                                      ),
                                      Text(
                                        ' ${allListingData[i].city}, ${allListingData[i].state}',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          '\$${allListingData[i].price}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    '${allListingData[i].bedrooms} ',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Icon(
                                                    FontAwesomeIcons.bed,
                                                    size: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    '${allListingData[i].bathrooms} ',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Icon(
                                                    FontAwesomeIcons.shower,
                                                    size: 14,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  builResultWidget() {
    if (searchWord.length > 0) {
      List<ListingData> tempList = List();
      for (int i = 0; i < listingData.length; i++) {
        String altTitle =
            '${listingData[i].bedrooms} Bedroom, ${listingData[i].bathrooms} Bathroom for Rent';
        String title =
            '${listingData[i].bedrooms} Bedrooms, ${listingData[i].bathrooms} Bathrooms for Rent';
        if (title.toLowerCase().contains(searchWord.toLowerCase()) ||
            altTitle.toLowerCase().contains(searchWord.toLowerCase()) ||
            listingData[i]
                .address
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            listingData[i]
                .price
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            listingData[i]
                .city
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            listingData[i]
                .state
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            listingData[i]
                .zip
                .toLowerCase()
                .contains(searchWord.toLowerCase())) {
          tempList.add(listingData[i]);
        }
      }
      return listingWidget(tempList);
    } else {
      return listingWidget(listingData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(data:widget.data ,),
      appBar: AppBar(
        title: Container(
          child: Row(
            children: <Widget>[
              Flexible(
                child: new Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
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
                                contentPadding: EdgeInsets.only(bottom: 0),
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
            ],
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
          : builResultWidget(),
    );
  }
}

class SortModal extends StatefulWidget {
  final Function setSort;
  final String ss;
  SortModal(this.setSort, this.ss);
  @override
  _SortModalState createState() => _SortModalState();
}

class _SortModalState extends State<SortModal> {
  List<String> sortBy = [
    'Newest',
    'Bedrooms',
    'Bathrooms',
    'Price',
    'Size',
    'State',
    'City'
  ];
  String selectedSort;

  @override
  void initState() {
    setState(() {
      selectedSort = this.widget.ss ?? 'Newest';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Container(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      content: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Sort by',
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
              height: 300,
              width: 300,
              margin: EdgeInsets.only(top: 30),
              child: ListView.builder(
                itemCount: sortBy.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedSort = sortBy[i];
                      });
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Text(
                              sortBy[i],
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: selectedSort == sortBy[i]
                                  ? MyColors.availableGreen
                                  : Colors.grey[500],
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
                buttonName: "Apply",
                onTap: () {
                  Navigator.of(context).pop();
                  this.widget.setSort(selectedSort);
                },
                width: 200.0,
                height: 40.0,
                bottomMargin: 10.0,
                borderWidth: 0.0,
                buttonColor: MyColors.availableGreen,
              ),
            )
          ],
        ),
      ),
    );
  }
}
