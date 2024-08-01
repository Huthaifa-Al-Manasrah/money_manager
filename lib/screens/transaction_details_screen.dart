import 'package:flutter/material.dart';
import 'package:money_manager/entities/transaction.dart';
import 'dart:io';

import '../generated/l10n.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).transactionDetails),
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
                Text('${S.of(context).title}: ${transaction.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('${S.of(context).description}: ${transaction.description}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('${S.of(context).amount}: \$${transaction.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('${S.of(context).date}: ${transaction.date.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Text('${S.of(context).type}: ${transaction.isInput ? S.of(context).input : S.of(context).expense}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                if(transaction.imagePath != null)
                  Image.file(File(transaction.imagePath!)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
