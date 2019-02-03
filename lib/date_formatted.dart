import 'package:intl/intl.dart';

String dateFormatted() {
  var now = DateTime.now();
  var formatter = DateFormat('MMMM d, ' 'yyyy At ');
  var formatTime = DateFormat('jm');
  var timeString = formatTime.format(now);
  String formatted = formatter.format(now);

  return formatted + timeString;
}
