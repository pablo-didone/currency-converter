import 'package:currency/widgets/card_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './widgets/currency_selector.dart';

const String APP_NAME = 'Currency Converter';
const String API_URL = 'http://api.openrates.io/latest?base=';

void main() => runApp(new MaterialApp(
      title: APP_NAME,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> rates;
  String baseCurrency = 'USD';
  String targetCurrency = 'GBP';
  double result = 0;
  bool isLoading = false;
  bool error = false;

  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    String url = '$API_URL$baseCurrency';

    setState(() {
      isLoading = true;
      error = false;
    });

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      setState(() {
        rates = data['rates'];
        isLoading = false;
      });

      _convert();
    } catch (_) {
      setState(() => error = true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _handleSelectCurrency(String valueChanged, String newCurrency) {
    if (valueChanged == 'base') {
      setState(() => baseCurrency = newCurrency);
    } else if (valueChanged == 'target') {
      setState(() => targetCurrency = newCurrency);
    }

    _loadRates();
  }

  void _convert() {
    final double newAmount = amountController.text.length > 0
        ? double.parse(amountController.text)
        : 0;
    final double newResult = newAmount * rates[targetCurrency];

    setState(() {
      result = newResult;
    });
  }

  void _swap() {
    final newBaseCurrency = targetCurrency;

    setState(() {
      targetCurrency = baseCurrency;
      baseCurrency = newBaseCurrency;
    });

    _loadRates();
  }

  List<String> get currencyList {
    List<String> result = [];
    rates.forEach((currencyName, value) => result.add(currencyName));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: error
          ? Center(
              child: Text('An error occured, try again'),
            )
          : rates == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : null,
                    ),
                    CardLayout(
                      child: Column(children: <Widget>[
                        CurrencySelector(
                          selectedCurrency: baseCurrency,
                          currecyList: currencyList,
                          onSelectCurrency: (newCurrency) =>
                              _handleSelectCurrency('base', newCurrency),
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Amount'),
                          controller: amountController,
                          onChanged: (_) => _convert(),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        )
                      ]),
                    ),
                    CardLayout(
                      child: Column(
                        children: <Widget>[
                          CurrencySelector(
                            selectedCurrency: targetCurrency,
                            currecyList: currencyList,
                            onSelectCurrency: (newCurrency) =>
                                _handleSelectCurrency('target', newCurrency),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Text(
                              result.toStringAsFixed(2),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: IconButton(
                        icon: Icon(Icons.swap_vert),
                        color: Theme.of(context).primaryColor,
                        iconSize: 36,
                        onPressed: _swap,
                      ),
                    )
                  ],
                ),
    );
  }
}
