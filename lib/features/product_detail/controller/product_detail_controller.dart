import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food_admin/features/product/controller/product_controller.dart';
import 'package:qlbh_eco_food_admin/features/product/model/product_model.dart';



class ProductDetailController extends GetxController {
  late Product product;

  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController stockController;
  late TextEditingController expiryDateController;

  @override
  void onInit() {
    super.onInit();

    // Khởi tạo product và các TextEditingController
    if (Get.arguments != null && Get.arguments is Product) {
      product = Get.arguments as Product;

      nameController = TextEditingController(text: product.name);
      categoryController = TextEditingController(text: product.category);
      priceController = TextEditingController(text: product.price.toString());
      descriptionController = TextEditingController(text: product.description);
      stockController = TextEditingController(text: product.stock.toString());
      expiryDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(product.expiryDate),
      );
    } else {
      Get.snackbar('Lỗi', 'Không có dữ liệu sản phẩm để chỉnh sửa.');
    }
  }

  void updateProduct() async {
    try {
      String documentId = product.documentId?.trim() ?? '';
      if (documentId.isEmpty) {
        Get.snackbar('Lỗi', 'Không thể xác định sản phẩm để chỉnh sửa.');
        return;
      }

      DateTime expiryDate;
      try {
        expiryDate =
            DateFormat('yyyy-MM-dd').parse(expiryDateController.text.trim());
      } catch (e) {
        Get.snackbar('Lỗi', 'Ngày hết hạn không hợp lệ.');
        return;
      }

      final updatedProductData = {
        'name': nameController.text.trim(),
        'category': categoryController.text.trim(),
        'price': double.tryParse(priceController.text.trim()) ?? product.price,
        'description': descriptionController.text.trim(),
        'stock': int.tryParse(stockController.text.trim()) ?? product.stock,
        'expiryDate': Timestamp.fromDate(expiryDate),
        'imageBase64': product.imageBase64,
      };

      // Cập nhật trong Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(documentId)
          .update(updatedProductData);

      // Cập nhật local state
      final updatedProduct = Product(
        id: product.id,
        name: updatedProductData['name'] as String,
        category: updatedProductData['category'] as String,
        price: updatedProductData['price'] as double,
        description: updatedProductData['description'] as String,
        stock: updatedProductData['stock'] as int,
        entryDate: product.entryDate,
        expiryDate: expiryDate,
        imageBase64: updatedProductData['imageBase64'] as String,
        documentId: documentId,
      );

      Get.find<ProductController>()
          .updateProductLocally(documentId, updatedProduct);

      Get.back();
      Get.snackbar('Thành công', 'Sản phẩm đã được cập nhật thành công!');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật sản phẩm: $e');
    }
  }
}
