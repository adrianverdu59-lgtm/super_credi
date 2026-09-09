import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/bcv_service.dart';

class PagoMovilScreen extends StatefulWidget {
  final double installmentAmountUsd;
  final double bcvRate;

  const PagoMovilScreen({
    super.key,
    required this.installmentAmountUsd,
    this.bcvRate = 36.50,
  });

  @override
  State<PagoMovilScreen> createState() => _PagoMovilScreenState();
}

class _PagoMovilScreenState extends State<PagoMovilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedBank = '0102 - Banco de Venezuela';
  late double _currentBcvRate;
  bool _isLoadingRate = true;

  final List<String> _banks = [
    '0102 - Banco de Venezuela',
    '0108 - Banco Provincial',
    '0134 - Banesco',
    '0105 - Banco Mercantil',
    '0191 - Banplus',
    '0172 - Bancamiga',
  ];

  @override
  void initState() {
    super.initState();
    _currentBcvRate = widget.bcvRate;
    _loadLiveBcvRate();
  }

  Future<void> _loadLiveBcvRate() async {
    final rate = await BcvService.fetchBcvRate();
    if (mounted) {
      setState(() {
        _currentBcvRate = rate;
        _isLoadingRate = false;
      });
    }
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      final totalVes = widget.installmentAmountUsd * _currentBcvRate;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pago Registrado'),
          content: Text(
            'Referencia: ${_referenceController.text}\n'
            'Monto: Bs. ${totalVes.toStringAsFixed(2)}\n'
            'Estatus: En verificación por Administración.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalVes = widget.installmentAmountUsd * _currentBcvRate;

    return Scaffold(
      appBar: AppBar(title: const Text('Pagar Cuota - Pago Móvil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Cuota a pagar:'),
                          Text(
                            '\$${widget.installmentAmountUsd.toStringAsFixed(2)} USD',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tasa BCV oficial:'),
                          _isLoadingRate
                              ? const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text('Bs. ${_currentBcvRate.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total a transferir:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Bs. ${totalVes.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Datos para la transferencia:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const SelectableText('• Banco: Banplus (0191)\n• Teléfono: 0412-0000000\n• RIF: J-500000000'),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedBank,
                decoration: const InputDecoration(labelText: 'Banco emisor (Origen)'),
                items: _banks.map((bank) => DropdownMenuItem(value: bank, child: Text(bank))).toList(),
                onChanged: (val) => setState(() => _selectedBank = val!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono emisor', hintText: '04121234567'),
                validator: (val) => (val == null || val.isEmpty) ? 'Ingresa el teléfono emisor' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _referenceController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(labelText: 'Últimos 6 dígitos de la referencia'),
                validator: (val) {
                  if (val == null || val.length < 6) return 'Ingresa los 6 dígitos completos';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPayment,
                  child: const Text('REGISTRAR PAGO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
