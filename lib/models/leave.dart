import 'dart:convert';

List<Leave> leaveFromJson(String str) => List<Leave>.from(json.decode(str).map((x) => Leave.fromJson(x)));

String leaveToJson(List<Leave> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Leave {
    int? id;
    String? fullname;
    String? cause;
    String? date_start;
    String? date_end;
    String? gender;

    Leave({
        this.id,
        this.fullname,
        this.cause,
        this.date_start,
        this.date_end,
        this.gender,
    });

    factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        id: json["id"],
        fullname: json["fullname"],
        cause: json["cause"],
        date_start: json["date_start"],
        date_end: json["date_end"],
        gender: json["gender"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "cause": cause,
        "date_start": date_start,
        "date_end": date_end,
        "gender": gender,
    };
}