import 'package:jjewellery/main_common.dart';

class Endpoints {
  // static const String baseUrl = String.fromEnvironment('baseUrl');
  // static const String jewelleryRateUrl = 'jewelleryRateUrl';

  static String baseUrl = "http://${prefs.getString("Ip") ?? ""}/api/";
  // static String baseUrl = "http://192.168.18.157:5111/api/";
  static const String jewelleryRateUrl =
      "https://matrikatec.com.np/GoldHistory.php";
}
