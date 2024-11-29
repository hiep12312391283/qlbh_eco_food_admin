import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import gói intl
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/order/controller/order_controller.dart';
import 'package:qlbh_eco_food_admin/features/order/view/order_detail_page.dart'; // Import trang chi tiết đơn hàng

class OrderPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Đơn hàng', style: AppTextStyle.font24Semi.copyWith(color: Colors.white),),
        backgroundColor: AppColors.green.shade400
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.green.shade100, AppColors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(() {
          if (orderController.isLoading.value) {
            return Center(child: CircularProgressIndicator()); // Hiển thị loading
          }
          if (orderController.orders.isEmpty) {
            return Center(
              child: Text('Chưa có đơn hàng nào.', style: AppTextStyle.font16Re),
            );
          }
          return ListView.builder(
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              return GestureDetector(
                onTap: () {
                  // Điều hướng đến trang chi tiết đơn hàng khi nhấn vào đơn hàng
                  Get.to(() => OrderDetailPage(order: order));
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.receipt_long, color: Colors.green),
                            SizedBox(width: 8),
                            Text('ID đơn hàng: ${order.userId.toUpperCase()}',
                                style: AppTextStyle.font16Semi),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Khách hàng: ${order.userName}',
                                style: AppTextStyle.font16Re),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Địa chỉ giao hàng: ${order.userAddress}',
                                style: AppTextStyle.font16Re),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                                'Tổng tiền thanh toán: ${_formatCurrency(order.totalPrice)}',
                                style: AppTextStyle.font16Semi),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                                order.paymentMethod == 1
                                    ? Icons.money
                                    : Icons.credit_card,
                                color: Colors.purple),
                            SizedBox(width: 8),
                            Text(
                                'Phương thức thanh toán: ${order.paymentMethod == 1 ? 'Tiền mặt' : 'Online'}',
                                style: AppTextStyle.font16Re),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              order.orderStatus == 3
                                  ? Icons.check_circle
                                  : Icons.info,
                              color: order.orderStatus == 3
                                  ? Colors.green
                                  : Colors.blueGrey,
                            ),
                            SizedBox(width: 8),
                            Text(
                                'Trạng thái: ${_getOrderStatus(order.orderStatus)}',
                                style: AppTextStyle.font16Re),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Phương thức định dạng tiền tệ
  String _formatCurrency(double amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    return formatCurrency.format(amount);
  }

  // Phương thức lấy trạng thái đơn hàng
  String _getOrderStatus(int status) {
    List<String> statusList = [
      'Đã đặt hàng',
      'Đang chờ đơn vị vận chuyển',
      'Đang vận chuyển',
      'Đơn hàng đã được giao'
    ];
    return statusList[status];
  }
}
