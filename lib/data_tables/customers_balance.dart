import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/api_link.dart';
import '/dll.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../components/colors.dart';

class CustomersBalance extends StatefulWidget {
  const CustomersBalance({Key? key}) : super(key: key);

  @override
  State<CustomersBalance> createState() => _CustomersBalanceState();
}

class _CustomersBalanceState extends State<CustomersBalance> with DLL {

  bool isLoading = false;

  String limit = "0";

  String valueText = "" ;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

  }

  final items = [];

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
              "كشف حساب العملاء",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        body: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
          child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              margin: const EdgeInsets.all(8),
                              child: TextField (

                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                onChanged: (value){
                                  valueText = value;
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                        color: kMainColor,
                                      ),
                                        borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: valueText == "" ? 'حد المديونيه' : valueText ,
                                    labelStyle: const TextStyle(
                                    color: kMainColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.28,
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
                                  'عرض',
                                ),
                                onPressed: (){
                                  setState(() {
                                    isLoading = true;
                                    _timer = Timer(const Duration(milliseconds: 200), () {
                                      setState(() {
                                        limit = valueText;
                                        isLoading = false;
                                      });
                                    });

                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                              height: MediaQuery.of(context).size.height * 0.88,
                              width: MediaQuery.of(context).size.width,
                              child: FutureBuilder(
                                future: getProductDataSource(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return snapshot.hasData
                                      ? SfDataGridTheme(
                                          data: SfDataGridThemeData(
                                            headerColor: kMainColor,
                                            selectionColor: Colors.grey,
                                          ),
                                          child: SfDataGrid(
                                              source: snapshot.data,
                                              columns: getColumns(),
                                              allowPullToRefresh: true,
                                              allowSorting: true,
                                              rowHeight:
                                                  MediaQuery.of(context).size.height *
                                                      0.08,
                                              selectionMode: SelectionMode.multiple,
                                              gridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              headerGridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              ),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 4,
                                            color: kMainColor,
                                          ),
                                        );
                                },
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    var productList = await generateProductList();
    return ProductDataGridSource(productList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'AccCode',
          width: MediaQuery.of(context).size.width * 0.35,
          label: Container(
              padding: const EdgeInsets.all(2),
              alignment: Alignment.center,
              child: const Text('الكود',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.clip,
                  softWrap: true))),
      GridColumn(
          columnName: 'AccDesc',
          width: MediaQuery.of(context).size.width * 0.5,
          label: Container(
              padding: const EdgeInsets.all(2),
              alignment: Alignment.center,
              child: const Text(
                'العميل',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ))),
      GridColumn(
          columnName: "DateInOut",
          width: MediaQuery.of(context).size.width * 0.4,
          label: Container(
              padding: const EdgeInsets.all(2),
              alignment: Alignment.center,
              child: const Text(
                "تاريخ أخر دفعه",
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ))),
      GridColumn(
          columnName: "Credit",
          width: MediaQuery.of(context).size.width * 0.4,
          label: Container(
              padding: const EdgeInsets.all(2),
              alignment: Alignment.center,
              child: const Text(
                "مبلغ أخر دفعه",
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ))),
      GridColumn(
          columnName: 'SP',
          width: MediaQuery.of(context).size.width * 0.4,
          label: Container(
              padding: const EdgeInsets.all(2),
              alignment: Alignment.center,
              child: const Text(
                'الرصيد',
                overflow: TextOverflow.visible,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ))),
    ];
  }

  Future<List<Product>> generateProductList() async {
    List<Product> productList = [];
    var response =
        await postRequest(apiCustomerBalance, {"LimitV": limit});

    for (var item in response["data"]) {
      Product current = Product(
        accDesc: item['AccDesc'] ?? "",
        accCode: item['AccCode'] ?? "",
        sp: item['SP'] ?? "",
        dateInOut: item['DateInOut'] ?? "           ",
        credit: item['Credit'] ?? "",

      );

      productList.add(current);
    }
    return productList;
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<Product> productList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(5.0),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          row.getCells()[2].value.substring(0,11),
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          row.getCells()[3].value,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            row.getCells()[4].value,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          )),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'AccCode', value: dataGridRow.accCode),
        DataGridCell<String>(columnName: 'AccDesc', value: dataGridRow.accDesc),
        DataGridCell<String>(columnName: 'DateInOut', value: dataGridRow.dateInOut),
        DataGridCell<String>(columnName: 'Credit', value: dataGridRow.credit),
        DataGridCell<String>(columnName: 'SP', value: dataGridRow.sp),
      ]);
    }).toList(growable: false);
  }
}

class Product {
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      accDesc: json["AccDesc"],
      accCode: json["AccCode"],
      sp: json["SP"],
      dateInOut: json["DateInOut"],
      credit: json["Credit"],
    );
  }
  Product({
    required this.accDesc,
    required this.accCode,
    required this.sp,
    required this.dateInOut,
    required this.credit,
  });

  final String accDesc;
  final String accCode;
  final String sp;
  final String dateInOut;
  final String credit;
}

class ListItem {
  String? cusCode;
  String? cusName;
  ListItem(this.cusCode, this.cusName);
}
