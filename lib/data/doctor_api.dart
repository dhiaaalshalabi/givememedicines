import 'dart:async';

import 'package:http/http.dart' as http;

class DoctorApi {
  static Future getDoctors(List<int> ids) {
    return http
        .get(Uri.parse('http://192.168.56.1:8000/api/doctors/?ids=$ids'));
  }
}
