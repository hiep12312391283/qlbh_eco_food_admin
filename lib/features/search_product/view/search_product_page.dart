import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/product/controller/product_controller.dart';
import 'package:qlbh_eco_food_admin/features/product_detail/view/product_detail_page.dart';

class SearchProductPage extends GetView<ProductController> {
  const SearchProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TextField(
            controller: controller.searchController,
            onChanged: (value) {
              controller.updateSearchQuery(value);
            },
            decoration: InputDecoration(
              hintText: 'Nhập tên sản phẩm',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white54),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          backgroundColor: AppColors.green.shade400,
        ),
        body: Obx(() {
          final filteredProducts = controller.products.where((product) {
            return product.name
                .toLowerCase()
                .contains(controller.searchQuery.value.toLowerCase());
          }).toList();
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
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
                      Text('Mã sản phẩm: ${product.id}'),
                      Text('Loại: ${product.category}'),
                      Text('Giá: ${product.price.toStringAsFixed(2)} VND'),
                      Text('Kho: ${product.stock}'),
                      Text(
                        'Hạn sử dụng: ${DateFormat('dd/MM/yyyy').format(product.expiryDate)}',
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Get.to(() => ProductDetailPage(), arguments: product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (product.documentId != null) {
                            // _showDeleteConfirmationDialog(
                            //     context, product.documentId!);
                          } else {
                            Get.snackbar(
                                'Lỗi', 'Không thể xác định sản phẩm để xóa');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ).paddingOnly(top: 8);
            },
          );
        }),
      ),
    );
  }
}
