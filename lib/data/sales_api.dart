import 'dart:async';

import 'package:http/http.dart' as http;

class SalesApi {
  static Future postSale(body) {
    print('oooooooo $body');
    return http.post(Uri.parse('http://192.168.56.1:8000/api/sales/'),
        body: body);
  }

  static Future postSaleMedicine(body) {
    return http.post(Uri.parse('http://192.168.56.1:8000/api/sales_medicines/'),
        body: body);
  }
}
