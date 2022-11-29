import 'package:arp_scanner/arp_scanner.dart';
import 'package:arp_scanner/device.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ARP SCANNER TEST'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Device> devicesFound = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ArpScanner.onScanning.listen((Device device) {
      setState(() {
        devicesFound.add(device);
      });
    });
    ArpScanner.onScanFinished.listen((List<Device> devices) {
      for (var device in devices) {
        print("IP : ${device.ip} || mac : ${device.mac} ");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: devicesFound.length,
            itemBuilder: (context, index) => devicesFound.isEmpty
                ? const Text(
                    "NoThing is found at the moment",
                    style: TextStyle(color: Colors.black),
                  )
                : ListTile(
                    leading: const Icon(Icons.laptop),
                    title: Text(devicesFound[index].ip.toString()),
                    subtitle: Text(
                        "- Mac :${devicesFound[index].mac} \n- HostName :${devicesFound[index].hostname} \n- Vendor :${devicesFound[index].vendor}"),
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          devicesFound.clear();
          await ArpScanner.scan();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.scanner),
      ),
    );
  }
}
