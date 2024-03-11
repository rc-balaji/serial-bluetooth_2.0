import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'GlobalState.dart';

class DeviceConnectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This page should contain logic for scanning and displaying Bluetooth devices
    // For brevity, the actual scanning and connection logic is omitted
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect to a Device"),
      ),
      body: Center(
        child: Text("Device scanning and connection UI goes here"),
      ),
    );
  }
}
