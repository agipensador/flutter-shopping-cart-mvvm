import 'package:shared_preferences/shared_preferences.dart';

class CepStorage {
  static const String _keyUserCep = 'userCEP';

  Future<String?> getCep() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserCep);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCep(String cep) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserCep, cep);
    } catch (_) {
      // Ignora falha ao salvar
    }
  }
}
