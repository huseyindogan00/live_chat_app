// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

class TimeModel {
  final String _baseUrl = 'worldtimeapi.org/api/timezone/Europe/Istanbul';

  static Future<DateTime?> getCurrentTime() async {
    http.Response response = await http
        .get(Uri.https('worldtimeapi.org', '/api/timezone/Europe/Istanbul'));
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return DateTime.parse(map['datetime']);
    }
    return null;
  }
}


/* {
  "abbreviation": "+03",
  "client_ip": "78.161.246.158",
  "datetime": "2023-02-18T13:22:35.145652+03:00",
  "day_of_week": 6,
  "day_of_year": 49,
  "dst": false,
  "dst_from": null,
  "dst_offset": 0,
  "dst_until": null,
  "raw_offset": 10800,
  "timezone": "Europe/Istanbul",
  "unixtime": 1676715755,
  "utc_datetime": "2023-02-18T10:22:35.145652+00:00",
  "utc_offset": "+03:00",
  "week_number": 7
} */