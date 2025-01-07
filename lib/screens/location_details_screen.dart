import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationDetailsScreen extends StatelessWidget {
  final String locationName;

  const LocationDetailsScreen({required this.locationName, super.key});

  Future<Map<String, dynamic>?> fetchWikipediaData(String name) async {
    final url = Uri.parse(
        'https://tr.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro&explaintext&titles=$name');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'];
        final firstPage = pages[pages.keys.first];
        return firstPage;
      }
    } catch (e) {
      debugPrint("Wikipedia verisi alınırken hata: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Kullanıcı IntroScreen'e dönsün
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchWikipediaData(locationName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Veri yüklenemedi.'));
          }

          final extract = snapshot.data?['extract'] ?? 'Bilgi bulunamadı.';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                extract,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
