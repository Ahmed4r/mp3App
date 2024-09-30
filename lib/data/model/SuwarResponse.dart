class SuwarResponse {
  List<Suwar>? suwar;

  SuwarResponse({this.suwar});

  SuwarResponse.fromJson(Map<String, dynamic> json) {
    if (json['suwar'] != null) {
      suwar = <Suwar>[];
      json['suwar'].forEach((v) {
        suwar!.add(new Suwar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.suwar != null) {
      data['suwar'] = this.suwar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suwar {
  int? id;
  String? name;
  int? startPage;
  int? endPage;
  int? makkia;
  int? type;

  Suwar(
      {this.id,
      this.name,
      this.startPage,
      this.endPage,
      this.makkia,
      this.type});

  Suwar.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startPage = json['start_page'];
    endPage = json['end_page'];
    makkia = json['makkia'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['start_page'] = this.startPage;
    data['end_page'] = this.endPage;
    data['makkia'] = this.makkia;
    data['type'] = this.type;
    return data;
  }
}
