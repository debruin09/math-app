import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_app/models/group_members.dart';
import 'package:math_app/models/record.dart';
import 'package:math_app/models/chat.dart';
import 'package:math_app/models/group.dart';
import 'package:math_app/models/member.dart';
import 'package:math_app/providers/group_provider.dart';

class DatabaseService {
  final CollectionReference communityCollection =
      Firestore.instance.collection("Global");

  final CollectionReference groupCollection =
      Firestore.instance.collection("Groups");

  final CollectionReference recordCollection =
      Firestore.instance.collection("Papers");

  final String uid;

  DatabaseService({this.uid});

  Member _memberDataFromSnapShot(DocumentSnapshot snapshot) {
    try {
      return Member(
          uid: uid,
          username: snapshot.data["username"],
          email: snapshot.data["email"] ?? "",
          challenge: snapshot.data["challenge"] ?? false);
    } catch (e) {
      print("Error from member  snapshot: $e");
      return null;
    }
  }

  List<Member> _listMemberFromSnapShot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents
          .map((doc) => Member(
              email: doc.data["email"] ?? "",
              username: doc.data["username"] ?? "",
              challenge: doc.data["challenge"] ?? false))
          .toList();
    } catch (e) {
      print("Error from list member from snapshot: $e");
      return null;
    }
  }

  // group from query snapshot
  List<Group> _groupFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents
              .map((doc) => Group(
                  groupName: doc.data["groupname"] ?? "",
                  group:
                      GroupProvider.convertToMemberList(doc.data["members"])))
              .toList() ??
          [];
    } catch (e) {
      print("Error from group from snapshot : $e");
      return null;
    }
  }

  // record from query snapshot
  List<Record> _recordFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents
              .map((doc) => Record(
                  location: doc.data["location"],
                  url: doc.data["url"],
                  type: doc.data["type"]))
              .toList() ??
          [];
    } catch (e) {
      print("Error from records from snapshot : $e");
      return null;
    }
  }

// updates members fdata in the database
  Future updateMemberData({
    String username,
    String email,
    bool challenge,
  }) async {
    print("\nupdating data...\n");
    return await communityCollection.document(uid).setData({
      "username": username,
      "email": email,
      "challenge": challenge,
    });
  }

// Creates a new group in the database
  Future createNewGroup({List<Member> groupMembers, String groupName}) async {
    final members = groupMembers
        .map((member) => GroupProvider.convertMemberToMap(member))
        .toList(); // [Member, Member, ..., Member] => [{"uid": uid ,}, {}, ..., {}]

    return await groupCollection
        .document(groupName)
        .setData({"members": members, "groupname": groupName});
  }

  //Add new message to database
  Future addMessage({Chat chat, groupName}) async {
    return await groupCollection
        .document(groupName)
        .collection("messages")
        .add({
      "text": chat.text,
      "from": chat.from,
      "date": chat.date,
    });
  }

//  get stream of all the teams in the database
  Stream<List<Member>> get members {
    return communityCollection.snapshots().map(_listMemberFromSnapShot);
  }

  // get team doc steam
  Stream<Member> get memberData {
    try {
      return communityCollection
          .document(uid)
          .snapshots()
          .map((snapshot) => _memberDataFromSnapShot(snapshot));
    } catch (e) {
      print("Error from firestore: $e");
      return null;
    }
  }

  // // Listen for new groups in the database
  Stream<List<Group>> get groups {
    try {
      return groupCollection.snapshots().map(_groupFromSnapshot);
    } catch (e) {
      print("Error from group stream : $e");
      return null;
    }
  }

  Stream<List<Record>> get records {
    try {
      return recordCollection.snapshots().map(_recordFromSnapshot);
    } catch (e) {
      print("Error from records( pdfs ) stream : $e");
      return null;
    }
  }

  Stream<List<DocumentSnapshot>> get chats {
    try {
      return groupCollection
          .document()
          .collection("collectionPath")
          .snapshots()
          .map((docs) => docs.documents);
    } catch (e) {
      print("Error from chats stream : $e");
      return null;
    }
  }
}
