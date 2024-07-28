import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_manager/screens/add_transaction_screen.dart';
import 'package:money_manager/screens/transaction_details_screen.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Fetch transactions when the HomePage is built
    transactionProvider.fetchTransactions();

    return Scaffold(
      appBar: AppBar(title: const Text('Money Manager')),
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            final groupedTransactions = provider.groupTransactionsByMonth();

            return ListView.builder(
              itemCount: groupedTransactions.keys.length,
              itemBuilder: (context, index) {
                final month = groupedTransactions.keys.elementAt(index);
                final transactions = groupedTransactions[month]!;

                // Calculate monthly inputs and expenses
                final monthlyInputs = transactions
                    .where((t) => t.isInput)
                    .fold(0.0, (sum, t) => sum + t.amount);
                final monthlyExpenses = transactions
                    .where((t) => !t.isInput)
                    .fold(0.0, (sum, t) => sum + t.amount.abs());

                final difference = monthlyInputs - monthlyExpenses;

                return Container(
                  margin: const EdgeInsets.only(
                      bottom: 5, top: 20, right: 5, left: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 7,
                            spreadRadius: -1)
                      ]),
                  child: Theme(
                    data: ThemeData(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 5),
                              Image.asset('assets/icons/calendar.png',
                                  width: 30, height: 30),
                              const SizedBox(width: 10),
                              Text(month,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                '\$${difference.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      childrenPadding: EdgeInsets.zero,
                      title: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: BorderDirectional(
                                bottom:
                                    BorderSide(width: 2, color: Colors.amber))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/icons/poor.png',
                                              width: 30, height: 30),
                                          const SizedBox(height: 20),
                                          const Text('Inputs',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                      Text(
                                          '\$${monthlyInputs.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ))
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                              'assets/icons/spending.png',
                                              width: 20,
                                              height: 30),
                                          const SizedBox(height: 20),
                                          const Text('Expenses',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                      Text(
                                          '\$${monthlyExpenses.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      children: transactions.map((tx) {
                        return ListTile(
                          leading: Image.file(File(tx.imagePath)),
                          title: Text(tx.title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(tx.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                              Text(tx.date.toLocal().toString().split(' ')[0],
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Text('\$${tx.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              Image.asset(
                                  'assets/icons/${tx.isInput ? 'up-arrow' : 'down-arrow'}.png',
                                  width: 20,
                                  height: 20),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    TransactionDetailsScreen(transaction: tx),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
