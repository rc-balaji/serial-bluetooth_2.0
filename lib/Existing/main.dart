import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'MainPage.dart'; // Make sure this path matches the location of your MainPage widget

void main() => runApp(ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: requestPermissions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MainPage();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  // Function to request permissions
  Future<void> requestPermissions() async {
    final permissionStatus = await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    final isGranted = permissionStatus.values.every((status) => status.isGranted);
    if (!isGranted) {
      // Permissions not granted. Handle appropriately.
      print("One or more permissions were denied");
    }
  }
}
