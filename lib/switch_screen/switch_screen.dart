import 'package:flutter/material.dart';
import '../data_tables/customers_balance.dart';
import '../data_tables/customer_activation.dart';
import '/change_password/change_password.dart';
import '/data_tables/fin_stock.dart';
import '/data_tables/thread_stock.dart';
import '/data_tables/fab_stock.dart';
import '../components/colors.dart';

class SwitchScreen extends StatefulWidget {
  const SwitchScreen({Key? key}) : super(key: key);

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "الرئيسيه",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 7, top: 25),
            height: 104,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 17),
            child: Container(
              padding: const EdgeInsets.only(
                right: 10,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.yellow, kMainColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0, 0.6],
                  tileMode: TileMode.repeated,
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: kMainColor.withOpacity(0.3),
                      offset: const Offset(-7.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      AssetImage("assets/images/thread.jpg"),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ThreadStock(),
                          ),
                        );
                      },
                      child: const Text(
                        'رصيد الخيوط',
                        style: TextStyle(
                            color: Color(0xFFe0e0e0),
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
            height: 104,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 17),
            child: Container(
              padding: const EdgeInsets.only(
                right: 10,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.yellow, kMainColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0, 0.6],
                  tileMode: TileMode.repeated,
                ),
                //color: Color(0xff7B89CA),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: kMainColor.withOpacity(0.3),
                      offset: const Offset(-7.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 3.0),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage("assets/images/RawStore.jpg"),
                    ),
                  ),
                  const SizedBox(width: 25,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FabStock(),
                          ),
                        );
                      },
                      child: const Text(
                        'رصيد الخام',
                        style: TextStyle(
                            color: Color(0xFFe0e0e0),
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
            height: 104,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 17),
            child: Container(
              padding: const EdgeInsets.only(
                right: 10,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.yellow, kMainColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0, 0.6],
                  tileMode: TileMode.repeated,
                ),
                //color: Color(0xff7B89CA),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: kMainColor.withOpacity(0.3),
                      offset: const Offset(-7.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 3.0),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/FinishedStock.png"),
                    ),
                  ),
                  const SizedBox(width: 25,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FinStock(),
                          ),
                        );
                      },
                      child: const Text(
                        'رصيد الجاهز',
                        style: TextStyle(
                            color:  Color(0xFFe0e0e0),
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
            height: 104,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 17),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.yellow, kMainColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0, 0.6],
                  tileMode: TileMode.repeated,
                ),
                //color: Color(0xff7B89CA),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: kMainColor.withOpacity(0.3),
                      offset: const Offset(-7.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 3.0),
                ],
              ),
              padding: const EdgeInsets.only(
                right: 10,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/11.jpg"),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomersBalance(),
                          ),
                        );
                      },
                      child:  const Text(
                        'حساب العملاء',
                        style: TextStyle(
                            color: Color(0xFFe0e0e0),
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
            height: 104,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 17),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.yellow, kMainColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0, 0.6],
                  tileMode: TileMode.repeated,
                ),
                //color: Color(0xff7B89CA),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: kMainColor.withOpacity(0.3),
                      offset: const Offset(-7.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 3.0),
                ],
              ),
              padding: const EdgeInsets.only(
                right: 10,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: const CircleAvatar(
                      backgroundImage:
                      AssetImage("assets/images/11.jpg"),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerActivation(),
                          ),
                        );
                      },
                      child:  const Text(
                        'تفعيل عميل',
                        style: TextStyle(
                            color: Color(0xFFe0e0e0),
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
            height: 104,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 17),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.yellow, kMainColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0, 0.6],
                  tileMode: TileMode.repeated,
                ),
                //color: Color(0xff7B89CA),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: kMainColor.withOpacity(0.3),
                      offset: const Offset(-7.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 3.0),
                ],
              ),
              padding: const EdgeInsets.only(
                right: 10,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/12.png"),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'تغيير كلمه السر',
                        style: TextStyle(
                            color: Color(0xFFe0e0e0),
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
