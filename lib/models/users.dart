import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    required this.status,
    required this.data,
  });

  String status;
  List<Data> data;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    status: json["status"],
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Data {
  Data({
    required this.user,
  });

  String user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["FinCustName"],
  );

  Map<String, dynamic> toJson() => {
    "FinCustName": user,
  };
}
