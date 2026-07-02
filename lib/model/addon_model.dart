class AddonModel{
  String name= '';
  double price=0;

  AddonModel({required this.name, required this.price});

  AddonModel.fromJson(Map<dynamic,dynamic> json)
  {
    name = json['name'];
    price = double.parse(json['price'].toString());
  }

  Map<dynamic,dynamic> toJson(){
    final data = <String,dynamic>{};
    data['name']=name;
    data['price']=price;
    return data;

  }
}