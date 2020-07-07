import 'package:flutter/material.dart';
import 'package:math_app/auth/widgets/submit_button.dart';
import 'package:math_app/home/group/my_groups.dart';
import 'package:math_app/models/member.dart';
import 'package:math_app/providers/group_provider.dart';
import 'package:math_app/services/database_service.dart';
import 'package:math_app/shared/constants.dart';
import 'package:provider/provider.dart';

class ListOfMembers extends StatefulWidget {
  @override
  _ListOfMembersState createState() => _ListOfMembersState();
}

class _ListOfMembersState extends State<ListOfMembers> {
  final DatabaseService _service = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final members = Provider.of<List<Member>>(context);

    return Scaffold(
      backgroundColor: tertiaryTheme,
      appBar: AppBar(
        title: Text(
          "Add Members",
          style: TextStyle(color: Colors.white, fontFamily: "EraserDust-p70d"),
        ),
        backgroundColor: appBarTheme,
      ),
      body: ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            return MemberTile(member: members[index]);
          }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35.0),
        child: SubmitButton(
          color: secondaryTheme,
          width: double.infinity,
          text: "Create Group",
          onPressed: () {
            try {
              _service.createNewGroup(
                  groupMembers: groupProvider.group,
                  groupName: groupProvider.groupName);

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyGroups()));
            } catch (e) {
              print("Error from create group method : $e");
            }
          },
        ),
      ),
    );
  }
}

// List<Member> test_members = [
//   Member(username: "Mark", email: "test09@test.com", isAdmin: false),
//   Member(username: "CHUCKIE", email: "test09@test.com", isAdmin: false),
//   Member(username: "Chad", email: "chad11@test.com", isAdmin: false),
//   Member(username: "Klue", email: "klue78@test.com", isAdmin: true),
//   Member(username: "Debruin", email: "db09@test.com", isAdmin: false),
//   Member(username: "Flames", email: "flame0406@test.com", isAdmin: false),
//   Member(username: "Testing Boy", email: "testing09@test.com", isAdmin: false),
// ];

class MemberTile extends StatefulWidget {
  final Member member;
  MemberTile({this.member});
  @override
  _MemberTileState createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Card(
          elevation: 5.0,
          child: Container(
            color: secondaryTheme,
            child: ListTile(
              trailing: widget.member.selected
                  ? Icon(Icons.check_box, color: appBarTheme)
                  : SizedBox(
                      width: 1.0,
                    ),
              onTap: () {
                setState(() {
                  widget.member.selected = !widget.member.selected;

                  if (widget.member.selected == true) {
                    print(widget.member.selected);
                    groupProvider.addMemberToGroup(widget.member);
                  } else {
                    groupProvider.removeMemberFromGroup(widget.member);
                  }
                });
              },
              title: Text(
                widget.member.username,
                style: normalTextTheme.copyWith(color: appBarTheme),
              ),
            ),
          ),
        ));
  }
}
