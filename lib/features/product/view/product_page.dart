import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/product/controller/product_controller.dart';
import 'package:qlbh_eco_food_admin/features/product_detail/view/product_detail_page.dart';
import 'package:qlbh_eco_food_admin/features/search_product/view/search_product_page.dart';

class ProductPage extends GetView<ProductController> {
  ProductPage({super.key});

  @override
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Sản phẩm',
          style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Get.to(SearchProductPage());
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showAddProductDialog(context);
            },
          ),
        ],
        backgroundColor: AppColors.green.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.green.shade100, AppColors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: product.imageBase64.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.memory(
                                  base64Decode(product.imageBase64),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.image_not_supported,
                                size: 60,
                              ),
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Loại: ${product.categoryId}'),
                            Text('Giá: ${product.price.toStringAsFixed(2)} VND'),
                            Text('Kho: ${product.stock}'),
                            Text(
                              'Hạn sử dụng: ${DateFormat('dd/MM/yyyy').format(product.expiryDate)}',
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.to(() => ProductDetailPage(), arguments: product);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (product.documentId != null) {
                              _showDeleteConfirmationDialog(
                                  context, product.documentId!);
                            } else {
                              Get.snackbar('Lỗi',
                                  'Không thể xác định sản phẩm để xóa');
                            }
                          },
                        ),
                      ),
                    ).paddingOnly(top: 8);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Thêm mới sản phẩm',
            style: AppTextStyle.font24Re,
          ),
          content: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  _buildTextField(controller.nameController, 'Tên sản phẩm',
                      controller.nameError),
                  _buildTextField(controller.categoryController,
                      'Loại sản phẩm', controller.categoryError),
                  _buildTextField(controller.priceController, 'Giá tiền',
                      controller.priceError, TextInputType.number),
                  _buildTextField(controller.descriptionController, 'Mô tả',
                      controller.descriptionError),
                  _buildTextField(
                      controller.stockController,
                      'Số lượng hàng trong kho',
                      controller.stockError,
                      TextInputType.number),
                  TextFormField(
                    controller: controller.expiryDateController,
                    decoration: const InputDecoration(hintText: 'Ngày hết hạn'),
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
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Obx(() => controller.selectedImagePath.value.isEmpty
                      ? const Column(
                          children: [
                            Icon(Icons.image, size: 100, color: Colors.grey),
                            Text('Chưa chọn ảnh'),
                          ],
                        )
                      : Image.file(File(controller.selectedImagePath.value),
                          height: 100, fit: BoxFit.cover)),
                  ElevatedButton(
                    onPressed: () => controller.getImageGallery(),
                    child: const Text('Chọn ảnh'),
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => controller.validateAndAddProduct(),
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteProduct(productId);
                Navigator.of(context).pop();
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, RxString error,
      [TextInputType? keyboardType]) {
    return Obx(() => TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            errorText: error.value.isEmpty ? null : error.value,
          ),
          keyboardType: keyboardType,
          onChanged: (value) {
            if (value.isNotEmpty) error.value = '';
          },
        ));
  }
}
