import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '/api_link.dart';
import '/dll.dart';
import '/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../components/colors.dart';

class FinStock extends StatefulWidget {
  const FinStock({Key? key}) : super(key: key);

  @override
  State<FinStock> createState() => _FinStockState();

}

class _FinStockState extends State<FinStock> with DLL {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  ListItem? _newValue_CustomersData;
  List<DropdownMenuItem<ListItem>> newDropdownMenuItem_CustomersData = [];

  List<dynamic> customersData = [];

  bool isLoading = false;

  String finStoreCode = "ALL";

  late Timer _timer;

  loadStores() async {
    try {
      isLoading = true;
      setState(() {});
      var response = await postRequest(
          apiFinStoreCoding, {"FinStoreCode": sharedPref.getString("S_FinStoreCode").toString()});

      if (response['status'] == "success") {
        customersData = response["data"];

        for (var element in customersData) {
          newDropdownMenuItem_CustomersData.add(
            DropdownMenuItem(
              child: Text(element["FinStoreName"]),
              value: ListItem(
                element["FinStoreCode"],
                element["FinStoreName"],
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
              "رصيد الجاهز",
              style: TextStyle(fontSize: 18, color: Colors.white),
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
                                      if (value.finStoreCode != null) {
                                        if (value.finStoreCode != "0") {
                                          finStoreCode = value.finStoreCode!;
                                        } else {
                                          finStoreCode = "ALL";
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
                          return snapshot.hasData
                              ? SfDataGridTheme(
                                  data: SfDataGridThemeData(
                                    headerColor: kMainColor,
                                  ),
                                  child: SfDataGrid(
                                    source: snapshot.data,
                                    columns: getColumns(snapshot),
                                    key: _key,
                                    allowPullToRefresh: true,
                                    allowSorting: true,
                                    rowHeight:
                                    MediaQuery.of(context).size.height *
                                              0.089,
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
              ),
      ),
    );
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    var productList = await generateProductList();
    return ProductDataGridSource(productList);
  }

  List<GridColumn> getColumns( AsyncSnapshot<dynamic> snapshot ) {
    ProductDataGridSource dataSource = snapshot.data;

    if (dataSource.productList.length != 0) {
      return <GridColumn>[
        GridColumn(
            columnName: 'FinStoreName',
            width: MediaQuery
                .of(context)
                .size
                .width * 0.35,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                  'المخزن',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
        GridColumn(
            columnName: 'FName',
            width: MediaQuery
                .of(context)
                .size
                .width * 0.54,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                    'الخام',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.clip,
                    softWrap: true))),
        GridColumn(
            columnName: "ThType",
            width: MediaQuery
                .of(context)
                .size
                .width * 0.3,
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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.15,
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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.16,
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
            columnName: 'FAdd',
            width: MediaQuery
                .of(context)
                .size
                .width * 0.4,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                  'الإضافات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
        GridColumn(
            columnName: 'Color',
            width: MediaQuery
                .of(context)
                .size
                .width * 0.3,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                  'اللون',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
        GridColumn(
            columnName: 'SQ',
            width: MediaQuery
                .of(context)
                .size
                .width * 0.4,
            label: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: const Text(
                  'الرصيد',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
      ];
    }else{
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
    await postRequest(apiFinStock, {"WHCode": finStoreCode});

    for (var item in response["data"]) {
      Product current = Product(
        finStoreName: item['FinStoreName'] ?? "",
        fName: item['FName'] ?? "",
        thType: item['ThType'] ?? "",
        thNo: item['ThNo'] ?? "",
        unit: item['Unit'] ?? "",
        fAdd: item['FAdd'] ?? "",
        color: item['Color'] ?? "",
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
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
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
          row.getCells()[2].value,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            row.getCells()[4].value,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          )),
      Container(
        child: Text(
          row.getCells()[5].value,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[6].value,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[7].value,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'FinStoreName', value: dataGridRow.finStoreName),
        DataGridCell<String>(columnName: 'FName', value: dataGridRow.fName),
        DataGridCell<String>(columnName: 'ThType', value: dataGridRow.thType),
        DataGridCell<String>(columnName: 'ThNo', value: dataGridRow.thNo),
        DataGridCell<String>(columnName: 'Unit', value: dataGridRow.unit),
        DataGridCell<String>(columnName: 'FAdd', value: dataGridRow.fAdd),
        DataGridCell<String>(columnName: 'Color', value: dataGridRow.color),
        DataGridCell<String>(columnName: 'SQ', value: dataGridRow.sq),
      ]);
    }).toList(growable: false);
  }
}

class Product {
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      finStoreName: json["FabricStoreName"],
      fName: json["FName"],
      thType: json["ThType"],
      thNo: json["ThNo"],
      unit: json["Unit"],
      fAdd: json["FAdd"],
      color: json["Color"],
      sq: json["SQ"],
    );
  }
  Product({
    required this.finStoreName,
    required this.fName,
    required this.thType,
    required this.thNo,
    required this.unit,
    required this.fAdd,
    required this.color,
    required this.sq,
  });
  final String finStoreName;
  final String fName;
  final String thType;
  final String thNo;
  final String unit;
  final String fAdd;
  final String color;
  final String sq;
}

class ListItem {
  String? finStoreCode;
  String? finStoreName;
  ListItem(this.finStoreCode, this.finStoreName);
}