import 'dart:math';

class CartApi {
  CartApi() : _random = Random();

  final Random _random;
  static const Duration _delay = Duration(milliseconds: 300);
  static const double _errorChance = 0.15;

  Future<void> addItem(int productId, int quantity) async {
    await Future.delayed(_delay);
    if (_random.nextDouble() < _errorChance) {
      throw Exception('Erro ao adicionar item');
    }
  }

  Future<void> removeItem(int productId) async {
    await Future.delayed(_delay);
    if (_random.nextDouble() < _errorChance) {
      throw Exception('Erro ao remover item');
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    await Future.delayed(_delay);
    if (_random.nextDouble() < _errorChance) {
      throw Exception('Erro ao atualizar quantidade');
    }
  }
}
