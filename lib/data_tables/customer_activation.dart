import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../api_link.dart';
import '../components/colors.dart';
import '../dll.dart';
import '../models/users.dart' show Data, Users;
import 'package:http/http.dart' as http;

class CustomerActivation extends StatefulWidget {
  const CustomerActivation({Key? key}) : super(key: key);

  @override
  State<CustomerActivation> createState() => _CustomerActivationState();
}

class _CustomerActivationState extends State<CustomerActivation> with DLL {
  GlobalKey<FormState> formState = GlobalKey();

  String user = "";
  TextEditingController userPass = TextEditingController();

  Users? users;

  bool isLoading = false;

  insert() async {

    try {
      if (formState.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        var response =
            await postRequest("$linkServerName/AddUser/InsertUser.php", {
                  "UserName": user,
                  "UserPassword": userPass.text,
        });
        isLoading = false;
        setState(() {});
        if (response['status'] == "Success") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: true,
            title: "",
            desc: 'تم الارسال',
            descTextStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            btnCancelOnPress: () {
              user = "";
              userPass.text = "";
              },
            btnCancelText: 'تم',
            btnCancelColor: kMainColor,
          ).show();
        } else {
          AwesomeDialog(
                  context: context,
                  showCloseIcon: true,
                  title: "Alert",
                  body: const Text("تعذر اضافه العميل"))
              .show();
        }
      }
    } catch (e) {
      AwesomeDialog(
              context: context,
              showCloseIcon: true,
              title: "Alert",
              body: Text(e.toString()))
          .show();
    }
  }

  void _getUsers() async {
    var response = await http
        .post(Uri.parse("$linkServerName/AddUser/Users.php"));

    setState(() {
      users = Users.fromJson(json.decode(response.body));
    });
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: kMainColor,
          actions: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/images/Logo.png',
                width: 50,
                height: 50,
              ),
            ),
          ],
          title: const Center(
            child: Text(
              "تفعيل عميل",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        body:  Center(
          child: SingleChildScrollView(
                  child: Form(
                    key: formState,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(30),
                          child: Image.asset(
                            'assets/images/Logo.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 0),
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Autocomplete<Data>(
                            optionsMaxHeight: 300,
                            onSelected: (data) {
                              user = data.user;
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            optionsBuilder: (TextEditingValue value) {
                              return users!.data
                                  .where((element) => element.user
                                      .toLowerCase()
                                      .contains(value.text.toLowerCase()))
                                  .toList();
                            },
                            displayStringForOption: (Data d) => d.user,
                            fieldViewBuilder: (context, controller, focsNode,
                                onEditingComplete) {
                              return TextFormField(
                                textDirection: TextDirection.rtl,
                                controller: controller,
                                focusNode: focsNode,
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            const BorderSide(color: kMainColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            const BorderSide(color: kMainColor)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            const BorderSide(color: kMainColor)),
                                    hintText: "أختر العميل",
                                    hintStyle: const TextStyle(
                                        color: Colors.black, fontSize: 20.0),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: kMainColor,
                                    ),
                              ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(7),
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 0),
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: (TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: userPass,
                            decoration: InputDecoration(
                              labelText: 'الرقم السري',
                              labelStyle: const TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                //borderSide: const BorderSide(color: kMainColor)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: kMainColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: kMainColor)),
                            ),
                          )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
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
                              'إرسال',
                            ),
                            onPressed: () async {
                              await insert();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
