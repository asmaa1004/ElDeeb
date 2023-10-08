import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '/api_link.dart';
import '/dll.dart';
import '/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../components/colors.dart';



class ThreadStock extends StatefulWidget {
  const ThreadStock({Key? key}) : super(key: key);

  @override
  State<ThreadStock> createState() => _ThreadStockState();
}

class _ThreadStockState extends State<ThreadStock> with DLL {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  // ignore: non_constant_identifier_names
  ListItem? _newValue_CustomersData;
  // ignore: non_constant_identifier_names
  List<DropdownMenuItem<ListItem>> newDropdownMenuItem_CustomersData = [];

  List<dynamic> customersData = [];

  bool isLoading = false;

  bool isOwner = false;

  String thStoreCode = "ALL";

  late Timer _timer;

  loadStores() async {
    try {
      isLoading = true;
      setState(() {});
      var response = await postRequest(
          apiThStoreCoding, {"ThStoreCode": sharedPref.getString("S_ThStoreCode").toString()});

      if (response['status'] == "success") {
        customersData = response["data"];
        for (var element in customersData) {
          newDropdownMenuItem_CustomersData.add(
            DropdownMenuItem(
              child: Text(element["ThStoreName"]),
              value: ListItem(
                element["ThStoreCode"],
                element["ThStoreName"],
              ),
            ),
          );
        }

        isLoading = false;
        setState(() {});
      } else {
        AwesomeDialog(
                context: context,
                showCloseIcon: true,
                title: "Alert",
                body: const Text("Can't Load Data"))
            .show();
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

  @override
  void initState() {
    super.initState();
    loadStores();
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
              "رصيد الخيوط",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        body: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: kMainColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: kMainColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ListItem>(
                            isExpanded: true,
                            hint: const Text(
                              "اختر المخزن",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            value: _newValue_CustomersData,
                            items: newDropdownMenuItem_CustomersData,
                            onChanged: (value) async {
                              setState(() {
                                isLoading = true;
                                _newValue_CustomersData = value;
                                  _timer = Timer(const Duration(milliseconds: 200), () {
                                    setState(() {
                                      if (value != null) {
                                        if (value.thStoreCode != null) {
                                          if (value.thStoreCode != "0") {
                                            thStoreCode = value.thStoreCode!;
                                          } else {
                                            thStoreCode = "ALL";
                                          }
                                        }
                                      }
                                      isLoading = false;
                                    });
                                  });

                              });
                            }),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.88,
                      child: FutureBuilder(
                        future: getProductDataSource(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return SfDataGridTheme(
                                  data: SfDataGridThemeData(
                                    headerColor: kMainColor,
                                    selectionColor: Colors.grey,
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: SfDataGrid(
                                        source: snapshot.data,
                                        key: _key,
                                        columns:
                                        getColumns(snapshot),
                                        allowPullToRefresh: true,
                                        allowSorting: true,
                                        rowHeight: MediaQuery.of(context).size.height * 0.089,
                                        selectionMode: SelectionMode.multiple,
                                        gridLinesVisibility: GridLinesVisibility.both,
                                        headerGridLinesVisibility: GridLinesVisibility.both,
                                        ),
                                  ),
                                );
                          }else {
                            return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    color: kMainColor,
                                  ),
                                );
                          }
                        },
                      ),
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

  List<GridColumn> getColumns( AsyncSnapshot<dynamic> snapshot ) {

    ProductDataGridSource dataSource = snapshot.data ;

    if (dataSource.productList.length != 0 ){
      return <GridColumn>[
        GridColumn(
            columnName: 'ThStoreName',
            width: MediaQuery.of(context).size.width * 0.4,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text('المخزن',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.clip,
                    softWrap: true))),
        GridColumn(
            columnName: 'ThName',
            width: MediaQuery.of(context).size.width * 0.35,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                  'الخيط',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
        GridColumn(
            columnName: "ThType",
            width: MediaQuery.of(context).size.width * 0.3,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                  "النوع",
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
        GridColumn(
            columnName: 'ThNo',
            width: MediaQuery.of(context).size.width * 0.17,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                  'النمره',
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
        GridColumn(
            columnName: 'Unit',
            width: MediaQuery.of(context).size.width * 0.15,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                  'الوحده',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
        GridColumn(
            columnName: 'SQ',
            width: MediaQuery.of(context).size.width * 0.3,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text('الرصيد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.clip,
                    softWrap: true))),
      ];
    }
    else{
      return<GridColumn>[
        GridColumn(
            columnName: '',
            width: MediaQuery.of(context).size.width + 4 ,
            label: Container(
                padding: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                color: Colors.white,
                child: const Text(
                    "لا يوجد رصيد بالمخزن المختار",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kMainColor,
                    ),
                    ))),
      ] ;
    }


  }

  Future<List<Product>> generateProductList() async {
    List<Product> productList = [];
    var response =
        await postRequest(apiThStock, {"WHCode": thStoreCode});

    for (var item in response["data"]) {
      Product current = Product(
          thStoreName: item['ThStoreName'] ?? "",
          thName: item['ThName'] ?? "",
          thType: item['ThType'] ?? "",
          thNo: item['ThNo'] ?? "",
          unit: item['Unit'] ?? "",
          sq: item['SQ'] ?? "",
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
          textDirection: TextDirection.rtl,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(4.0),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.visible,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value,
          textDirection: TextDirection.rtl,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value,
          textDirection: TextDirection.rtl,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            row.getCells()[4].value,
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            row.getCells()[5].value,
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'ThStoreName', value: dataGridRow.thStoreName),
        DataGridCell<String>(columnName: 'ThName', value: dataGridRow.thName),
        DataGridCell<String>(columnName: 'ThType', value: dataGridRow.thType),
        DataGridCell<String>(columnName: 'ThNo', value: dataGridRow.thNo),
        DataGridCell<String>(columnName: 'Unit', value: dataGridRow.unit),
        DataGridCell<String>(columnName: 'SQ', value: dataGridRow.sq),
      ]);
    }).toList(growable: false);
  }
}

class Product {
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      thStoreName: json["ThStoreName"],
      thName: json["ThName"],
      thType: json["ThType"],
      thNo: json["ThNo"],
      unit: json["Unit"],
      sq: json["SQ"]);
  }
  Product({
    required this.thStoreName,
    required this.thName,
    required this.thType,
    required this.thNo,
    required this.unit,
    required this.sq,
  });

  final String thStoreName;
  final String thName;
  final String thType;
  final String thNo;
  final String unit;
  final String sq;
}

class ListItem {
  String? thStoreCode;
  String? thStoreName;
  ListItem(this.thStoreCode, this.thStoreName);
}
