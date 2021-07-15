import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Precisa ser statefull por que internamente o flutter re avalia o widget internamente
// e assim perde as informações digitadas caso permanecer como stateless
class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // Controlar os inputs e a recuperação dos textos dos campos de texto.
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    //Validação básica
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    // Recebi o ponteiro da função no construtor
    // Posso chamar ela

    // -- widget.addTx -- por que se trata de um stateful, e a função e construtor estão no NewTransaction Widget, e não no State (este bloco)
    // é uma propriedade que podemos acessar propriedades e métodos da nossa classe widget.
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    //Fecha a tela mais em cima (no caso, uma modal por exemplo)
    // context está disponível por que extendeu State
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return; //usuário apertou cancel
      }

      //para rebuildar a UI e ver a alteração no texto para a data nova
      setState(() {
        _selectedDate = pickedDate;
      });

      //usar a data em nosso app.
    }); //then é executado quando o Future receber um valor, isso é, quando o usuário escolher um valor

    //showDatePicker retorna um objeto do tipo Future, que será preenchido posteriormente quando o usuário escolher a data
  }

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
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountController,
              // onChanged: (val) => amountInput = val,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              //_ significa aqui que vai receber um param mas não irá usar
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    //Expanded ou flexible e a propriedade FlexFit tight
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _presentDatePicker,
                  )
                ],
              ),
            ),
            RaisedButton(
              child: Text('Add Transaction'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
