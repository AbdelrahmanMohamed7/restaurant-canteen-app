class AddressModel {
  String? landMark;
  double? lat;
  double? lang;

  AddressModel({this.landMark, this.lat, this.lang});

  AddressModel.fromJson(Map<String, dynamic> json) {
    landMark = json['land_mark'];
    lat = json['lat'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['land_mark'] = this.landMark;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    return data;
  }
}
