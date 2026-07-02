
import 'package:restaurant_cantine_app/model/size_model.dart';

import 'addon_model.dart';

class FoodModel {
  String description='',
      id='',
      name='',
      image='';
  double price = 0;
  List<SizeModel> size = List<SizeModel>.empty(growable: true);
  List<AddonModel> addon = [];

  FoodModel(
      {required this.description,
      required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.size,
      required this.addon});

  FoodModel.fromJson(Map<dynamic,dynamic>json) {
    name = json['name'];
    price = double.parse(json['price'].toString());
    id = json['id'];
    image = json['image'];
    description = json['description'];
    if(json['addon'] !=null){
      addon = List<AddonModel>.empty(growable: true);
      json['addon'].forEach((v){
        addon.add(AddonModel.fromJson(v));
      });
    }
    if(json['size']!= null){
      size= List<SizeModel>.empty(growable: true);
      json['size'].forEach((v){
        size.add(SizeModel.fromJson(v));
      });
    }
  }

  Map<String,dynamic> toJson(){
    final data = <String,dynamic>{};
    data ['description']=description;
    data['id']=id;
    data ['name']=name;
    data ['image']=image;
    data ['price']=price;
    data ['size']=size.map((v)=>v.toJson()).toList();
    data ['addon']=addon.map((v)=>v.toJson()).toList();

    return data;

  }
}