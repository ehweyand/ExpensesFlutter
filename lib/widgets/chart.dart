import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      // pegar a inicial de cada dia da semana
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      // calcular o total de despesas no dia específico
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      }; //retorna um mapa
    }).reversed.toList();
  } //retornando a lista ao contrário, para alterar a ordem dos dias nas barras do gráfico

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    }); //transforma a lista em outro tipo de acordo com uma lógica, o valor retornado será adicionado ao 0.0 e calculado e retornado no final do procedimento
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      //Padding é a versão apenas para Padding, mais simples do widget Container
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //mapear em uma lista de widgets
          children: groupedTransactionValues.map((data) {
            //retorna o widget
            //Flexible usado para não quebrar o layout, distribuir o espaço
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                //para evitar a divisão por zero, caso não tenha transação:
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
