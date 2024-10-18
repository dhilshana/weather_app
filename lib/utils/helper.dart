import 'package:intl/intl.dart';

class Helper {
  String dateConverter(DateTime date){

    final dateFormatter = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormatter.format(date);

    return formattedDate;

  }

  String timeConverter(DateTime time){
    final timeFormatter = DateFormat('h:mm a');
    final formattedTime = timeFormatter.format(time);

    return formattedTime;
  }
}