// Gerekli kütüphaneleri ve ekranları projeye dahil ediyoruz.
import 'package:flutter/material.dart';
import 'package:okay/screens/favoriler_screen.dart'; // Favoriler ekranını import ediyoruz.
import 'package:okay/screens/home_screen.dart'; // Ana ekranı import ediyoruz.
import 'package:okay/screens/intro_screen.dart'; // Tanıtım ekranını import ediyoruz.

// Uygulamanın başlangıç noktası.
void main() {
  runApp(MyApp()); // MyApp widget'ını çalıştırıyoruz.
}

// MyApp sınıfı, StatelessWidget olarak tanımlanmıştır.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug banner'ı kapatıyoruz.
      title: 'Tarihi Yerler', // Uygulama başlığını belirliyoruz.
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema rengi mavi olarak ayarlandı.
      ),
      home: MainScreen(), // Ana ekran olarak MainScreen'i belirtiyoruz.
    );
  }
}

// Ana ekran sınıfı.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uygulama üst başlığı (AppBar)
      appBar: AppBar(
        centerTitle: true, // Başlık ortalanmış şekilde görüntülenir.
        title: const Text(
          "Hoşgeldiniz", // AppBar başlığı.
          style: TextStyle(
            fontSize: 30, // Başlık yazı boyutu.
            fontWeight: FontWeight.bold, // Kalın font.
            color: Colors.red, // Kırmızı renkli yazı.
            letterSpacing: 2.0, // Harfler arası boşluk.
            fontFamily: 'Roboto', // Yazı tipi (font) ayarı.
          ),
        ),
        backgroundColor: Colors.blue, // AppBar arka plan rengi mavi.
        elevation: 0, // Gölgelendirme kaldırıldı.
      ),
      // Ekranın ana içeriği (body).
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Dikey hizalama merkezde.
          children: [
            // İlk resim widget'ı.
            Image.asset(
              'assets/images/okay.png', // İlk resmin dosya yolu.
              width: 400, // Genişlik 400 piksel.
              height: 300, // Yükseklik 300 piksel.
              fit: BoxFit.cover, // Resmi ekrana sığdır.
            ),
            const SizedBox(height: 20), // İki resim arasında boşluk ekledik.

            // İkinci resim widget'ı.
            Image.asset(
              'assets/images/okay1.png', // İkinci resmin dosya yolu.
              width: 400, // Genişlik 400 piksel.
              height: 300, // Yükseklik 300 piksel.
              fit: BoxFit.cover, // Resmi ekrana sığdır.
            ),
            const SizedBox(height: 20), // Altında boşluk ekledik.
          ],
        ),
      ),
      // Alt gezinme çubuğu (Bottom Navigation Bar).
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0), // Kenarlardan iç boşluk ekliyoruz.
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent, // Arka plan rengi mavi tonları.
            borderRadius:
                BorderRadius.circular(30.0), // Köşeleri ovalleştiriyoruz.
            boxShadow: const [
              BoxShadow(
                color: Colors.black26, // Hafif gölge efekti.
                offset: Offset(0, -4), // Yön ve konum.
                blurRadius: 4, // Bulanıklık oranı.
              ),
            ],
          ),
          // Butonlar için yatay bir sıra (Row).
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Butonları eşit şekilde dağıtıyoruz.
            children: [
              // Intro butonu.
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    // Intro ekranına geçiş yapıyoruz.
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IntroScreen()),
                  );
                },
                icon: const Icon(Icons.info_outline), // Bilgi simgesi.
                label: const Text("Harita"), // Buton etiketi.
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange, // Buton arka plan rengi turuncu.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Oval köşeler.
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // İç boşluklar.
                ),
              ),
              // Home butonu.
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    // Home ekranına geçiş yapıyoruz.
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                icon: const Icon(Icons.home), // Ana sayfa simgesi.
                label: const Text("Home"), // Buton etiketi.
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Buton arka plan rengi yeşil.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Oval köşeler.
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // İç boşluklar.
                ),
              ),
              // Favoriler butonu.
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    // Favoriler ekranına geçiş yapıyoruz.
                    context,
                    MaterialPageRoute(builder: (context) => FavorilerScreen()),
                  );
                },
                icon: const Icon(Icons.star_border), // Yıldız simgesi.
                label: const Text("Favoriler"), // Buton etiketi.
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Buton arka plan rengi sarı.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Oval köşeler.
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // İç boşluklar.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
