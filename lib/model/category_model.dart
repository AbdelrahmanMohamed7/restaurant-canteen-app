import 'food_model.dart';

class CategoryModel{
  String key = '',
      name = '';
     String image = '';
  List<FoodModel> foods = List<FoodModel>.empty(growable: true);

  CategoryModel({
     required this.name,
    required this.image,
    required this.foods});

  CategoryModel.fromJson(Map<dynamic,dynamic>json) {
    name=json['name'];
    image=json['image'];
    if(json['foods'] != null){
      foods= List<FoodModel>.empty(growable: true);
      json['foods'].forEach((v){
        foods.add(FoodModel.fromJson(v));
      });
    }
  }

  Map<String,dynamic> toJson(){
    final data = <String,dynamic>{};
    data ['name']=name;
    data ['image']=image;
    data ['foods']=foods.map((v)=>v.toJson()).toList();

    return data;

  }
}
