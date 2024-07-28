import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:money_manager/entities/transaction.dart';


class TransactionProvider with ChangeNotifier {
  List<TransactionEntity> _transactions = [];

  List<TransactionEntity> get transactions => [..._transactions];

  Database? _db;

  Future<void> initializeDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'transactions.db');

    _db = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE transactions(id TEXT PRIMARY KEY, title TEXT, description TEXT, imagePath TEXT, date TEXT, amount REAL, isInput INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    _transactions.add(transaction);
    notifyListeners();

    await _db?.insert(
      'transactions',
      {
        'id': transaction.id,
        'title': transaction.title,
        'description': transaction.description,
        'imagePath': transaction.imagePath,
        'date': transaction.date.toIso8601String(),
        'amount': transaction.amount,
        'isInput': transaction.isInput ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> fetchTransactions() async {
    final List<Map<String, dynamic>> maps = await _db?.query('transactions') ?? [];

    _transactions = List.generate(maps.length, (i) {
      return TransactionEntity(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        imagePath: maps[i]['imagePath'],
        date: DateTime.parse(maps[i]['date']),
        amount: maps[i]['amount'],
        isInput: maps[i]['isInput'] == 1,
      );
    });

    notifyListeners();
  }

  Map<String, List<TransactionEntity>> groupTransactionsByMonth() {
    Map<String, List<TransactionEntity>> groupedTransactions = {};

    for (var transaction in _transactions) {
      String month = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
      if (!groupedTransactions.containsKey(month)) {
        groupedTransactions[month] = [];
      }
      groupedTransactions[month]!.add(transaction);
    }

    return groupedTransactions;
  }
}