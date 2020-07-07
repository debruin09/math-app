import 'package:flutter/material.dart';

class ViewImagePage extends StatelessWidget {
  final String image;
  ViewImagePage({this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Hero(
                tag: "$image",
                child: Image.network(image),
              )),
          Positioned(
              right: 30.0,
              top: 70.0,
              child: IconButton(
                  icon: Icon(Icons.cancel, size: 50.0, color: Colors.white,),
                  onPressed: () {
                    Navigator.pop(context);
                  }))
        ],
      ),
    );
  }
}
