import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:okay/services/wikipedia_service.dart';

class FavorilerScreen extends StatelessWidget {
  // Statik favori yerler listesi
  final List<String> favoritePlaces = [
    "Göbeklitepe",
    "Ayasofya ",
    "Topkapı Sarayı",
    "Anıtkabir",
    "Dolmabahçe Sarayı",
    "Galata Kulesi",
    "Balıklıgöl",
    "Sultanahmet Camii",
    "Bursa Ulu Camii",
    "Nemrut Dağı",
    "Troya",
    "Sümela Manastırı",
    "Efes ",
    "Aspendos Antik Tiyatrosu",
    "Kapadokya",
    "Yerebatan Sarnıcı",
    "Aspendos"
  ];

  FavorilerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoriler",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: favoritePlaces.length,
        itemBuilder: (context, index) {
          final placeName = favoritePlaces[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlaceDetailScreen(placeName: placeName),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.place, color: Colors.blueAccent, size: 32),
                    const SizedBox(width: 16),
                    Text(
                      placeName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlaceDetailScreen extends StatefulWidget {
  final String placeName;

  const PlaceDetailScreen({super.key, required this.placeName});

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String? placeDetail;
  bool isLoading = true;
  int currentSentenceIndex = 0;
  List<String> sentences = [];

  @override
  void initState() {
    super.initState();
    fetchPlaceDetail();
  }

  Future<void> fetchPlaceDetail() async {
    try {
      WikipediaService wikipediaService = WikipediaService();
      final data =
          await wikipediaService.fetchHistoricalPlaces(widget.placeName);
      setState(() {
        placeDetail =
            data['extract'] ?? "Bu yer hakkında detaylı bilgi bulunamadı.";
        sentences = placeDetail!.split('. ');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        placeDetail = "Bilgi getirilemedi: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _speakNextSentence() async {
    if (currentSentenceIndex < sentences.length) {
      await flutterTts.setLanguage("tr-TR");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(sentences[currentSentenceIndex]);
    }
  }

  Future<void> _speak() async {
    if (currentSentenceIndex < sentences.length) {
      await _speakNextSentence();
      flutterTts.setCompletionHandler(() {
        setState(() {
          currentSentenceIndex++;
        });
        if (currentSentenceIndex < sentences.length) {
          _speakNextSentence();
        }
      });
    }
  }

  Future<void> _pause() async {
    await flutterTts.stop();
  }

  Future<void> _resume() async {
    if (currentSentenceIndex < sentences.length) {
      _speakNextSentence();
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Kaydırma özelliğini geri ekliyoruz
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placeDetail ?? "Bilgi bulunamadı.",
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _speak,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Sesli Okuma Başlat"),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _pause,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Duraklat"),
                  ),
                ],
              ),
            ),
    );
  }
}
