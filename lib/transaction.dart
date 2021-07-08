import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart'; // por causa do @required

class Transaction {
  // runtime constant, pega o valor quando instanciado, mas, não altera posteriormente.
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  //named arguments constructor
  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });
}
