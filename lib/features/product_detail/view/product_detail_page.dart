import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food_admin/features/product/model/product_model.dart';
import 'package:qlbh_eco_food_admin/features/product_detail/controller/product_detail_controller.dart';
import 'package:qlbh_eco_food_admin/features/users/model/user_model.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  ProductDetailPage({Key? key}) : super(key: key);
  final controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    final Product? product = Get.arguments as Product?;
    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lỗi'),
        ),
        body: Center(
          child: Text('Lỗi: Không tìm thấy sản phẩm.'),
        ),
      );
    }

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
            const SizedBox(height: 20),
            _buildCommentsSection(controller, product.documentId!),
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

  Widget _buildCommentsSection(
      ProductDetailController controller, String productId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bình luận',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoadingComments.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.comments.isEmpty) {
            return const Center(child: Text('Chưa có bình luận.'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.comments.length,
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
              final userId = comment.userId;
              final user = controller.userMap[userId];

              return ListTile(
                title: Text(comment.userName),
                subtitle: Text(comment.content),
                trailing:
                    Text(DateFormat('yyyy-MM-dd').format(comment.createdAt)),
                onTap: () {
                  if (user != null) {
                    // Show user details when tapping the comment
                    _showUserDetails(context, user);
                  }
                },
              );
            },
          );
        }),
        const SizedBox(height: 10),
        TextField(
          controller: controller.commentController,
          decoration: InputDecoration(
            labelText: 'Thêm bình luận',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => controller.addComment(),
          child: const Text('Gửi bình luận'),
        ),
      ],
    );
  }

// Function to display user details in a dialog
  void _showUserDetails(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thông tin người dùng'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tên: ${user.name}'),
              Text('Số điện thoại: ${user.phone}'),
              Text('Email: ${user.email}'),
              Text('Địa chỉ: ${user.address}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

}
