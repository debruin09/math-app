import 'package:flutter/material.dart';
import 'package:math_app/models/member.dart';

class GroupProvider with ChangeNotifier {
  List<Member> _group = [];
  String _groupName;

  set groupName(value) {
    _groupName = value;
    notifyListeners();
  }

  String get groupName => _groupName;
  List<Member> get group => _group;

  void addMemberToGroup(Member member) {
    try {
      if (!_group.contains(member)) {
        _group.add(member);
        print("Members in group: ${_group.length}");
        notifyListeners();
      }
    } catch (e) {
      print("Error from add member: $e");
    }
  }

  void removeMemberFromGroup(Member member) {
    try {
      if (_group.length > 0) {
        int myIndex = _group.indexOf(member);
        _group.removeAt(myIndex);
        print("Members in group: ${_group.length}");
        notifyListeners();
      }
    } catch (e) {
      print("Error from remove member: $e");
    }
  }

  static convertMemberToMap(Member member) {
    return {
      "username": member.username,
      "email": member.email,
      "is_admin": member.isAdmin
    };
  }

  static convertToMemberList(List<dynamic> list) {
    if (list != null) {
      return list
          .map((mem) => Member(
              email: mem["email"],
              username: mem["username"],
              isAdmin: mem["is_admin"],
              challenge: mem["challenge"]))
          .toList();
    }
  }
}
