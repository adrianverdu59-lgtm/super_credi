import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentFormScreen extends StatefulWidget {
  final String loanId;

  const PaymentFormScreen({super.key, required this.loanId});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _amountUsdController = TextEditingController();
  final _bcvRateController = TextEditingController();
  final _bankOriginController = TextEditingController();
  final _phoneSenderController = TextEditingController();
  final _referenceController = TextEditingController();

  bool _isLoading = false;
  final _supabase = Supabase.instance.client;

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final double amountUsd = double.parse(_amountUsdController.text);
    final double bcvRate = double.parse(_bcvRateController.text);
    final double amountVes = amountUsd * bcvRate;
    final userId = _supabase.auth.currentUser?.id;

    try {
      await _supabase.from('payments').insert({
        'loan_id': widget.loanId,
        'user_id': userId,
        'amount_usd': amountUsd,
        'bcv_rate': bcvRate,
        'amount_ves': amountVes,
        'bank_origin': _bankOriginController.text.trim(),
        'phone_sender': _phoneSenderController.text.trim(),
        'reference_number': _referenceController.text.trim(),
        'status': 'under_review',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago registrado exitosamente. En revisión.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el pago: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Pago Móvil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountUsdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto en USD (\$)'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bcvRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Tasa BCV (VES/\$)'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bankOriginController,
                decoration: const InputDecoration(labelText: 'Banco Emisor (Ej: Banplus)'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneSenderController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono emisor'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _referenceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Número de referencia (6 dígitos)'),
                validator: (v) => v!.length < 4 ? 'Ingresa una referencia válida' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitPayment,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child: _isLoading 
                  ? const CircularProgressIndicator()
                  : const Text('Registrar Pago'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
