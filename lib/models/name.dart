class Name {
  static change(String name) {
    int last = name.lastIndexOf("/");
    String newString = name.substring(last + 1, name.length);
    return newString;
  }
}
