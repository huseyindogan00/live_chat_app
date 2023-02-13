import 'package:cloud_firestore/cloud_firestore.dart';

String getDateTimeMessageFormat(Timestamp? timestamp) {
  String munite;
  String hour;
  String day;
  String month;
  String year;

  if (timestamp == null) {
    return '';
  }
  munite = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).minute.toString();
  hour = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).hour.toString();
  day = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).day.toString();
  month = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).month.toString();
  year = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).year.toString();

  if (munite.length == 1) munite = '0$munite';

  return '$hour:$munite $day/$month/$year';
}
