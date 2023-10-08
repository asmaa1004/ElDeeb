import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_info.dart';
import 'api_link.dart';
import 'package:package_info_plus/package_info_plus.dart';

class APIManger{
  static String appInfoIsMandatory = "" ;
  static String appVersion = "" ;
  static String appCurrentVersion = "" ;

  static Future<AppInfo> getAppInfo() async {
    Map<String, String> data = {"CoName":"DeebQasasTex"};
    try{
      var response = await http.post(Uri.parse(appsSetting)
          ,body: data);
      var res = jsonDecode(response.body) ;

      AppInfo appInfo = AppInfo(version: res["data"][0]["Version"], isMandatory: res["data"][0]["IsMandatory"]);
       APIManger.appInfoIsMandatory = res["data"][0]["IsMandatory"];
       APIManger.appVersion = res["data"][0]["Version"];

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      APIManger.appCurrentVersion = packageInfo.version;

      return appInfo;

    }catch(e)
    {

    }
    return AppInfo(version: "", isMandatory: "");
  }
}