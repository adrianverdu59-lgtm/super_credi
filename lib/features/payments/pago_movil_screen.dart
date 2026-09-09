import 'package:flutter/material.dart';
import '../../core/services/bcv_service.dart';
import '../../core/services/supabase_service.dart';
import '../../shared/models/payment_model.dart';

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
  bool _isSubmitting = false;

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

  void _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final totalVes = widget.installmentAmountUsd * _currentBcvRate;

      final payment = PaymentModel(
        id: '',
        loanId: 'demo-loan-id',
        userId: 'demo-user-id',
        amountUsd: widget.installmentAmountUsd,
        bcvRate: _currentBcvRate,
        amountVes: totalVes,
        bankOrigin: _selectedBank,
        phoneSender: _phoneController.text,
        referenceNumber: _referenceController.text,
        status: 'under_review',
        createdAt: DateTime.now(),
      );

      final success = await SupabaseService.submitPayment(payment);

      if (mounted) {
        setState(() => _isSubmitting = false);

        if (success) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Pago Registrado'),
              content: Text(
                'Referencia: ${_referenceController.text}\n'
                'Monto: Bs. ${totalVes.toStringAsFixed(2)}\n'
                'Estatus: Registrado exitosamente para revisión.',
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al enviar el pago. Intenta de nuevo.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
                  onPressed: _isSubmitting ? null : _submitPayment,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('REGISTRAR PAGO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
