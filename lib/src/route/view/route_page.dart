import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:vision_intelligence/common/widgets/custom_appbar.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  LatLng? driverLatLng;
  String driverAddress = 'Fetching location...';

  // Default fallback location
  final LatLng defaultLatLng = LatLng(23.0641, 72.4397);

  @override
  void initState() {
    super.initState();
    print("[DEBUG] initState() called");
    fetchDriverLocation();
  }

  Future<void> fetchAddressFromCoordinates(double lat, double lng) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng');

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'Flutter App' // Required by Nominatim API
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['display_name'];
        if (address != null) {
          setState(() {
            driverAddress = address;
          });
        } else {
          setState(() {
            driverAddress = 'Address not found';
          });
        }
      } else {
        setState(() {
          driverAddress = 'Failed to fetch address';
        });
      }
    } catch (e) {
      setState(() {
        driverAddress = 'Error: $e';
      });
    }
  }

  Future<void> fetchDriverLocation() async {
    print("[DEBUG] Fetching driver location...");

    bool locationFetched = false;

    // Start timeout fallback
    Future.delayed(const Duration(seconds: 5), () async {
      if (!locationFetched && mounted) {
        print("[TIMEOUT] Location not received in 20 seconds. Using default.");
        setState(() {
          driverLatLng = defaultLatLng;
        });
        await fetchAddressFromCoordinates(defaultLatLng.latitude, defaultLatLng.longitude);
      }
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.1.97:5000/location'));
      print("[DEBUG] Response status: ${response.statusCode}");
      print("[DEBUG] Response body: ${response.body}");

      final data = json.decode(response.body);
      double? lat = data['latitude'];
      double? lng = data['longitude'];

      if (lat != null && lng != null) {
        debugPrint("[DEBUG] Parsed lat: $lat, lng: $lng");

        setState(() {
          driverLatLng = LatLng(lat, lng);
        });

        locationFetched = true;
        await fetchAddressFromCoordinates(lat, lng);
      } else {
        debugPrint("[ERROR] Received null for lat/lng");
      }

    } catch (e) {
      print("[EXCEPTION] Error fetching location: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    print("[DEBUG] Building UI. driverLatLng: $driverLatLng");

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            const CustomAppbar(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Stack(
                  children: [
                    if (driverLatLng != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        child: FlutterMap(
                          options: MapOptions(
                            center: driverLatLng,
                            zoom: 15.0,
                            onTap: (_, __) => print("[DEBUG] Map tapped"),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                              tileProvider: NetworkTileProvider(),
                              userAgentPackageName:
                              'com.example.vision_intelligence',
                              errorImage:
                              const AssetImage('assets/images/map_error.png'),
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: driverLatLng!,
                                  width: 50,
                                  height: 50,
                                  builder: (ctx) {
                                    print(
                                        "[DEBUG] Marker displayed at $driverLatLng");
                                    return const Icon(Icons.location_on,
                                        color: Colors.red, size: 40);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Driver's Live Location",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                driverAddress,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
