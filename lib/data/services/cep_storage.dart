import 'package:shared_preferences/shared_preferences.dart';

import '../../core/result/result.dart';

class CepStorage {
  static const String _keyUserCep = 'userCEP';

  Future<Result<String?>> getCep() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cep = prefs.getString(_keyUserCep);
      return Result.success(cep);
    } catch (e) {
      // Com mais tempo, adicionei tratativas de erro
      return Result.failure('Erro ao ler CEP salvo: $e');
    }
  }

  Future<Result<void>> saveCep(String cep) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserCep, cep);
      return Result.success(null);
    } catch (e) {
      // Com mais tempo, adicionei tratativas de erro
      return Result.failure('Erro ao salvar CEP: $e');
    }
  }
}
