import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const MyHomePage(title: 'Live Location Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String country = "-";
  String locality = "-";
  String postalCode = "-";
  String area = "-";
  loc.LocationData? locationData;
  List<Placemark>? placemark;
  _getLocationPermission() async {
    if (await Permission.location.isGranted) {
      _getLocationData();
    } else {
      await Permission.location.request();
    }
  }

  _getLocationData() async {
    locationData = await loc.Location.instance.getLocation();
    placemark = await placemarkFromCoordinates(
        locationData!.latitude!, locationData!.longitude!);
    setState(() {
      country = placemark![0].country.toString();
      locality = placemark![0].locality.toString();
      postalCode = placemark![0].postalCode.toString();
      area = placemark![0].administrativeArea.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.share_location_rounded,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Your Location Details",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: ListTile(
                leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(
                      Icons.apartment,
                      color: Colors.blue,
                    )),
                title: Text(locality),
                subtitle: const Text("Locality"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(
                      Icons.flag,
                      color: Colors.blue,
                    )),
                title: Text(country),
                subtitle: const Text("Country"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    )),
                title: Text(area),
                subtitle: const Text("Administrative Area"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: ListTile(
                leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(
                      Icons.pin,
                      color: Colors.blue,
                    )),
                title: Text(postalCode),
                subtitle: const Text("Postal Code"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  _getLocationPermission();
                },
                child: const Text("Get Current Location"))
          ],
        ),
      ),
    );
  }
}
