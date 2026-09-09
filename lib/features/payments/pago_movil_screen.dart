import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagoMovilScreen extends StatefulWidget {
  final double installmentAmountUsd;
  final double bcvRate;

  const PagoMovilScreen({
    super.key,
    required this.installmentAmountUsd,
    required this.bcvRate,
  });

  @override
  State<PagoMovilScreen> createState() => _PagoMovilScreenState();
}

class _PagoMovilScreenState extends State<PagoMovilScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedBank;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  final List<Map<String, String>> _banks = [
    {'code': '0102', 'name': '0102 - Banco de Venezuela'},
    {'code': '0105', 'name': '0105 - Banco Mercantil'},
    {'code': '0134', 'name': '0134 - Banesco'},
    {'code': '0108', 'name': '0108 - Banco Provincial'},
    {'code': '0114', 'name': '0114 - Bancamiga'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _cedulaController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  double get _amountVes => widget.installmentAmountUsd * widget.bcvRate;

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Reporte'),
          content: Text(
            'Monto: Bs. ${_amountVes.toStringAsFixed(2)}\n'
            'Referencia: ${_referenceController.text}\n\n'
            '¿Deseas enviar este pago a revisión?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pago reportado con éxito. En verificación.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar Pago Móvil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Cuota (USD):'),
                          Text('\$${widget.installmentAmountUsd.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tasa BCV:'),
                          Text('Bs. ${widget.bcvRate.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total en Bolívares:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            'Bs. ${_amountVes.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedBank,
                decoration: const InputDecoration(
                  labelText: 'Banco Emisor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
                items: _banks.map((bank) {
                  return DropdownMenuItem<String>(
                    value: bank['code'],
                    child: Text(bank['name']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedBank = value),
                validator: (value) =>
                    value == null ? 'Selecciona el banco' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cedulaController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Cédula / RIF del Pagador',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa la cédula' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Número de Referencia (4 a 6 dígitos)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.receipt_long),
                ),
                validator: (value) => value == null || value.length < 4
                    ? 'Mínimo 4 dígitos'
                    : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitPayment,
                  child: const Text('REPORTAR PAGO',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
