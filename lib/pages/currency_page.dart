import 'package:flutter/material.dart';
import 'package:project_manga/theme/colors.dart';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  double _rupiah = 0;
  double _dollar = 0;
  double _yen = 0;
  double _euro = 0;

  void _convertCurrency() {
    setState(() {
      _dollar = _yen / 140; // 1 Dollar = 140 yen
      _rupiah = _yen / 0.01; // 1 Rupiah = 0.01 Yen
      _euro = _yen / 150; // 1 Euro = 150 Yen

      _dollar = double.parse(_dollar.toStringAsFixed(2));
      _rupiah = double.parse(_rupiah.toStringAsFixed(2));
      _euro = double.parse(_euro.toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Convert Currency',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount in Yen',
              ),
              onChanged: (value) {
                setState(() {
                  _yen = double.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: Text('Convert'),
            ),
            SizedBox(height: 24),
            Text(
              'Dollar: \$$_dollar',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Rupiah: RP$_rupiah',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Euro: €$_euro',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
