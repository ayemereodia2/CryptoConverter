import 'dart:convert';

import 'package:bitcoin_ticker/convert.dart';
import 'package:http/http.dart' as http;

class Service {
final String apiKey = '4941DA24-DE02-4132-B2C5-3846FB992110';
  Future<Convert> getLatestConversion(String bitcoinSymbol,  String currencySymbol) async {
    String url = 'https://rest.coinapi.io/v1/exchangerate/$bitcoinSymbol/$currencySymbol?apikey=$apiKey';
print(url);
    try{
      print('firing');
      var response = await http.get(url);
      if(response.statusCode == 200){
        var convertJson = json.decode(response.body);
        Convert resp = Convert();
        resp.date = convertJson['date'];
        resp.asset_id_base = convertJson['asset_id_base'];
        resp.asset_id_quote = convertJson['asset_id_quote'];
        resp.rate = convertJson['rate'];

        print(convertJson);
          return resp;
      }else{
          return Convert();
      }
    }
    catch(e){
      print(e);
      return Convert();
    }
  }
}
