class Member {
  String uid;
  String username;
  String email;
  bool isAdmin = false;
  bool selected = false;
  bool challenge = false;

  Member({this.uid, this.username, this.email, this.isAdmin, this.challenge});
}
