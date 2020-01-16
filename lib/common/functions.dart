import 'package:intl/intl.dart';

class Functions {
  String timeAgo(DateTime time) {
    String res;
    DateTime now = DateTime.now();
    Duration diff = now.difference(time);
    if (time.year == now.year) {
      if (time.month == now.month) {
        if (diff.inSeconds < 60) {
          res = 'Just now';
        } else if (diff.inMinutes < 60) {
          res = diff.inMinutes > 1
              ? '${diff.inMinutes} minutes ago'
              : '${diff.inMinutes} minute ago';
        } else if (diff.inHours < 24) {
          res = diff.inHours > 1
              ? '${diff.inHours} hours ago'
              : '${diff.inHours} hour ago';
        } else if (diff.inDays < 365) {
          res = diff.inDays > 1
              ? '${diff.inDays} days ago'
              : '${diff.inDays} day ago';
        }
      } else {
        res = DateFormat.MMMMd("en_US").format(time);
      }
    } else {
      res = DateFormat.yMMMMd("en_US").format(time);
    }

    return res;
  }
}
