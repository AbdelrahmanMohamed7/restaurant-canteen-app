import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../consts.dart';
import '../model/address/address_model.dart';

class AddressController extends GetxController{
 CollectionReference  locationRef= FirebaseFirestore.instance.collection(users).doc(FirebaseAuth.instance.currentUser!.uid).collection(LOCATION_REF);
 Future<void> addAddress(AddressModel addressModel)async{
  try {
   await locationRef.add(addressModel.toJson());
  } on Exception catch (e) {
   print(e);
  }
 }
 Future<void> updateAddress(AddressModel addressModel,String docId)async{
  try {
   await locationRef.doc(docId).update(addressModel.toJson());
  } on Exception catch (e) {
   print(e);
  }
 }
 Future<void> deleteAddress(String docId)async{
  try {
   await locationRef.doc(docId).delete();
  } on Exception catch (e) {
   print(e);
  }
 }
}