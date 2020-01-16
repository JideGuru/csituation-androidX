import 'dart:convert';
import 'package:college_situation/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:college_situation/common/widgets/findSchoolWidget.dart';
import 'package:college_situation/api/findschoolBackend.dart';
import 'package:college_situation/models/findSchoolModel.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController textController = TextEditingController();
  String searchWord = '';
  List<SchoolData> schoolDataList = [];
  List<SchoolData> recentSearchList;
  String firstResponse;
  Map dataMap;
  FindSchoolModel data;
  String token;
  bool notNull(Object o) => o != null;
  List recentSearches = [];
  List recentSearchesID = [];
  List recentSearchesCity = [];
  List recentSearchesState = [];

  @override
  void initState() {
    getRecentSearches();
    super.initState();
  }
 
  getRecentSearches() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print(e.message);
    } finally {
      setState(() {
        token = prefs.getString(Constants.token);
        List<String> recentSearchesIDTemp = prefs.getStringList('RSID') ?? [];
        recentSearchesID = recentSearchesIDTemp.length > 5
            ? recentSearchesIDTemp.reversed.toList().getRange(0, 5).toList()
            : recentSearchesIDTemp.reversed.toList();
        List<String> recentSearchesTemp =
            prefs.getStringList('recentSearches') ?? [];
        recentSearches = recentSearchesTemp.length > 5
            ? recentSearchesTemp.reversed.toList().getRange(0, 5).toList()
            : recentSearchesTemp.reversed.toList();
        List<String> recentSearchesCityTemp = prefs.getStringList('RSC') ?? [];
        recentSearchesCity = recentSearchesCityTemp.length > 5
            ? recentSearchesCityTemp.reversed.toList().getRange(0, 5).toList()
            : recentSearchesCityTemp.reversed.toList();
        List<String> recentSearchesStateTemp = prefs.getStringList('RSS') ?? [];
        recentSearchesState = recentSearchesStateTemp.length > 5
            ? recentSearchesStateTemp.reversed.toList().getRange(0, 5).toList()
            : recentSearchesStateTemp.reversed.toList();
      });
      getSchools();
    }
  }

  getSchools() async {
    try {
      firstResponse = await FindSchoolBackend.get(token);
    } catch (e) {
      print(e.message);
    } finally {
      if (firstResponse != null) {
        setState(() {
          dataMap = jsonDecode(firstResponse);
          data = FindSchoolModel.fromJson(dataMap);
          schoolDataList = data.data;
        });
      }
    }
  }

  buildResultList() {
    if (searchWord.length > 0) {
      List<SchoolData> tempList = List();
      for (int i = 0; i < schoolDataList.length; i++) {
        if (schoolDataList[i]
            .name
            .toLowerCase()
            .contains(searchWord.toLowerCase())) {
          tempList.add(schoolDataList[i]);
        }
      }
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'SEARCH RESULTS',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
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
                itemCount: tempList.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: Container(
                      child: Text(
                        tempList[i].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Container(
                      child: Text('${tempList[i].city}, ${tempList[i].state}'),
                    ),
                    onTap: () async {
                      SharedPreferences prefs;
                      try {
                        prefs = await SharedPreferences.getInstance();
                      } catch (e) {
                        print(e.message);
                      } finally {
                        if (recentSearches.contains(tempList[i].name)) {
                          setState(() {
                            recentSearchesID.remove(tempList[i].sId);
                            recentSearchesID.add(tempList[i].sId);
                            recentSearches.remove(tempList[i].name);
                            recentSearches.add(tempList[i].name);
                            recentSearchesCity.remove(tempList[i].city);
                            recentSearchesCity.add(tempList[i].city);
                            recentSearchesState.remove(tempList[i].state);
                            recentSearchesState.add(tempList[i].state);
                          });
                        } else {
                          setState(() {
                            recentSearchesID.add(tempList[i].sId);
                            recentSearches.add(tempList[i].name);
                            recentSearchesCity.add(tempList[i].city);
                            recentSearchesState.add(tempList[i].state);
                          });
                        }
                        prefs.setStringList('RSC', recentSearchesCity);
                        prefs.setStringList('RSS', recentSearchesState);
                        prefs.setStringList('RSID', recentSearchesID);
                        prefs.setStringList('recentSearches', recentSearches);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => FindSchoolWidget(
                                  schoolData: tempList[i],
                                  fromSearch: true,
                                ),
                          ),
                        );
                      }
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      if (recentSearches.length > 0) {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'RECENT SEARCHES',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              new Divider(
                color: Colors.grey[400],
              ),
              new Flexible(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int i) => Divider(
                        color: Colors.grey[400],
                      ),
                  itemCount: recentSearches.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      title: Text(
                        recentSearches[i],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        child: Text(
                            '${recentSearchesCity[i]}, ${recentSearchesState[i]}'),
                      ),
                      onTap: () {
                        for (int j = 0; j < schoolDataList.length; j++) {
                          if (schoolDataList[j]
                              .sId
                              .toLowerCase()
                              .contains(recentSearchesID[i].toLowerCase())) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FindSchoolWidget(
                                      schoolData: schoolDataList[j],
                                      fromSearch: true,
                                    ),
                              ),
                            );
                            // String thisSchoolName = recentSearches[i];
                            // String thisSchoolID = recentSearchesID[i];
                            // recentSearchesID.remove(thisSchoolID);
                            // recentSearchesID.add(thisSchoolID);
                            // recentSearches.remove(thisSchoolName);
                            // recentSearches.add(thisSchoolName);
                          }
                        }
                      },
                    );
                  },
                ),
              ),
              new Divider(
                color: Colors.grey[400],
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search for colleges',
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
      body: buildResultList(),
    );
  }
}
