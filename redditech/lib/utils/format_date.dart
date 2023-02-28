import 'package:localization/localization.dart';

abstract class FormatDate {
  static String toDateTime(createdUtc) {
    var dateTime =
        DateTime.fromMillisecondsSinceEpoch(createdUtc.round() * 1000);
    var compare = DateTime.now().difference(dateTime);
    if (compare.inHours == 0) {
      return "${compare.inMinutes}min";
    }
    if (compare.inDays > 0) {
      return "${compare.inDays}${'day'.i18n()} ${(compare.inHours % 24)}h";
    }
    return "${compare.inHours}h";
  }
}
