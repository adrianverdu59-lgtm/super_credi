import 'package:flutter/material.dart';

class AdminApprovalsScreen extends StatefulWidget {
  const AdminApprovalsScreen({super.key});

  @override
  State<AdminApprovalsScreen> createState() => _AdminApprovalsScreenState();
}

class _AdminApprovalsScreenState extends State<AdminApprovalsScreen> {
  final List<Map<String, dynamic>> _pendingLoans = [
    {
      'id': 'CR-104',
      'userName': 'Carlos Mendoza',
      'cedula': 'V-19876543',
      'phone': '0412-1112233',
      'bank': '0102 - Banco de Venezuela',
      'accountNumber': '01020123456789012345',
      'level': 'Plata',
      'paidInstallments': 34,
      'requestedUsd': 250.0,
      'installmentsCount': 6,
      'bcvRate': 36.50,
      'date': '09/09/2026',
    },
    {
      'id': 'CR-105',
      'userName': 'María Gómez',
      'cedula': 'V-22345678',
      'phone': '0414-9998877',
      'bank': '0134 - Banesco',
      'accountNumber': '01340987654321098765',
      'level': 'Bronce',
      'paidInstallments': 12,
      'requestedUsd': 100.0,
      'installmentsCount': 4,
      'bcvRate': 36.50,
      'date': '09/09/2026',
    },
  ];

  Map<String, dynamic>? _selectedLoan;

  @override
  void initState() {
    super.initState();
    if (_pendingLoans.isNotEmpty) {
      _selectedLoan = _pendingLoans.first;
    }
  }

  void _handleDecision(bool isApproved) {
    if (_selectedLoan == null) return;

    final action = isApproved ? 'Aprobado' : 'Rechazado';
    final loanId = _selectedLoan!['id'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Crédito $loanId $action con éxito.'),
        backgroundColor: isApproved ? Colors.green : Colors.red,
      ),
    );

    setState(() {
      _pendingLoans.removeWhere((item) => item['id'] == loanId);
      _selectedLoan = _pendingLoans.isNotEmpty ? _pendingLoans.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin - Aprobaciones'),
      ),
      body: _pendingLoans.isEmpty
          ? const Center(
              child: Text(
                'No hay solicitudes pendientes por revisar.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : isDesktop
              ? Row(
                  children: [
                    Expanded(flex: 2, child: _buildLoanList()),
                    const VerticalDivider(width: 1),
                    Expanded(flex: 3, child: _buildLoanDetail()),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: _buildLoanList()),
                    if (_selectedLoan != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SizedBox(
                                height: MediaQuery.of(context).size.height * 0.85,
                                child: _buildLoanDetail(),
                              ),
                            );
                          },
                          child: const Text('Ver Detalle de Solicitud'),
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildLoanList() {
    return ListView.builder(
      itemCount: _pendingLoans.length,
      itemBuilder: (context, index) {
        final loan = _pendingLoans[index];
        final isSelected = _selectedLoan?['id'] == loan['id'];

        return ListTile(
          selected: isSelected,
          title: Text(
            loan['userName'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${loan['id']} • \$${loan['requestedUsd']} USD'),
          trailing: Chip(label: Text(loan['level'])),
          onTap: () => setState(() => _selectedLoan = loan),
        );
      },
    );
  }

  Widget _buildLoanDetail() {
    if (_selectedLoan == null) return const Center(child: Text('Selecciona una solicitud'));

    final loan = _selectedLoan!;
    final double amountVes = loan['requestedUsd'] * loan['bcvRate'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solicitud ${loan['id']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            _infoRow('Cliente:', loan['userName']),
            _infoRow('Cédula:', loan['cedula']),
            _infoRow('Teléfono:', loan['phone']),
            _infoRow('Nivel:', '${loan['level']} (${loan['paidInstallments']} cuotas)'),
            _infoRow('Monto:', '\$${loan['requestedUsd']} USD (Bs. ${amountVes.toStringAsFixed(2)})'),
            _infoRow('Banco Destino:', loan['bank']),
            _infoRow('Nro. Cuenta:', loan['accountNumber']),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => _handleDecision(false),
                    child: const Text('RECHAZAR'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _handleDecision(true),
                    child: const Text('APROBAR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
