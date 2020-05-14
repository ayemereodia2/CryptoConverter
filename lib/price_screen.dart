import 'package:bitcoin_ticker/service.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'convert.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double rate = 0.0;
  double rate1 = 0.0;
  double rate2 = 0.0;

  Service api = Service();

  String selectedCurrency = 'USD';

  List<DropdownMenuItem> getDropDownList() {

  }

  List<Text> getCupertinoDropDownList() {
    List<Text> dropDownWidget = [];
    for (String currencyItem in currenciesList) {
      dropDownWidget.add(Text(currencyItem));
    }
    return dropDownWidget;
  }

  DropdownButton<String> androidDropDown() {

    List<DropdownMenuItem<String>> dropDownWidget = [];
    for (String currencyItem in currenciesList) {
      dropDownWidget.add(DropdownMenuItem(
        child: Text(currencyItem),
        value: currencyItem,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownWidget,
      onChanged: (string) {
        print(string);
        setState(() {
          selectedCurrency = string;
        });
      },
    );
  }

  void convert(Convert resp, String symbol, String bitcoinSymbol){
    setState(() {
      if(bitcoinSymbol == 'BTC'){
        rate = resp.rate ?? 0.0;
      }else if(bitcoinSymbol == 'ETH'){
        rate1 = resp.rate ?? 0.0;
      }else{
        rate2 = resp.rate ?? 0.0;
      }
     selectedCurrency = symbol;
    });
  }

  CupertinoPicker iOSPicker (){

    List<Text> dropDownWidget = [];
    for (String currencyItem in currenciesList) {
      dropDownWidget.add(Text(currencyItem));
    }
   return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (itemIndex) async {
        String symbol = currenciesList[itemIndex];
        Convert resp = await api.getLatestConversion('BTC', symbol);
        convert(resp,symbol,'BTC');
        Convert resp0 = await api.getLatestConversion('ETH', symbol);
        convert(resp0,symbol,'EHT');
        Convert resp1 = await api.getLatestConversion('LTC', symbol);
        convert(resp1,symbol,'LTC');
      },
      children: dropDownWidget,
    );
  }

  Widget selectPicker(){
    if(Platform.isIOS){
      return iOSPicker();
    }else{
      return androidDropDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CryptoWidgets(rate: rate.toInt(), selectedCurrency: selectedCurrency, cryptoSymbol: 'BTC',),
                CryptoWidgets(rate: rate1.toInt(), selectedCurrency: selectedCurrency, cryptoSymbol: 'ETH',),
                CryptoWidgets(rate: rate2.toInt(), selectedCurrency: selectedCurrency, cryptoSymbol: 'LTC',),
              ],
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropDown(),),
        ],
      ),
    );
  }
}

class CryptoWidgets extends StatelessWidget {
  const CryptoWidgets({
    Key key,
    @required this.rate,
    @required this.selectedCurrency,
    @required this.cryptoSymbol
  }) : super(key: key);

  final int rate;
  final String selectedCurrency;
  final String cryptoSymbol;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoSymbol = ? $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
