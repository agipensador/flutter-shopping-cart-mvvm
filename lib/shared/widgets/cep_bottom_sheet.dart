import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/services/cep_storage.dart';
import 'app_button.dart';

class CepBottomSheet extends StatefulWidget {
  const CepBottomSheet({
    super.key,
    required this.onCalculated,
    this.cepStorage,
  });

  final VoidCallback onCalculated;
  final CepStorage? cepStorage;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCalculated,
    CepStorage? cepStorage,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => CepBottomSheet(
        onCalculated: onCalculated,
        cepStorage: cepStorage ?? CepStorage(),
      ),
    );
  }

  @override
  State<CepBottomSheet> createState() => _CepBottomSheetState();
}

class _CepBottomSheetState extends State<CepBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();

  CepStorage get _cepStorage => widget.cepStorage ?? CepStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedCep();
  }

  Future<void> _loadSavedCep() async {
    try {
      final savedCep = await _cepStorage.getCep();
      if (mounted && savedCep != null && savedCep.isNotEmpty) {
        _cepController.text = savedCep;
        setState(() {});
      }
    } catch (_) {
      // SharedPreferences pode falhar (ex: hot reload, plugin não registrado)
    }
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  String? _validateCep(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o CEP corretamente';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 8) {
      return 'Preencha o CEP corretamente';
    }
    return null;
  }

  void _onCalculate() async {
    if (_formKey.currentState?.validate() ?? false) {
      final cep = _cepController.text.replaceAll(RegExp(r'\D'), '');
      await _cepStorage.saveCep(cep);
      widget.onCalculated();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Calcular frete',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: '00000000',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCep,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Calcular',
                onPressed: _onCalculate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
