import 'package:flutter/material.dart';
import 'package:money_manager/entities/transaction.dart';
import 'dart:io';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${transaction.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Description: ${transaction.description}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Amount: \$${transaction.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Date: ${transaction.date.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Text('Type: ${transaction.isInput ? 'Input' : 'Expense'}', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                if (transaction.imagePath.isNotEmpty)
                  Image.file(File(transaction.imagePath)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
