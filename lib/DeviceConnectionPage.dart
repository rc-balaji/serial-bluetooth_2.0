import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'GlobalState.dart';

class DeviceConnectionPage extends StatefulWidget {
  @override
  _DeviceConnectionPageState createState() => _DeviceConnectionPageState();
}

class _DeviceConnectionPageState extends State<DeviceConnectionPage> {
  List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devicesList = bondedDevices;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect to a Device"),
      ),
      body: ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devicesList[index].name ?? "Unknown device"),
            subtitle: Text(devicesList[index].address),
            onTap: () {
              _connect(devicesList[index]);
            },
          );
        },
      ),
    );
  }

  void _connect(BluetoothDevice device) async {
    try {
      final connection = await BluetoothConnection.toAddress(device.address);
      Provider.of<GlobalState>(context, listen: false)
          .setBluetoothConnection(true, device.address, device.name ?? 'Unknown', device.address, connection);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Cannot connect, exception occurred: $e")));
    }
  }

}
