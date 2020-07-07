import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:math_app/home/library_page.dart';
import 'package:math_app/models/member.dart';
import 'package:math_app/providers/challenge_provider.dart';
import 'package:math_app/shared/constants.dart';
import 'package:provider/provider.dart';

class CreateChallengePage extends StatelessWidget {
  final String group;
  CreateChallengePage({this.group});
  final _textController = TextEditingController();
  final _durationController = TextEditingController();
  final _paperController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final challenge = Provider.of<Challenge>(context);
    final members = Provider.of<List<Member>>(context);
    final firestoreRef = Firestore.instance.collection("Global").document();

    void updateGlobalMembers() {
      members.forEach((member) {
        firestoreRef.updateData({
          "challenge": true,
          "email": member.email,
          "username": member.username
        });
      });
    }

    return Scaffold(
      backgroundColor: appBarTheme,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                  child: Text(
                    "Create a challenge",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontFamily: "EraserDust-p70d",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(height: 15.0),
                Text(
                  "Paper:",
                  style: challengeText,
                ),
                TextField(
                  controller: _paperController,
                  decoration: formTheme.copyWith(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  "Question(s):",
                  style: challengeText,
                ),
                TextField(
                  controller: _textController,
                  decoration: formTheme.copyWith(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  "Challenge Duration(minutes):",
                  style: challengeText,
                ),
                TextField(
                  controller: _durationController,
                  decoration: formTheme.copyWith(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 50.0,
                    onPressed: () {
                      try {
                        challenge.paper = _paperController.text ?? "";
                        challenge.question =
                            _textController.text.toString() ?? "";
                        challenge.duration =
                            int.parse(_durationController.text) ?? 0;

                        Firestore.instance
                            .collection("challenge")
                            .document()
                            .setData({
                          "paper": challenge.paper ?? "",
                          "questions": challenge.question ?? "",
                          "duration": challenge.duration ?? 0,
                          "group": group
                        });

                        updateGlobalMembers();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LibraryPage(group: group)));
                      } catch (e) {
                        print("Error from challenge upload function $e");
                      }
                    },
                    color: secondaryTheme,
                    child: Text(
                      "Create Challenge",
                      style: TextStyle(color: appBarTheme, fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
