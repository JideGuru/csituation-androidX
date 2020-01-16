import 'package:college_situation/common/my_strings.dart';

class MyUtils {
  static bool isValidEmail(String email) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+"; 
    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email); 
  } 

  static String buildUrl(String endpoint, {Map<String, String> params}) {
    return new Uri.https(Strings.apiDomain, 'api/v1/$endpoint', params).toString();
  }
}