import 'dart:convert';
import 'package:http/http.dart' as http;
import 'coin.dart';

class CallApi {
  List<String> cryptList = [
    'BTC',
    'ETH',
    'LTC',
  ];
  static const apiKey = "";
  static const rooturl = "https://rest.coinapi.io/v1/exchangerate/";

  Future fetchPriceForSingle(String currency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptList) {
      var url = rooturl + crypto + '/' + currency + apiKey;
      http.Response resp = await http.get(Uri.parse(url));
      var respData = resp.body;
      if (resp.statusCode == 200) {
        var decodedData = jsonDecode(respData);
        double price = decodedData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(2);
      } else {
        return resp.statusCode;
      }
    }
    return cryptoPrices;
  }
}
