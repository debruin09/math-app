import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:math_app/home/group/group_chat.dart';
import 'package:math_app/home/widgets/drawer_widget.dart';
import 'package:math_app/models/member.dart';
import 'package:math_app/shared/constants.dart';
import 'package:provider/provider.dart';

import 'package:math_app/models/group.dart';

class MyGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<List<Group>>(context) ?? [];
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appBarTheme, //,
      appBar: AppBar(
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
          "My Groups",
          style: TextStyle(color: Colors.white, fontFamily: "EraserDust-p70d"),
        ),
        backgroundColor: appBarTheme,
       
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20.0),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: MyGroup(group: groups[index]));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class MyGroup extends StatelessWidget {
  final Group group;
  MyGroup({
    Key key,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final member = Provider.of<Member>(context) ?? Member();

    final Firestore firestore = Firestore.instance;
    DocumentReference firestoreRef =
        firestore.collection("Groups").document(group.groupName);
    return Card(
      elevation: 5.0,
      child: Container(
        color: secondaryTheme,
        child: ListTile(
          title: Text(
            group.groupName,
            style: myGroupTextTheme,
          ),
          onTap: () {
            group.group.forEach((mem) {
              if (member.username == mem.username) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupChatPage(
                            username: member.username,
                            groupName: group.groupName,
                            firestoreRef: firestoreRef)));
              }
            });
          },
        ),
      ),
    );
  }
}
