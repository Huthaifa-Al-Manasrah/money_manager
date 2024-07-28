import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_manager/screens/transaction_details_screen.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, i) {
        final tx = transactions[i];
        return ListTile(
          leading: Image.file(File(tx.imagePath)),
          title: Text(tx.title),
          subtitle: Text(tx.description),
          trailing: Text('\$${tx.amount.toStringAsFixed(2)}'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TransactionDetailsScreen(transaction: tx),
              ),
            );
          },
        );
      },
    );
  }
}