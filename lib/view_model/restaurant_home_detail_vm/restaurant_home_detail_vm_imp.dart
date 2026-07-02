
import 'package:restaurant_cantine_app/view_model/restaurant_home_detail_vm/restaurant_home_detail_vm.dart';

import '../../firebase/best_deal_reference.dart';
import '../../firebase/popular_reference.dart';
import '../../model/popular_item_model.dart';

class RestaurantHomeDetailViewModelImp
    implements RestaurantHomeDetailViewModel {
  @override
  Future<List<PopularItemModel>> displayMostPopularByRestaurantId(
      String restaurantId) {
    return getMostPopularByRestaurantId(restaurantId);
  }

  @override
  Future<List<PopularItemModel>> displayBestDealsByRestaurantId(
      String restaurantId) {
    return getBestDealByRestaurantId(restaurantId);
  }
}
