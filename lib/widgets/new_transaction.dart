import 'package:flutter/material.dart';

// Precisa ser statefull por que internamente o flutter re avalia o widget internamente
// e assim perde as informações digitadas caso permanecer como stateless
class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    //Validação básica
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    // Recebi o ponteiro da função no construtor
    // Posso chamar ela

    // -- widget.addTx -- por que se trata de um stateful, e a função e construtor estão no NewTransaction Widget, e não no State (este bloco)
    // é uma propriedade que podemos acessar propriedades e métodos da nossa classe widget.
    widget.addTx(enteredTitle, enteredAmount);

    //Fecha a tela mais em cima (no caso, uma modal por exemplo)
    // context está disponível por que extendeu State
    Navigator.of(context).pop();
  }

  // Controlar os inputs e a recuperação dos textos dos campos de texto.
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      /*Se for usar apenas padding: -- O Widget: Padding() --*/
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: titleController,
              onSubmitted: (_) => submitData(),
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: amountController,
              // onChanged: (val) => amountInput = val,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              //_ significa aqui que vai receber um param mas não irá usar
              onSubmitted: (_) => submitData(),
            ),
            FlatButton(
              child: Text('Add Transaction'),
              textColor: Colors.purple,
              onPressed: submitData,
            ),
          ],
        ),
      ),
    );
  }
}
