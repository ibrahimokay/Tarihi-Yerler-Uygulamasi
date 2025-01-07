import 'dart:convert'; // JSON verilerini işlemek için kullanılır.
import 'package:http/http.dart'
    as http; // HTTP isteklerini yapmak için kullanılır.

// Wikipedia'dan veri çekecek servis sınıfını oluşturuyoruz.
class WikipediaService {
  // Wikipedia API'sinin temel URL adresini tanımlıyoruz.
  final String baseUrl = 'https://tr.wikipedia.org/w/api.php';

  // Belirtilen tarihi yer adına göre Wikipedia'dan veri çeken fonksiyon.
  Future<Map<String, dynamic>> fetchHistoricalPlaces(String placeName) async {
    try {
      // Wikipedia API'sine GET isteği gönderiyoruz.
      final response = await http.get(
        Uri.parse(
            // API'ye yapılacak isteğin URL'sini oluşturuyoruz.
            '$baseUrl?action=query&format=json&prop=extracts&exintro&explaintext&titles=$placeName&utf8=1'),
      );

      // HTTP isteğinin başarılı olup olmadığını kontrol ediyoruz.
      if (response.statusCode == 200) {
        // 200: Başarılı istek kodu.
        // Gelen JSON formatındaki yanıtı bir Map'e (sözlük) dönüştürüyoruz.
        Map<String, dynamic> data = jsonDecode(response.body);

        // API yanıtındaki 'query' altındaki 'pages' bölümünü alıyoruz.
        var pages = data['query']['pages'];

        // Sayfalardaki ilk öğeyi alıyoruz (ana içerik burada bulunur).
        var page = pages.values.first;

        // Çekilen sayfa verilerini döndürüyoruz.
        return page;
      } else {
        // Başarısız HTTP durumlarında hata fırlatıyoruz.
        throw Exception(
            "API çağrısı başarısız oldu. Hata kodu: ${response.statusCode}");
      }
    } catch (e) {
      // Herhangi bir hata oluştuğunda hatayı yakalayıp istisna fırlatıyoruz.
      throw Exception("Veri çekme sırasında bir hata oluştu: $e");
    }
  }
}
