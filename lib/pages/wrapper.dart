import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_workflow/data/appData.dart';
import 'package:google_sign_in_workflow/pages/auth_page.dart';
import 'package:google_sign_in_workflow/pages/home_page.dart';
import 'package:google_sign_in_workflow/pages/splash_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  GoogleSignInAccount user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var appData = Provider.of<AppData>(context, listen: false);
    appData.userStream.add(null);
    appData.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) {
      print('here');
      setState(() {
        appData.setUser(account);
      });
      appData.userStream.add(appData.currentUser);
    });
    print('here');
    appData.googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Provider.of<AppData>(context, listen: false).userStream.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? SplashScreen()
              : snapshot.data == null ? AuthPage() : HomePage();
        },
      ),
    );
  }
}
