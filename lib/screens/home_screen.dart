import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:okay/main.dart';
import 'package:okay/services/wikipedia_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WikipediaService _wikipediaService = WikipediaService();
  final FlutterTts _flutterTts = FlutterTts();
  String _city = '';
  String _historicalPlaces = '';
  bool isSpeaking = false;

  void _searchHistoricalPlaces() async {
    try {
      final data = await _wikipediaService.fetchHistoricalPlaces(_city);
      setState(() {
        _historicalPlaces = data['extract'] ?? 'Bilgi bulunamadı.';
      });
    } catch (e) {
      setState(() {
        _historicalPlaces = 'Veri çekilirken bir hata oluştu.';
      });
    }
  }

  void _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.setLanguage("tr-TR");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(text);
      setState(() {
        isSpeaking = true;
      });
    }
  }

  void _stopSpeaking() async {
    await _flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarihi Yerler'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Başlık
              const Text(
                "Bilgi Almak İstediğiniz Tarihi Yer :",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              // Şehir arama alanı
              TextField(
                onChanged: (value) {
                  setState(() {
                    _city = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Ara butonu
              ElevatedButton(
                onPressed: _searchHistoricalPlaces,
                child: const Text('Ara'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  elevation: 4,
                ),
              ),
              const SizedBox(height: 20),
              // Tarihi yerlerin bulunduğu kart
              if (_historicalPlaces.isNotEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tarihi Yer:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _historicalPlaces,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Sesli okuma butonu
              if (_historicalPlaces.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    if (isSpeaking) {
                      _stopSpeaking();
                    } else {
                      _speak(_historicalPlaces);
                    }
                  },
                  icon: Icon(isSpeaking ? Icons.stop : Icons.volume_up),
                  label: Text(isSpeaking ? 'Durdur' : 'Dinle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSpeaking ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Geri dön butonu
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                },
                child: const Text('Geri Dön'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
