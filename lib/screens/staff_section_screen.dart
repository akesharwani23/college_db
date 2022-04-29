import 'package:college_db/screens/staff_form_screen.dart';
import 'package:flutter/material.dart';

class StaffSectionScreen extends StatelessWidget {
  const StaffSectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(StaffFormScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
