import 'dart:convert';

import 'package:college_situation/common/constants.dart';
import 'package:college_situation/common/functions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_situation/common/my_colors.dart';
import 'package:college_situation/api/listingBackend.dart';
import 'package:college_situation/models/listingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingDetails extends StatefulWidget {
  final String id;

  const ListingDetails({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _ListingDetailsState createState() => _ListingDetailsState(id: id);
}

class _ListingDetailsState extends State<ListingDetails> {
  final String id;
  _ListingDetailsState({this.id});

  ListingData listingData;
  String firstResponse;
  Map dataMap;
  bool isLoading = true;
  int registedOn = DateTime.now().year;
  String adPostedOn;
  String token;

  @override
  void initState() {
    getListingDetails();
    super.initState();
  }

  getListingDetails() async {
    var prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {} finally {
      setState(() {
        token = prefs.getString(Constants.token);
        print("JJJJ $id");
      });
      try {
        firstResponse = await ListingBackend.getSingleListingDetails(id, token);
      } catch (e) {
        print(e.message);
      } finally {
        print("HEEEE $firstResponse");
        if (firstResponse != null) {
          setState(() {
            dataMap = jsonDecode(firstResponse);
            listingData = ListingData.fromJson(dataMap["data"]);
            isLoading = false;
            registedOn = DateTime.parse(listingData.owner.dateOfCreation).year;
            adPostedOn =
                Functions().timeAgo(DateTime.parse(listingData.dateOfCreation));
          });
        }
      }
    }
  }

  Widget buildSliders(BuildContext context, List<String> images) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Swiper(
      itemBuilder: (BuildContext context, int i) {
        return new CachedNetworkImage(
          imageUrl: images[i],
          placeholder: (BuildContext context, String val) {
            return Container(
              color: Colors.grey[350],
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          // errorWidget: (BuildContext context, String val, Exception e) {
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
        );
      },
      itemCount: images.length,
      itemWidth: screenWidth,
      containerHeight: 350,
      pagination: new SwiperPagination(
        builder: DotSwiperPaginationBuilder(
            activeColor: Colors.white,
            color: Colors.grey,
            size: 5,
            activeSize: 7),
      ),
    );
  }

  Widget shimmer() {
    double screenWidth = MediaQuery.of(context).size.width;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          iconTheme: IconThemeData(color: Colors.grey[100]),
          leading: Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey[100],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.teal,
          expandedHeight: 300,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: <Widget>[
                Shimmer.fromColors(
                  period: Duration(milliseconds: 1000),
                  baseColor: Colors.grey[350],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    scale: 6.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[350],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      width: screenWidth,
                      height: 20,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[350],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      width: screenWidth * 0.70,
                      height: 20,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[350],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      width: screenWidth,
                      height: 70,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[350],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      width: screenWidth * 0.70,
                      height: 20,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[350],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      width: screenWidth,
                      height: 20,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[350],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      width: screenWidth,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? shimmer()
          : CustomScrollView(
              slivers: <Widget>[
                new SliverAppBar(
                  leading: new Container(
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: new IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.grey[200],
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: MyColors.blue,
                  expandedHeight: 350,
                  pinned: true,
                  floating: false,
                  flexibleSpace: new FlexibleSpaceBar(
                    background: Stack(
                      children: <Widget>[
                        new Container(
                          color: Colors.red,
                          child: listingData.photos.length > 0
                              ? buildSliders(context, listingData.photos)
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
                        Positioned(
                          left: 0,
                          bottom: 20,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 9),
                                  child: Icon(
                                    FontAwesomeIcons.moneyBill,
                                    size: 16,
                                    color: MyColors.blue,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: listingData.price == ""
                                              ? '\$0'
                                              : '\$${listingData.price}',
                                          style: TextStyle(
                                            color: MyColors.red,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      TextSpan(
                                        text: ' / Month',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                          ),
                        ),
                      ],
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
                                          margin: EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            (int.parse(listingData.bathrooms) >
                                                        1 &&
                                                    int.parse(listingData
                                                            .bedrooms) >
                                                        1)
                                                ? '${listingData.bedrooms} Bedrooms, ${listingData.bathrooms} Bathrooms for Rent'
                                                : (int.parse(listingData
                                                            .bedrooms) >
                                                        1)
                                                    ? '${listingData.bedrooms} Bedrooms, ${listingData.bathrooms} Bathroom for Rent'
                                                    : (int.parse(listingData
                                                                .bathrooms) >
                                                            1)
                                                        ? '${listingData.bedrooms} Bedroom, ${listingData.bathrooms} Bathrooms for Rent'
                                                        : '${listingData.bedrooms} Bedroom, ${listingData.bathrooms} Bathroom for Rent',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'Posted $adPostedOn',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: Text(
                                      'Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: MyColors.availableGreen,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey[400],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      'About this listing',
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
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons.bed,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            int.parse(listingData
                                                                        .bedrooms) >
                                                                    1
                                                                ? '${listingData.bedrooms} Bedrooms'
                                                                : '${listingData.bedrooms} Bedroom',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .shower,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            int.parse(listingData
                                                                        .bathrooms) >
                                                                    1
                                                                ? '${listingData.bathrooms} Bathrooms'
                                                                : '${listingData.bathrooms} Bathroom',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons.paw,
                                                          color: MyColors.blue,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            (listingData.dogFriendly ==
                                                                        "Yes" &&
                                                                    listingData
                                                                            .catFriendly ==
                                                                        "Yes")
                                                                ? 'Dogs & Cats Friendly'
                                                                : (listingData
                                                                            .dogFriendly ==
                                                                        "Yes")
                                                                    ? 'Dogs Friendly'
                                                                    : (listingData.catFriendly ==
                                                                            "Yes")
                                                                        ? 'Cats Friendly'
                                                                        : 'Not Dogs & Cats Friendly',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .building,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '${listingData.type}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '${listingData.availability}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .vectorSquare,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '${listingData.size} Square Feet',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .airFreshener,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '${listingData.acType}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons.car,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '${listingData.parkingType}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          Icons.developer_board,
                                                          color: MyColors.blue,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            '${listingData.laundryType}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .fireAlt,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            listingData.heatingType ==
                                                                    null
                                                                ? 'None'
                                                                : '${listingData.heatingType}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
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
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey[400],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        listingData.briefDescription,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey[400],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      'Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      listingData.address,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 40),
                                    child: Divider(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 12),
                                          child: Text(
                                            'Seller Information',
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
                                                      clipBehavior:
                                                          Clip.antiAlias,
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
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                              '${listingData.owner.firstName} ${listingData.owner.lastName}'),
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
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: InkWell(
                                                          onTap: () =>
                                                              print('Hello'),
                                                          child: Container(
                                                            width: 150,
                                                            height: 35,
                                                            child: Center(
                                                              child: Text(
                                                                'View Profile',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: MyColors
                                                                    .blue,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () =>
                                                            print('Hello'),
                                                        child: Container(
                                                          width: 150,
                                                          height: 35,
                                                          child: Center(
                                                            child: Text(
                                                              'Message Seller',
                                                              style: TextStyle(
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
                                                      ),
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
                          ],
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
