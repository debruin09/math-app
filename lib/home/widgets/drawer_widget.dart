import 'package:flutter/material.dart';
import 'package:math_app/home/global_chat.dart';
import 'package:math_app/home/group/my_groups.dart';
import 'package:math_app/home/library_page.dart';
import 'package:math_app/home/list_members.dart';
import 'package:math_app/models/member.dart';
import 'package:math_app/providers/group_provider.dart';
import 'package:math_app/shared/constants.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  Future openDialog(context) async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    return await showDialog(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints.tight(Size(250.0, 300.0)),
            height: 250.0,
            child: AlertDialog(
              backgroundColor: appBarTheme,
              title: Text(
                "Create A Group",
                style: normalTextTheme,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  TextField(
                    onChanged: (value) {
                      groupProvider.groupName = value;
                    },
                    decoration: formTheme.copyWith(
                        hintText: "Enter group name",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListOfMembers()));
                            },
                            icon: Icon(
                              Icons.person_add,
                              color: secondaryTheme,
                            )),
                      ),
                      Expanded(
                        child: Text("Invite Members", style: normalTextTheme),
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: normalTextTheme),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final member = Provider.of<Member>(context);
    String username = "";
    if (member != null) {
      username = member.username;
    }

    return Drawer(
      child: Container(
        color: appBarTheme,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [appBarTheme, secondaryTheme]),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        username ?? "User",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontFamily: "EraserDust-p70d"),
                      )),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView(children: [
                ListTile(
                  leading: Icon(Icons.library_books, color: secondaryTheme),
                  title: Text("Library", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LibraryPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.chat, color: secondaryTheme),
                  title: Text("Community Chat",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GlobalChatPage(username: username)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group_add, color: secondaryTheme),
                  title: Text("Create Group",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                    openDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group, color: secondaryTheme),
                  title:
                      Text("My Groups", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyGroups()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lightbulb_outline, color: secondaryTheme),
                  title: Text("Create Challenge",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group_work, color: secondaryTheme),
                  title:
                      Text("Community", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_to_queue, color: secondaryTheme),
                  title:
                      Text("Contribute(Coming Soon)", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.settings, color: secondaryTheme),
                //   title:
                //       Text("Settings", style: TextStyle(color: Colors.white)),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //   },
                // )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
