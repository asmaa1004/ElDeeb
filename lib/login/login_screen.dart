import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import '../api_link.dart';
import '../components/colors.dart';
import '../dll.dart';
import '../functions.dart';
import '../main.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with DLL{
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController userName =  TextEditingController();
  TextEditingController password =  TextEditingController();

  bool isLoading = false;
  bool isVisible = false;
  String userNameString = "المستخدم" ;


  void updateStatus() {
    setState(() {
      isVisible = !isVisible;
    });
  }


  loginFunction() async {

    try {
      if (formState.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        var response = await postRequest(

            apiLogin, {
              "UserName": userName.text,
              "UserPassWord": password.text,
        });
        //installedApps.toString()
        isLoading = false;
        setState(() {});
        if (response['status'] == "success") {
          sharedPref.setString("S_UserType", response['data'][0]['UserType']);

          if (sharedPref.getString("S_UserType") == '1') {
            sharedPref.setString("S_UserName", response["data"][0]["UserName"].toString());
            Navigator.of(context).pushNamedAndRemoveUntil("switch_screen", (route) => false);
          } else {
            sharedPref.setString("S_UserName", response["data"][0]["UserName"].toString());
            Navigator.of(context).pushNamedAndRemoveUntil("switch_screen_user", (route) => false);

          }

        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: true,
            title: 'خطأ',
            desc:
            "الكود او الرقم السري غير صحيح برجاء التأكد واعاده المحاوله",
            btnCancelOnPress: () {},
            btnCancelText: 'إلغاء',
            btnCancelColor: Colors.red,
          ).show();
        }
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        title: 'خطأ',
        desc:
        "الرجاء التأكد من الاتصال بالإنترنت",
        btnCancelOnPress: () {},
        btnCancelText: 'إلغاء',
        btnCancelColor: Colors.red,
      ).show();
    }
  }

  Future<String> _get()  async {
      final prefs = await SharedPreferences.getInstance();
      var userSave = prefs.getString("S_UserName") ?? "";
      return userSave;

  }

  @override
  void initState() {
    super.initState();
    _get();
    APIManger.getAppInfo().then((value) =>
        this.checkApp()
    );
  }

  void checkApp(){
    if(APIManger.appInfoIsMandatory == "1"){
      if(APIManger.appVersion != APIManger.appCurrentVersion ){
        AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: true,
            title: 'تحذير',
            desc:
            "تم إصدار تحديث جديد بالرجاء تنزيله",
            btnOkOnPress: () {
              StoreRedirect.redirect(androidAppId: "com.MousaSoft.deebqasasstex",
                  iOSAppId: "585027354");
            },
            btnOkText: 'موافق',
            btnOkColor: kMainColor,
            dismissOnTouchOutside:false
        ).show();

      }
    }
    else{

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: kMainColor,
        leading: Container(
          padding: const EdgeInsets.all(5),
          child: Image.asset('assets/images/Logo.png',width: 50,height: 50,),
        ),
        title: const Text
          (
          "الديب تكس",
          //LastUpdate!,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),

      ),
      body: isLoading == true
          ? const Center(
        child: CircularProgressIndicator(),
      )
      :Center(
        child: SingleChildScrollView(
          child: Column(
            children:
            [
              Image.asset(
                  'assets/images/Logo.png',
                width: 100,
                height: 100,
              ),
              Container(
                padding: const EdgeInsets.all(50),
                child: Form(
                  key: formState,
                  child: Column(
                    children:
                    [
                      TextFormField(
                        controller:  userName,
                        validator: (val) {if ((val)!.isEmpty){return "المستخدم غير صحيح";}return null;} ,
                        enabled: true,
                        readOnly: false,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kMainColor,
                            ),
                          ),
                          labelText: 'المستخدم',
                          labelStyle: TextStyle(
                            color: kMainColor,
                          ),
                          prefixIcon: Icon(
                            Icons.account_box,
                            color: kMainColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: password,
                        validator: (val) {if ((val)!.isEmpty){return "الرقم السري غير صحيح";}return null;} ,
                        enabled: true,
                        readOnly: false,
                        obscureText: isVisible ? false : true,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kMainColor,
                            ),
                          ),
                          labelText: 'الرقم السري',
                          labelStyle: const TextStyle(
                            color: kMainColor,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: kMainColor,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                            icon:
                            Icon(
                                isVisible ? Icons.visibility : Icons.visibility_off,
                                color: kMainColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: 170.0,
                        height: 50,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            primary: Colors.white,
                            backgroundColor: kMainColor,
                            textStyle: const TextStyle(
                                fontSize: 20,
                            ),
                          ),
                          child: const Text(
                            'تسجيل الدخول',
                          ),
                          onPressed: () async {
                            await loginFunction();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
