import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  appBar: AppBar(
                    title: const Text('Not Verified'),
                    backgroundColor: Colors.redAccent,
                  ),
                  drawer: const AppDrawer(),
                  body: Container(
                    color: const Color.fromARGB(255, 246, 237, 237),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 39,
                        ),
                        const FaIcon(
                          FontAwesomeIcons.ban,
                          size: 66,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'This Account Is Not Verified',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
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
