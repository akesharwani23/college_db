import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/current_user.dart';
import './verified_home_screen.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrentUser?>(
        stream: Provider.of<CurrentUserProvider>(context).cachedUser,
        builder: (context, userStream) {
          if (userStream.connectionState == ConnectionState.active ||
              userStream.connectionState == ConnectionState.done) {
            if (userStream.hasData) {
              // got a not-null CurrentUser
              final user = userStream.data!;
              if (user.isVerified) {
                return const VerifiedHomeScreen();
              } else {
                return Scaffold(
                  appBar: AppBar(title: const Text('Not Verified')),
                  drawer: const AppDrawer(),
                  body: Center(
                      child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'This Account Is Not Verified',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )),
                );
              }
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurrentUser?>(
        future: Provider.of<CurrentUserProvider>(context).getCurrentUser,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.done) {
            if (userSnapshot.hasData) {
              // got a not-null CurrentUser
              final user = userSnapshot.data!;
              if (user.isVerified) {
                return const VerifiedHomeScreen();
              } else {
                return Scaffold(
                  appBar: AppBar(title: const Text('Not Verified')),
                  drawer: const AppDrawer(),
                  body: Center(
                      child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'This Account Is Not Verified',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )),
                );
              }
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
