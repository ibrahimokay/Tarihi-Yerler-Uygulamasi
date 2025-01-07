import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:okay/screens/location_details_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Marker> _markers = [];
  LatLng? _currentLocation; // Kullanıcının cihaz konumu
  bool isLoading = true; // Genel yüklenme durumu
  bool isLocationLoading = true; // Konum yüklenme durumu

  @override
  void initState() {
    super.initState();
    _loadLocationsFromJson(); // Tarihi yerlerin verilerini yükle
    _getCurrentLocation(); // Kullanıcının cihaz konumunu al
  }

  Future<void> _loadLocationsFromJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/locations.json');
      final List<dynamic> data = json.decode(response);

      List<Marker> markers = data.map((location) {
        return Marker(
          point: LatLng(location['latitude'], location['longitude']),
          builder: (context) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationDetailsScreen(
                    locationName: location['name'],
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 30,
            ),
          ),
        );
      }).toList();

      setState(() {
        _markers = markers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("JSON dosyası yüklenirken hata oluştu: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Konum hizmetleri devre dışı.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Konum izni reddedildi.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Konum izni kalıcı olarak reddedildi.");
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        isLocationLoading = false;
      });
    } catch (e) {
      setState(() {
        isLocationLoading = false;
      });
      debugPrint("Konum alınırken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarihi Yerler"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Geri butonuna basıldığında, ana sayfaya (main class) dön
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: isLoading || isLocationLoading
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      center: _currentLocation ??
                          LatLng(39.92077, 32.85411), // Türkiye konumu
                      zoom: 6.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          if (_currentLocation != null)
                            Marker(
                              point: _currentLocation!,
                              builder: (context) => const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          ..._markers,
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
