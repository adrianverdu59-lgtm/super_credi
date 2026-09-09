import '../../shared/models/payment_model.dart';

class SupabaseService {
  // Simulador de envío de datos mientras conectamos las credenciales de Supabase
  static Future<bool> submitPayment(PaymentModel payment) async {
    try {
      // Simulación de latencia de red
      await Future.delayed(const Duration(seconds: 2));
      
      // Aquí irá la llamada real:
      // await Supabase.instance.client.from('payments').insert(payment.toJson());
      
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> loginUser(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }
}
