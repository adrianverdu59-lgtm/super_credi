import 'dart:convert';
import 'package:http/http.dart' as http;

class BcvService {
  static const String _apiUrl = 'https://ve.dolarapi.com/v1/dolares/oficial';

  static Future<double> fetchBcvRate() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['promedio'] as num).toDouble();
      } else {
        return 36.50; // Tasa por defecto de respaldo
      }
    } catch (e) {
      return 36.50; // Tasa por defecto si no hay conexión
    }
  }
}
