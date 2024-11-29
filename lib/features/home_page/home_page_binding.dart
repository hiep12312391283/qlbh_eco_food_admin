import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/features/home_page/home_page_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() => HomePageController());
  }
}
