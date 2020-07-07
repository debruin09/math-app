import 'package:flutter/material.dart';
import 'package:math_app/home/widgets/drawer_widget.dart';
import 'package:math_app/models/name.dart';
import 'package:math_app/models/record.dart';
import 'package:math_app/pdf/pdf_page.dart';
import 'package:math_app/services/auth_service.dart';
import 'package:math_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LibraryPage extends StatefulWidget {
  static const scale = 100.0 / 72.0;

  final String group;
  final String duration;

  LibraryPage({this.group, this.duration});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Color> colors = [Colors.red, Colors.blue, Colors.green];

  final spinkit = SpinKitFadingCube(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? appBarTheme : secondaryTheme,
        ),
      );
    },
  );

  Future<void> _infoPopUp(context, name) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: appBarTheme,
            title: Text(
              "Information",
              style: normalTextTheme,
            ),
            content: Text(
              "File: $name",
              style: normalTextTheme,
            ),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Close",
                    style: normalTextTheme,
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final records = Provider.of<List<Record>>(context) ?? [];

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: tertiaryTheme,
        appBar: AppBar(
          backgroundColor: appBarTheme,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          title: Text(
            "Library",
            style:
                TextStyle(color: Colors.white, fontFamily: "EraserDust-p70d"),
          ),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).signOut();
              },
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        drawer: DrawerWidget(),
        body: records == null
            ? Center(child: spinkit)
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 20.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Books",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "EraserDust-p70d"),
                        ),
                        SizedBox(height: 15.0),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: records
                                .where((record) => record.type == "books")
                                .map(
                                  (record) => Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (records != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFScreen(
                                                        duration:
                                                            widget.duration ??
                                                                0,
                                                        group:
                                                            widget.group ?? "",
                                                        url: record.url,
                                                        name: Name.change(
                                                            record.location),
                                                      )));
                                        }
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                bottom: 10.0, left: 6.0),
                                            alignment: Alignment.bottomLeft,
                                            height: 180.0,
                                            width: 120.0,
                                            color: secondaryTheme,
                                            child: Text(
                                              Name.change(record.location),
                                              style:
                                                  TextStyle(color: appBarTheme),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Positioned(
                                              right: 0.0,
                                              child: IconButton(
                                                onPressed: () {
                                                  _infoPopUp(
                                                      context,
                                                      Name.change(
                                                          record.location));
                                                },
                                                icon: Icon(Icons.info),
                                                color: appBarTheme,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Exam Papers & Memos",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "EraserDust-p70d"),
                        ),
                        SizedBox(height: 15.0),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: records
                                .where((record) => record.type == "exam")
                                .map(
                                  (record) => Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (records != null) {
                                          print(record.location);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFScreen(
                                                        duration:
                                                            widget.duration ??
                                                                0,
                                                        group:
                                                            widget.group ?? "",
                                                        url: record.url,
                                                        name: Name.change(
                                                            record.location),
                                                      )));
                                        }
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                bottom: 10.0, left: 6.0),
                                            alignment: Alignment.bottomLeft,
                                            height: 180.0,
                                            width: 120.0,
                                            color: secondaryTheme,
                                            child: Text(
                                              Name.change(record.location),
                                              style:
                                                  TextStyle(color: appBarTheme),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Positioned(
                                              right: 0.0,
                                              child: IconButton(
                                                onPressed: () {
                                                  _infoPopUp(
                                                      context,
                                                      Name.change(
                                                          record.location));
                                                },
                                                icon: Icon(Icons.info),
                                                color: appBarTheme,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Extra Material",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "EraserDust-p70d"),
                        ),
                        SizedBox(height: 15.0),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: records
                                .where((record) => record.type == "material")
                                .map(
                                  (record) => Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (records != null) {
                                          print(record.location);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFScreen(
                                                        duration:
                                                            widget.duration ??
                                                                0,
                                                        group:
                                                            widget.group ?? "",
                                                        url: record.url,
                                                        name: Name.change(
                                                            record.location),
                                                      )));
                                        }
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                bottom: 10.0, left: 6.0),
                                            alignment: Alignment.bottomLeft,
                                            height: 180.0,
                                            width: 120.0,
                                            color: secondaryTheme,
                                            child: Text(
                                              Name.change(record.location),
                                              style:
                                                  TextStyle(color: appBarTheme),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Positioned(
                                              right: 0.0,
                                              child: IconButton(
                                                onPressed: () {
                                                  _infoPopUp(
                                                      context,
                                                      Name.change(
                                                          record.location));
                                                },
                                                icon: Icon(Icons.info),
                                                color: appBarTheme,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
