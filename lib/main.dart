import 'package:flutter/material.dart';
import 'package:math_app/auth/auth_wrapper.dart';
import 'package:math_app/models/group_members.dart';
import 'package:math_app/models/record.dart';
import 'package:math_app/home/library_page.dart';
import 'package:math_app/models/group.dart';
import 'package:math_app/models/member.dart';
import 'package:math_app/providers/challenge_provider.dart';
import 'package:math_app/providers/group_provider.dart';
import 'package:math_app/services/auth_service.dart';
import 'package:math_app/services/database_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<AuthService>(
        create: (context) => AuthService(),
      ),
      ChangeNotifierProvider<GroupProvider>(
          create: (context) => GroupProvider()),
      ChangeNotifierProvider<Challenge>(create: (context) => Challenge()),
      StreamProvider<Member>.value(
        value: AuthService().onAuthStateChange,
      ),
      StreamProvider<List<Member>>.value(
        value: DatabaseService().members,
      ),
      StreamProvider<List<Group>>.value(
        value: DatabaseService().groups,
      ),
      StreamProvider<List<Record>>.value(
        value: DatabaseService().records,
      ),
      // StreamProvider<List<GroupMember>>.value(
      //   value: DatabaseService().groupmembers,
      // ),
    ], child: Wrapper());
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final member = Provider.of<Member>(context);
    if (member == null) {
      return MaterialApp(
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      );
    } else {
      return StreamProvider<Member>.value(
        value: DatabaseService(uid: member.uid).memberData,
        catchError: (context, object) {
          try {
            return object;
          } catch (e) {
            print("Error from stream provider: $e");
            return null;
          }
        },
        child: MaterialApp(
          home: LibraryPage(),
          debugShowCheckedModeBanner: false,
        ),
      );
    }
  }
}
