import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food_admin/features/product_detail/controller/product_detail_controller.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(controller.nameController, 'Tên sản phẩm'),
            const SizedBox(height: 10),
            _buildTextField(controller.categoryController, 'Loại sản phẩm'),
            const SizedBox(height: 10),
            _buildTextField(controller.priceController, 'Giá sản phẩm',
                TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField(controller.descriptionController, 'Mô tả sản phẩm'),
            const SizedBox(height: 10),
            _buildTextField(
                controller.stockController, 'Số lượng', TextInputType.number),
            const SizedBox(height: 10),
            TextFormField(
              controller: controller.expiryDateController,
              decoration: const InputDecoration(
                labelText: 'Ngày hết hạn',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  controller.expiryDateController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
            ),
            const SizedBox(height: 20),
            _buildImagePreview(controller.product.imageBase64),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => controller.updateProduct(),
                child: const Text('Lưu thay đổi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType? type]) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImagePreview(String base64Image) {
    if (base64Image.isEmpty) {
      return const Center(
        child: Text('Không có ảnh'),
      );
    }

    return Center(
      child: Image.memory(
        base64Decode(base64Image),
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
