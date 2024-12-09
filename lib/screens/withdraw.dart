// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  // Simulated withdrawal logic
  Future<void> processWithdrawal(
      BuildContext context, String amount, String? method) async {
    if (method == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    // Simulating a delay for the withdrawal process
    await Future.delayed(const Duration(seconds: 2));

    // Generate a random transaction ID
    final transactionId = _generateTransactionId();

    // Show receipt dialog
    // ignore: use_build_context_synchronously
    _showReceipt(context, amount, method, transactionId);

    // Simple success logic
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //       content: Text('Withdrawal of \$$amount via $method was successful!')),
    // );
  }

  // Generate a random transaction ID
  String _generateTransactionId() {
    final random = Random();
    return 'TXN-${random.nextInt(900000) + 100000}';
  }

  // Show a dialog with the receipt
  void _showReceipt(BuildContext context, String amount, String method,
      String transactionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Withdrawal Receipt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: \$$amount'),
              Text('Payment Method: $method'),
              Text('Transaction ID: $transactionId'),
              Text('Date: ${DateTime.now()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _printReceipt(amount, method, transactionId);
              },
              child: const Text('Print Receipt'),
            ),
          ],
        );
      },
    );
  }

  // Print receipt as a PDF
  Future<void> _printReceipt(
      String amount, String method, String transactionId) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Withdrawal Receipt',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Text('Amount: \$$amount',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Payment Method: $method',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Transaction ID: $transactionId',
                  style: pw.TextStyle(fontSize: 16)),
              pw.Text('Date: ${DateTime.now()}',
                  style: pw.TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );

    // Use the Printing package to handle the actual printing process
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    String? selectedMethod;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input Field
            const Text(
              'Enter Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount to withdraw',
              ),
            ),
            const SizedBox(height: 16),

            // Payment Method Dropdown
            const Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedMethod,
              items: const [
                DropdownMenuItem(value: 'Bank', child: Text('Bank Transfer')),
                DropdownMenuItem(value: 'Mpesa', child: Text('Mpesa')),
                DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
                DropdownMenuItem(value: 'Stripe', child: Text('Stripe'))
              ],
              onChanged: (value) {
                // Handle selection change
                selectedMethod = value;
                if (kDebugMode) {
                  print('Selected Payment Method: $selectedMethod');
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select a method',
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle the withdrawal process
                  final String amount = amountController.text.trim();
                  if (amount.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter an amount')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Processing withdrawal of \$$amount'),
                      ),
                    );
                    // Add your withdrawal logic here
                    processWithdrawal(context, amount, selectedMethod);
                  }
                },
                child: const Text('Confirm Withdrawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
