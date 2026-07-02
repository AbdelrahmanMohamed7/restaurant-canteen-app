import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_cantine_app/screens/address/update_address.dart';
import '../../consts.dart';
import '../../controller/address_controller.dart';
import '../../model/address/address_model.dart';
import '../cart_screen.dart';
import 'add_address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
 AddressController addressController=Get.put(AddressController());
 late Stream<QuerySnapshot> _addressStream;
 @override
  void initState() {
   _addressStream=FirebaseFirestore.instance.collection(users).doc(FirebaseAuth.instance.currentUser!.uid).collection(LOCATION_REF).snapshots();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select An Address'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _addressStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              AddressModel addressModel=AddressModel.fromJson(data);
              return GestureDetector(
                onTap: (){

                  Get.to(() => CartDetailScreen(
                    userLatLng: LatLng(addressModel.lat!,addressModel.lang!)),
                  );
                },
                child: ListTile(
                  title: Text(addressModel.landMark.toString()),
                  trailing: Wrap(
                    children: [
                      IconButton(onPressed: (){
                       Get.to(()=>UpdateAddress(docId: document.id, latLng: LatLng(addressModel.lat!,addressModel.lang!), landMark: addressModel.landMark!,));

                      },icon: Icon(Icons.edit),),
                      IconButton(onPressed: (){
                        addressController.deleteAddress(document.id);

                      },icon: Icon(Icons.delete,color: Colors.red,),),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(()=>AddAddress());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
