import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/features/product/controller/product_controller.dart';

class ProductStatisticsPage extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Thống Kê Sản Phẩm'),
        backgroundColor: Colors.green.shade400,
      ),
      body: Obx(() {
        final totalProducts = controller.totalProducts.value;
        final categoryCounts = controller.categoryCounts;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị tổng số sản phẩm
              Text(
                'Tổng số sản phẩm: $totalProducts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Hiển thị số lượng sản phẩm theo từng loại
              Text(
                'Số lượng sản phẩm theo loại:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              if (categoryCounts.isEmpty)
                Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: categoryCounts.length,
                    itemBuilder: (context, index) {
                      final category = categoryCounts.keys.elementAt(index);
                      final count = categoryCounts[category]!;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            'Loại sản phẩm: $category',
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Text(
                            '$count sản phẩm',
                            style: TextStyle(fontSize: 14, color: Colors.green),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
