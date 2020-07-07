class GroupMember {
  String username;
  String email;
  bool isAdmin = false;
  bool selected = false;
  bool challenge = false;

  GroupMember({this.username, this.email, this.isAdmin, this.challenge});
}
