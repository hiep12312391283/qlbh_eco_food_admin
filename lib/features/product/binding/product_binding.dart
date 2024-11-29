import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/features/product/controller/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
