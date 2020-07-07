class Chat {
  String from;
  String text;
  String date = DateTime.now().toIso8601String().toString();
  Chat({
    this.from,
    this.text,
    this.date,
  });
}
