import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin.dart';
import 'package:bitcoinchallenge/network_helper.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double btcPrice = 0;
  double btcValue = 0;
  String Currency = "USD";
  bool isWaiting = false;
  String? dropdownValue = "USD";
  Map<String, String> coinValues = {};
  List<DropdownMenuItem> getDropDownItems() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String str in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(str), value: str);
      dropDownItems.add(newItem);
    }
    return dropDownItems;
  }

  @override
  Widget build(BuildContext context) {
    CallApi fetch = CallApi();
    getDropDownItems();
    return Scaffold(
      appBar: AppBar(
        title: (Text('🤑 Coin Ticker')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (String crypo in cryptoList)
            currenciesCard(
                crypto: crypo,
                btcValue: coinValues[crypo].toString(),
                Currency: Currency),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: DropdownButton(
                isExpanded: true,
                dropdownColor: Colors.black45,
                icon: const Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                elevation: 16,
                style: const TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
                items: getDropDownItems(),
                onChanged: (value) async {
                  isWaiting = true;
                  dropdownValue = value as String;
                  var response = await fetch.fetchPriceForSingle(value);
                  Currency = value;
                  coinValues = response;
                  isWaiting = false;
                  print(coinValues);
                  setState(() {
                    value = dropdownValue;
                  });
                },
                value: dropdownValue,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class currenciesCard extends StatelessWidget {
  const currenciesCard(
      {Key? key,
      required this.btcValue,
      required this.Currency,
      required this.crypto})
      : super(key: key);
  final String crypto;
  final String btcValue;
  final String Currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $btcValue $Currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
