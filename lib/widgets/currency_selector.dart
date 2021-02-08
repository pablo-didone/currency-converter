import 'package:flutter/material.dart';

class CurrencySelector extends StatelessWidget {
  final String selectedCurrency;
  final List<String> currecyList;
  final Function onSelectCurrency;

  CurrencySelector({
    @required this.selectedCurrency, 
    @required this.currecyList, 
    @required this.onSelectCurrency
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          selectedCurrency,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        DropdownButton(
          value: selectedCurrency,
          onChanged: onSelectCurrency,
          items: currecyList.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
