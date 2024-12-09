import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import gói intl
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/home_page/home_page_view.dart';
import 'package:qlbh_eco_food_admin/features/order/model/order_admin.dart';
import 'package:qlbh_eco_food_admin/features/order/controller/order_controller.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/features/order/view/order_page.dart';

class OrderDetailPage extends GetView<OrderController> {
  final OrderAdmin order;
  final OrderController orderController = Get.put(OrderController());
  OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Chi tiết đơn hàng',
              style: AppTextStyle.font24Semi.copyWith(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => _buildOrderStatus(orderController.orders
                            .firstWhere((o) => o.userId == order.userId)
                            .orderStatus),
                      ),
                      _buildDetailRow(
                        title: 'ID đơn hàng',
                        value: order.userId.toUpperCase().trim(),
                        icon: Icons.receipt_long,
                      ),
                      _buildDetailRow(
                        title: 'Địa chỉ giao hàng',
                        value: order.userAddress,
                        icon: Icons.location_on,
                      ),
                      _buildDetailRow(
                        title: 'Ngày đặt hàng',
                        value: _formatDateTime(order.orderDate),
                        icon: Icons.date_range,
                      ),
                      _buildDetailRow(
                        title: 'Tổng tiền thanh toán',
                        value: _formatCurrency(order.totalPrice),
                        icon: Icons.monetization_on,
                      ),
                      _buildDetailRow(
                        title: 'Phương thức thanh toán',
                        value: order.paymentMethod == 1 ? 'Tiền mặt' : 'Online',
                        icon: order.paymentMethod == 1
                            ? Icons.money
                            : Icons.credit_card,
                      ),
                      const SizedBox(height: 20),
                      Text('Sản phẩm:', style: AppTextStyle.font16Semi),
                      SizedBox(height: 10),
                      ...order.products
                          .map((item) => _buildProductRow(item))
                          .toList(),
                    ],
                  ),
                ),
              ),
              Obx(
                () => _buildActionButton(orderController.orders
                    .firstWhere((o) => o.userId == order.userId)
                    .orderStatus),
              ),
            ],
          ),
        ));
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text('$title:', style: AppTextStyle.font16Semi),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              style: AppTextStyle.font16Re,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(OrderItemAdmin item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          item.imageBase64.isNotEmpty
              ? Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(item.imageBase64)),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Icon(Icons.image_not_supported, size: 50),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatCurrency(item.price), // Định dạng giá tiền
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Số lượng: ${item.quantity}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(int status) {
    List<String> statusList = [
      'Đã đặt hàng',
      'Đang chờ đơn vị vận chuyển',
      'Đang vận chuyển',
      'Đơn hàng đã được giao'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trạng thái đơn hàng:', style: AppTextStyle.font16Semi),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(statusList.length, (index) {
            return Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        index <= status ? Colors.green : Colors.grey,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(statusList[index],
                      style: AppTextStyle.font12Re,
                      textAlign: TextAlign.center),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: (status + 1) / statusList.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ],
    );
  }

  Widget _buildActionButton(int status) {
    if (status == 3) {
      return const Center(
        child: Text(
          'Hoàn tất đơn hàng',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    List<String> buttonTexts = [
      'Đang chờ đơn vị vận chuyển',
      'Giao hàng cho shipper',
      'Hoàn tất đơn hàng'
    ];

    return Center(
      child: GestureDetector(
        onTap: () {
          if (status < 2) {
            _updateOrderStatus(order);
          } else {
            _confirmCompletion(order);
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.green.shade400,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Căn chỉnh các phần tử trong Row
            children: [
              // Text ở giữa
              Expanded(
                child: Text(
                  buttonTexts[status],
                  textAlign: TextAlign.center, // Đảm bảo Text ở giữa
                  style: AppTextStyle.font20Bo.copyWith(color: Colors.white),
                ),
              ),
              // Icon ở cuối Row
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateOrderStatus(OrderAdmin order) {
    if (order.orderStatus < 3) {
      orderController.updateOrderStatus(order, order.orderStatus + 1);
    }
  }

  void _confirmCompletion(OrderAdmin order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận hoàn tất đơn hàng'),
        content:
            const Text('Bạn có chắc chắn muốn hoàn tất đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              orderController.updateOrderStatus(order, 3);
              Get.toNamed("/home_page");
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    return formatCurrency.format(amount);
  }

  String _formatDateTime(DateTime dateTime) {
    final formatDateTime = DateFormat('dd/MM/yyyy HH:mm'); // Định dạng ngày giờ
    return formatDateTime.format(dateTime);
  }
}
