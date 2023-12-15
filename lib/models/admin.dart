import 'dart:convert';

List<Admin> adminFromJson(String str) => List<Admin>.from(json.decode(str).map((x) => Admin.fromJson(x)));

String adminToJson(List<Admin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Admin {
    int? id;
    String? fullname;
    String? email;
    String? password;
    String? gender;

    Admin({
        this.id,
        this.fullname,
        this.email,
        this.password,
        this.gender,
    });

    factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        password: json["password"],
        gender: json["gender"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "password": password,
        "gender": gender,
    };
}
