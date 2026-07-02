import 'package:get/get.dart';

import '../../firebase/server_manager_state.dart';
import '../../firebase/server_user_reference.dart';
import '../../model/server_user_model.dart';
import 'manager_restaurant_view_model.dart';

class ManagerRestaurantVMImp implements ManagerRestaurantViewModel {
  ServerManagerState serverManagerState = Get.find();
  @override
  Future registerServerUser(ServerUserModel serverUserModel) async {
    var result = await writeServerUserToFirebase(serverUserModel);
    if (result) {
      serverManagerState.isServerLogin.value =
          await checkIsServerUser(serverUserModel.uid);
      Get.back();
    }
  }
}
