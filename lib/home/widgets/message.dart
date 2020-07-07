import 'package:flutter/material.dart';
import 'package:math_app/home/group/view_image.dart';

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String image;

  final bool me;

  const Message({Key key, this.from, this.text, this.me, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        padding: EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment:
              me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              from ?? "Nothing from From",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Material(
              color: text != ""
                  ? me ? Colors.black : Colors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
              elevation: 6.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: text != ""
                    ? Text(
                        text ?? "Nothing from Text",
                        style: me
                            ? TextStyle(
                                color: Colors.white,
                                fontFamily: "EraserDust-p70d")
                            : TextStyle(
                                color: Colors.black,
                                fontFamily: "EraserDust-p70d"),
                      )
                    : Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImagePage(image: image)));
                          },
                                                child: Hero(
                            tag: "$image${DateTime.now().toIso8601String()}",
                            child: Image.network(image)),
                        ), height: 130.0, width: 100.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
